function [cx_vec,n_vec,sl_vec] = vect_at_point(px,py) %%in actual put the track as a variable

point = [px py];

%first check if the point is valid
%take interpolation of nearest point - if normal = vertical then invalid
test_norm_z = interp2_custom(x_mat,y_mat,testNz,point(:,1),point(:,2),'nearest');
if test_norm_z > 0.99
    return    %invalid point
end


% point = [-26 10];


point_z = interp2_custom(x_vec,y_vec,new_z_mat,point(:,1),point(:,2),'nearest');

point_dx = interp2_custom(x_vec,y_vec,Fx,point(:,1),point(:,2),'nearest');
point_dy = interp2_custom(x_vec,y_vec,Fy,point(:,1),point(:,2),'nearest');
point_dz = (point_dx^2+point_dy^2);
sl_vec = [point_dx, point_dy, point_dz];
sl_vec = sl_vec./norm(sl_vec);
%hold on;
%quiver3(point(:,1),point(:,2),point_z,point_dx,point_dy,point_dz,50)

%normal at that position

norm_x = interp2_custom(x_mat,y_mat,Nx,point(:,1),point(:,2),'nearest');
norm_y = interp2_custom(x_mat,y_mat,Ny,point(:,1),point(:,2),'nearest');
norm_z = interp2_custom(x_mat,y_mat,Nz,point(:,1),point(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
n_vec = n_vec./norm(n_vec);
hold on;
set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
cx_vec = cx_vec./norm(cx_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end

%quiver3(point(:,1),point(:,2),point_z,cx_vec(:,1),cx_vec(:,2),cx_vec(:,3),20)



end
