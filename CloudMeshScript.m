load('Pt_cloudmesh.mat')
x_vec = PointCloud(1,2:end);
y_vec = PointCloud(2:end,1);
z_mat = PointCloud(2:end,2:end);



track_surf = surf(x_vec,y_vec,z_mat);

y_mat = repmat(y_vec,1,124);
x_mat = repmat(x_vec,217,1);

[Nx,Ny,Nz] = surfnorm(x_mat,y_mat,z_mat);


%only keep the non-horizontal surface
new_z_mat = z_mat;
idx = (Nz >= 0.99);
new_z_mat(idx) = NaN;
track_surf = surf(x_vec,y_vec,new_z_mat);
[Nx,Ny,Nz] = surfnorm(x_mat,y_mat,new_z_mat);

%trim off any z higher than 6

idx = (z_mat >= 6);
new_z_mat(idx) = NaN;
track_surf = surf(x_vec,y_vec,new_z_mat);
[Nx,Ny,Nz] = surfnorm(x_mat,y_mat,new_z_mat);

%spacing between mesh is 0.5
[Fx,Fy] = gradient(new_z_mat,0.5,0.5);

%test norm
[~,~,testNz] = surfnorm(x_mat,y_mat,z_mat);
%% Take a point on the surface and find its gradients - using nearest interp
track_surf = surf(x_vec,y_vec,new_z_mat);
axis square
view([0 0 1])
for click =1:10
[px,py] = ginput(1);
point = [px py];

% point = [-26 10];


point_z = interp2_custom(x_vec,y_vec,new_z_mat,point(:,1),point(:,2),'nearest');

