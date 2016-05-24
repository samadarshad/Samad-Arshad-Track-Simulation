%script 7 steering - need to functionalise the script for steering and
%having multiple riders



% track_surf=surf(x_vec,y_vec,new_z_mat)
% axis square
% set(track_surf, 'edgecolor','none')
contour(x_vec,y_vec,new_z_mat)
axis square

hold on;
 hPlot = plot3(NaN,NaN,NaN,'ro');
 
%1) take current point
point = [-28 12]

velocity = [10*ones(1,100); 0.01*ones(1,50) 0.01*ones(1,50)];


%interpolate to find z
point_z = interp2(x_vec,y_vec,new_z_mat,point(:,1),point(:,2)) 

point3 = [point point_z]
set(hPlot,'XData',point3(1),'YData',point3(2),'ZData',point3(3));
[origC, hc] = contour(x_vec,y_vec,new_z_mat,[point3(3) point3(3)],'b--');

sl_out = true;
for i = 1:100
%2) find direction of contour

vel = velocity(:,i);
if vel(2) >= 0
    sl_out = true;
else
    sl_out = false;
end



point_dx = interp2(x_vec,y_vec,Fx,point3(:,1),point3(:,2),'nearest');
point_dy = interp2(x_vec,y_vec,Fy,point3(:,1),point3(:,2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
hold on;



%normal at that position

norm_x = interp2(x_mat,y_mat,Nx,point3(:,1),point3(:,2),'nearest');
norm_y = interp2(x_mat,y_mat,Ny,point3(:,1),point3(:,2),'nearest');
norm_z = interp2(x_mat,y_mat,Nz,point3(:,1),point3(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
hold on;
set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
%quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end
cx_vec = cx_vec./norm(cx_vec);
    %quiver3(point3(:,1),point3(:,2),point_z,cx_vec(:,1),cx_vec(:,2),0,20) %flat arrow for contour direction
    dist = 0;
    step = vel(1)*0.5; %small steps until you reach velocity-step
    point3_next = [];
    
if sl_out %slope is positive which is risky, so do CX first then SL
        while dist <= vel(1)
            % move in guessed directon 
            % contour move
                point3_next = point3 + step*[cx_vec(:,1) cx_vec(:,2) 0]; %holding z
            % find out whether we are outside the x-y bounds of the velodrome i.e. the 'z' position cannot be found for this x-y
            %see the 'z' position and compare with NaN
            point_z_Test = interp2(x_vec,y_vec,new_z_mat,point3_next(:,1),point3_next(:,2));

                if isnan(point_z_Test) || any(isnan(point3_next)) %constrant to mesh
                %we've gone off the mesh
                disp('off the mesh')
                %option: NaN it or change direction. 
                %long-term would be to NaN it for prediction purposes. But short
                %term do a change-direction? - what about the effect of slope
                %velocity? should we combine both contour and slope movement, THEN
                %determine if we've moved off the velodrome (i.e. z NaN)? 

                end
                %plot(point3_next(1),point3_next(2),'bo');


            % 3) interpolate to origional contour required

            % take origional contour
               % [origC, hc] = contour(x_vec,y_vec,new_z_mat,[point3(3) point3(3)],'b--');
                S = contourcs(x_vec,y_vec,new_z_mat,[point3(3) point3(3)]);
                cline_vec = [[S.X]' [S.Y]'];
                idx_nearest = dsearchn(cline_vec,[point3_next(1) point3_next(2)]);
                interp_point = [cline_vec(idx_nearest,1:2) S(1).Level]; %assuming the same contour levels within S

                dist = norm(interp_point - point3);
                step = step + vel(1)*0.25; %increase step size to reach velo distance
        end
            %confirm that this is actually a point on the mesh - i.e. compare z values
            %of interpolated z to the s level
                point_z_Test = interp2(x_vec,y_vec,new_z_mat,interp_point(:,1),interp_point(:,2));

        if S(1).Level ~= point_z_Test
            disp('we are on the mesh')
        else
            disp('we are NOT on the mesh')
            defect_cx = S(1).Level - point_z_Test
        end


        %confirm that S.Level is the same as origional level
        if S(1).Level == point3(:,3)
            disp('we have remained on the same contour line')
            point3_next = interp_point;
        end




        %slope vector - which can be steerable
        distz = 0;
        point3 = point3_next;
        step_lane = vel(2)*0.5;
        sl_vec = sl_vec./norm(sl_vec);
       
        while distz < vel(2) 
        %quiver3(point3(:,1),point3(:,2),point3(:,3),point_dx,point_dy,point_dz,10)

        point3_next = point3 + step_lane*sl_vec; 


        % 3) interpolate to land on mesh
        point_z = interp2(x_vec,y_vec,new_z_mat,point3_next(:,1),point3_next(:,2)); 
        %steer inwards if NaN
        if isnan(point_z)
            vel(2) = vel(2) - step_lane;
            %need to check if vel(2) has become negative so we enter the
            %negative slope routine.
           %and restart to the beginning of the 'i' loop
        else
        distz = point_z - point3(3);
        %point3_next(3) = point_z;
        step_lane = step_lane+ vel(2)*0.25;
        end
        
        end 

end

if ~sl_out %slope is negative which is safe, so do SL first then CX
    


        distz = 0;
        
        step_lane = vel(2)*0.5;
        sl_vec = sl_vec./norm(sl_vec);
        while distz > vel(2)

        %quiver3(point3(:,1),point3(:,2),point3(:,3),point_dx,point_dy,point_dz,10)

        point3_next = point3 + step_lane*sl_vec; 


        % 3) interpolate to land on mesh
        point_z = interp2(x_vec,y_vec,new_z_mat,point3_next(:,1),point3_next(:,2)); 
        if isnan(point_z) %assuming NaN because on the outside of the mesh (rather than the inside hole)
            vel(2) = vel(2) - step_lane;
            %need to check if vel(2) has become negative so we enter the
            %negative slope routine.
           %restart to the beginning of the i'loop
        else
        
        distz = point_z - point3(3);
        %point3_next(3) = point_z;
        step_lane = step_lane+ vel(2)*0.25;
        end
        
        end 
    point3 = point3_next;
    while dist <= vel(1)
            % move in guessed directon 
            % contour move
                point3_next = point3 + step*[cx_vec(:,1) cx_vec(:,2) 0]; %holding z
            % find out whether we are outside the x-y bounds of the velodrome i.e. the 'z' position cannot be found for this x-y
            %see the 'z' position and compare with NaN
            point_z_Test = interp2(x_vec,y_vec,new_z_mat,point3_next(:,1),point3_next(:,2));

                if isnan(point_z_Test) || any(isnan(point3_next)) %constrant to mesh
                %we've gone off the mesh
                disp('off the mesh')
                %option: NaN it or change direction. 
                %long-term would be to NaN it for prediction purposes. But short
                %term do a change-direction? - what about the effect of slope
                %velocity? should we combine both contour and slope movement, THEN
                %determine if we've moved off the velodrome (i.e. z NaN)? 

                end
                %plot(point3_next(1),point3_next(2),'bo');


            % 3) interpolate to origional contour required

            % take origional contour
               % [origC, hc] = contour(x_vec,y_vec,new_z_mat,[point3(3) point3(3)],'b--');
                S = contourcs(x_vec,y_vec,new_z_mat,[point3(3) point3(3)]);
                cline_vec = [[S.X]' [S.Y]'];
                idx_nearest = dsearchn(cline_vec,[point3_next(1) point3_next(2)]);
                interp_point = [cline_vec(idx_nearest,1:2) S(1).Level]; %assuming the same contour levels within S

                dist = norm(interp_point - point3);
                step = step + vel(1)*0.25; %increase step size to reach velo distance
        end
            %confirm that this is actually a point on the mesh - i.e. compare z values
            %of interpolated z to the s level
                point_z_Test = interp2(x_vec,y_vec,new_z_mat,interp_point(:,1),interp_point(:,2));

        if S(1).Level ~= point_z_Test
            disp('we are on the mesh')
        else
            disp('we are NOT on the mesh')
            defect_cx = S(1).Level - point_z_Test
        end


        %confirm that S.Level is the same as origional level
        if S(1).Level == point3(:,3)
            disp('we have remained on the same contour line')
            point3_next = interp_point;
        end


    
    
 
end

plot3(point3_next(1),point3_next(2),point3_next(3),'ro');

point3 = point3_next;
drawnow
pause(0.1)
end