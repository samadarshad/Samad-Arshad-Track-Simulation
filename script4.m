%Script 4 - moving up slope
track_surf=surf(x_vec,y_vec,new_z_mat)
axis square
set(track_surf, 'edgecolor','none')
%1) take current point
point = [25.2 0]
point = [12.6 46.6]
hold on;
 hPlot = plot3(NaN,NaN,NaN,'ro');
 
%interpolate to find z
point_z = interp2(x_vec,y_vec,new_z_mat,point(:,1),point(:,2)) 

point3 = [point point_z]
set(hPlot,'XData',point3(1),'YData',point3(2),'ZData',point3(3));

for i = 1:5
%2) find direction of contour

point_dx = interp2(x_vec,y_vec,Fx,point3(:,1),point3(:,2));
point_dy = interp2(x_vec,y_vec,Fy,point3(:,1),point3(:,2));
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
hold on;
quiver3(point3(:,1),point3(:,2),point3(:,3),point_dx,point_dy,point_dz,10)



%normal at that position

norm_x = interp2(x_mat,y_mat,Nx,point3(:,1),point3(:,2));
norm_y = interp2(x_mat,y_mat,Ny,point3(:,1),point3(:,2));
norm_z = interp2(x_mat,y_mat,Nz,point3(:,1),point3(:,2));
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

quiver3(point3(:,1),point3(:,2),point_z,cx_vec(:,1),cx_vec(:,2),0,20) %flat arrow for contour direction

% move in guessed directon
step = 1;
point3_next = point3 + step*sl_vec; %holding z
plot3(point3_next(1),point3_next(2),point3_next(3),'bo');

% 3) interpolate to land on mesh
point_z = interp2(x_vec,y_vec,new_z_mat,point3_next(:,1),point3_next(:,2)); 
defect = point_z - point3_next(3)


point3_next(3) = point_z;

plot3(point3_next(1),point3_next(2),point3_next(3),'ro');

point3 = point3_next;
drawnow
pause(1)
end