point_dx = interp2_custom(x_vec,y_vec,Fx,point(:,1),point(:,2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(:,1),point(:,2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
hold on;
quiver3(point(:,1),point(:,2),point_z,point_dx,point_dy,point_dz,50)



%normal at that position

norm_x = interp2_custom(x_mat,y_mat,Nx,point(:,1),point(:,2),'nearest');
norm_y = interp2_custom(x_mat,y_mat,Ny,point(:,1),point(:,2),'nearest');
norm_z = interp2_custom(x_mat,y_mat,Nz,point(:,1),point(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
hold on;
set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end

quiver3(point(:,1),point(:,2),point_z,cx_vec(:,1),cx_vec(:,2),cx_vec(:,3),20)
end
%% put a cyclist on the track at the point

%starting point
point = [-26 10];
%head in contour direction
vect_at_point(-26,10)
%move forward a step (make sure were still on contour plane)

%point in contour direction, move etc.

%%
track_surf = surf(x_vec,y_vec,new_z_mat);
axis square
view([0 0 1])
point = [-26 10];
for i = 1:100
%first check if the point is valid
%take interpolation of nearest point - if normal = vertical then invalid
test_norm_z = interp2_custom(x_mat,y_mat,testNz,point(:,1),point(:,2),'nearest');
if test_norm_z > 0.99
    return    %invalid point
end

point_z = interp2_custom(x_vec,y_vec,new_z_mat,point(:,1),point(:,2),'nearest');
point_dx = interp2_custom(x_vec,y_vec,Fx,point(:,1),point(:,2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(:,1),point(:,2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
hold on;
quiver3(point(:,1),point(:,2),point_z,point_dx,point_dy,point_dz,50)

%normal at that position

norm_x = interp2_custom(x_mat,y_mat,Nx,point(:,1),point(:,2),'nearest');
norm_y = interp2_custom(x_mat,y_mat,Ny,point(:,1),point(:,2),'nearest');
norm_z = interp2_custom(x_mat,y_mat,Nz,point(:,1),point(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
hold on;
set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end

quiver3(point(:,1),point(:,2),point_z,cx_vec(:,1),cx_vec(:,2),cx_vec(:,3),20)

point = point + 3*cx_vec(:,[1,2]);
%need to force the point to remain within the plane i.e. have no z movement
%from previous point on the track - there is only one contour line that
%allows this. 


%later will force the point to be within specific steps from each other
%(linear approx to distance between two points on velo)

drawnow
end


%% SCALAXTRIX TRACKS
%create a polygon cutout of the mesh at a particular height
 C = contourc(x_vec,y_vec,new_z_mat,5);
Cmulti = contourc(x_vec,y_vec,new_z_mat,[0 0.2 0.4 0.6 0.8 1 1.5 2 2.5 3 3.5 4 4.5]); 
%arbitrary contour heights - could change this to be lane spacing 

%want to constrain rider to within this contour, but dont want to have
%difficulty of when rider changes lanes

%use contour as a way for the rider to find the 'next' position by nearest
%interpolation? i.e. as a correction factor?
s = getcontourlines(C);
%s is messy and needs to be concanated because many have different lines
%are the same contour - can do this later

%just focus on the first contour
plot(s(1).x,s(1).y);
%get point to traverse along it
%can use radial convexity that there is only one solution in radial
%direction from centre
%i.e. find current point against centre, make angle (10 degrees?
% some linear approximation of distance?),
%intersect ray with contour, plot second point
%%
contourspaces = [0 0.2 0.4 0.6 0.8 1 1.5 2 2.5 3 3.5 4 4.5]


    C = contourc(x_vec,y_vec,new_z_mat,contourspaces);
    s = getcontourlines(C);



plot(s(1).x,s(1).y);
%%

%take point on s, and iterate along it, measuring the distance between them

s1 = s(1);

height = s1.v;

pos = [s1.x' s1.y']

    
for j = 1:1000
    i = mod(5*j,617)
point = pos(i,:);
%first check if the point is valid
%take interpolation of nearest point - if normal = vertical then invalid
test_norm_z = interp2_custom(x_mat,y_mat,testNz,point(:,1),point(:,2),'nearest');
if test_norm_z > 0.99
    return    %invalid point
end

point_z = interp2_custom(x_vec,y_vec,new_z_mat,point(:,1),point(:,2),'nearest');
point_dx = interp2_custom(x_vec,y_vec,Fx,point(:,1),point(:,2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(:,1),point(:,2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
hold on;
quiver3(point(:,1),point(:,2),point_z,point_dx,point_dy,point_dz,50)

%normal at that position

norm_x = interp2_custom(x_mat,y_mat,Nx,point(:,1),point(:,2),'nearest');
norm_y = interp2_custom(x_mat,y_mat,Ny,point(:,1),point(:,2),'nearest');
norm_z = interp2_custom(x_mat,y_mat,Nz,point(:,1),point(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
hold on;
set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end

quiver3(point(:,1),point(:,2),point_z,cx_vec(:,1),cx_vec(:,2),cx_vec(:,3),20)

%need to force the point to remain within the plane i.e. have no z movement
%from previous point on the track - there is only one contour line that
%allows this. 


%later will force the point to be within specific steps from each other
%(linear approx to distance between two points on velo)

drawnow
end

%%
track_surf = surf(x_vec,y_vec,new_z_mat);
set(track_surf, 'edgecolor','none')
axis square
view([0 0 1])

%%
contour(x_vec,y_vec,new_z_mat)
% get a point to travel 300 meters along contour v = 0.2
cont =2; %only 2-5 works, other contours are broken
pos = 1;
[~,c_size] = size(new_s(cont).x);
point = [new_s(cont).x(pos) new_s(cont).y(pos) ]
hold on;
 hPlot = plot(NaN,NaN,'ro');

  
 xlim([-30 30]);
 ylim([-50 50]);
 
 for mini_time_st=1:3000
     pos = mod(mini_time_st,c_size);
     if pos == 0
         pos = 1
     end
     
     point = [new_s(cont).x(pos) new_s(cont).y(pos) ];
     % update the plot graphics object with the next position
     set(hPlot,'XData',point(1),'YData',point(2));
     
     % pause for 0.5 seconds
     pause(0.001)
 end
%% do more accurate distance movement and velocity rather than just a step per contour ste

contour(x_vec,y_vec,new_z_mat)
axis square
% get a point to travel 300 meters along contour v = 0.2
cont =2; %only 2-5 works, other contours are broken
pos = 1;
[~,c_size] = size(new_s(cont).x);
point = [new_s(cont).x(pos) new_s(cont).y(pos) ]
hold on;
 hPlot = plot(NaN,NaN,'ro');
 set(hPlot,'XData',point(1),'YData',point(2));
 distance_trav = 0;
  
 xlim([-30 30]);
 ylim([-50 50]);
 
 velocity = 40;
 time_step = 0.05;
 dist_per_step = velocity*time_step;
 dist_needed = dist_per_step;
 velo_reached =0;
 mini_time_st = 1;
 time_trav = 0;
 tic
 while ~velo_reached
     
     pos = mod(mini_time_st,c_size);
     if pos == 0
         pos = 1
     end
     old_pt = point;
     
     point = [new_s(cont).x(pos) new_s(cont).y(pos) ];
     distance_trav = distance_trav+norm(point-old_pt);
     if distance_trav >=dist_needed
         if toc <= time_step %update only every -timestep- seconds
             pause(time_step-toc)
           end
          set(hPlot,'XData',point(1),'YData',point(2));
         % velo_reached = true
           drawnow
           dist_needed = dist_needed+ dist_per_step;
           tic
     else 
         mini_time_st = mini_time_st +1;
         
     end
    % pause(0.01)
     % update the plot graphics object with the next position
%      set(hPlot,'XData',point(1),'YData',point(2));
    
     % pause for 0.5 seconds
      %pause(0.001)
 end

%% switch lanes
contour(x_vec,y_vec,new_z_mat)
axis square
cont =2; %only 2-5 works, other contours are broken
pos = 1;
[~,c_size] = size(new_s(cont).x);
point = [new_s(cont).x(pos) new_s(cont).y(pos) ]
point3 = [new_s(cont).x(pos) new_s(cont).y(pos) new_s(cont).v]
hold on;
 hPlot = plot(NaN,NaN,'ro');
 set(hPlot,'XData',point(1),'YData',point(2));
 distance_trav = 0;
  
 xlim([-30 30]);
 ylim([-50 50]);
 
 %velocity = 40;

%get slope vector at that point


point_dx = interp2_custom(x_vec,y_vec,Fx,point(1),point(2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(1),point(2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];

lane_velo = 1; %1 m/s lane change
 time_step = 0.05;
 dist_per_step = lane_velo*time_step;
 dist_needed = dist_per_step;
 velo_reached =0;
 mini_time_st = 1;
 time_trav = 0;
distance_travel = 0;
 while ~velo_reached
     old_pt = point3;
point3 = point3 + lane_velo*sl_vec;
%interpolate nearest mesh point
% point3_interp(1) = interp1(x_vec,point3(1),'nearest');
% point3_interp(2) = interp1(y_vec,point3(2),'nearest');
point3_interp(1) = point3(1);
point3_interp(2) = point3(2);

point3_interp(3) = interp2_custom(x_vec,y_vec,new_z_mat,point3(1),point3(2),'nearest');
point_dx = interp2_custom(x_vec,y_vec,Fx,point(1),point(2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(1),point(2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];


distance_travel = distance_travel+norm(point3_interp-old_pt);
 if distance_travel >=dist_needed
    set(hPlot,'XData',point3_interp(1),'YData',point3_interp(2));
    drawnow
    dist_needed = dist_needed+dist_per_step;
     end 
pause(0.1)
 end
 


%%
fig_h = figure; % Open the figure and put the figure handle in fig_h
% set(fig_h,'KeyPressFcn',@(fig_obj,eventDat) eventDat.Key); 
% This assigns the string value of the key to a in the base workspace.
set(fig_h,'KeyPressFcn',@(H,E) assignin('base','a',E.Key));

set(fig_h,'KeyReleaseFcn',@(H,E) assignin('base','a',0));
if a=='uparrow'
    velocity = velocity+1
    disp(velocity)
end

%% both velocity and lane change at the same time

%% NO lane velocity - just like scalatrix - lane switch by contours, nearest contour

%do a lane switch every 5 seconds
contour(x_vec,y_vec,new_z_mat)
axis square
% get a point to travel 300 meters along contour v = 0.2
cont =2; %only 2-5 works, other contours are broken
pos = 1;
[~,c_size] = size(new_s(cont).x);
point = [new_s(cont).x(pos) new_s(cont).y(pos) ]
hold on;
 hPlot = plot(NaN,NaN,'ro');
 set(hPlot,'XData',point(1),'YData',point(2));
 distance_trav = 0;
  
 xlim([-30 30]);
 ylim([-50 50]);
 
 velocity = 40;
 time_step = 0.05;
 dist_per_step = velocity*time_step;
 dist_needed = dist_per_step;
 velo_reached =0;
 mini_time_st = 1;
 time_trav = 0;
 tic;
 lane_clock = tic;
 
 vertical_vec = [0 0 1];
 while ~velo_reached
     
     
         
     pos = mod(mini_time_st,c_size);
     if pos == 0
         pos = 1
     end
     old_pt = point;
     
     point = [new_s(cont).x(pos) new_s(cont).y(pos) ];   
     
     lane_toc = toc(lane_clock);
     if lane_toc > 2
         
        point_dx = interp2_custom(x_vec,y_vec,Fx,point(1),point(2),'nearest');
        point_dy = interp2_custom(x_vec,y_vec,Fy,point(1),point(2),'nearest');
        point_dz = (point_dx^2+point_dy^2);
        sl_vec = [point_dx, point_dy, point_dz];
        
        height_difference = new_s(cont+1).v - new_s(cont).v; 
        angle_difference = dot(vertical_vec,sl_vec)/norm(sl_vec); %cos theta
        dist_diff = height_difference/angle_difference;
        point = point + (dist_diff)*[sl_vec(1) sl_vec(2)];
        cont = cont+1;
        % find new 'pos' across the contour
       disp('test')
        new_point_in_new_cont(1) = interp2_custom(new_s(cont).x,new_s(cont).y,new_s(cont).x,point(1),point(2),'nearest')
        
        
         lane_clock = tic; 
     end
     
     
     distance_trav = distance_trav+norm(point-old_pt);
     if distance_trav >=dist_needed
         if toc <= time_step %update only every -timestep- seconds
             pause(time_step-toc)
           end
          set(hPlot,'XData',point(1),'YData',point(2));
         % velo_reached = true
           drawnow
           dist_needed = dist_needed+ dist_per_step;
           tic
     else 
         mini_time_st = mini_time_st +1;
         
     end
    % pause(0.01)
     % update the plot graphics object with the next position
%      set(hPlot,'XData',point(1),'YData',point(2));
    
     % pause for 0.5 seconds
      %pause(0.001)
 end
