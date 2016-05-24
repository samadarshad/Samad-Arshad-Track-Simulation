function VectsStruct = get_vects(MeshSt,point3)




point_dx = interp2_custom(MeshSt.x_vec,MeshSt.y_vec,MeshSt.Fx,point3(:,1),point3(:,2),'nearest');
point_dy = interp2_custom(MeshSt.x_vec,MeshSt.y_vec,MeshSt.Fy,point3(:,1),point3(:,2),'nearest');
point_dz = (point_dx.^2+point_dy.^2);
sl_vec = [point_dx, point_dy, point_dz];
% hold on;



%normal at that position

norm_x = interp2_custom(MeshSt.x_mat,MeshSt.y_mat,MeshSt.Nx,point3(:,1),point3(:,2),'nearest');
norm_y = interp2_custom(MeshSt.x_mat,MeshSt.y_mat,MeshSt.Ny,point3(:,1),point3(:,2),'nearest');
norm_z = interp2_custom(MeshSt.x_mat,MeshSt.y_mat,MeshSt.Nz,point3(:,1),point3(:,2),'nearest');
n_vec = [norm_x, norm_y, norm_z];
% hold on;
% set(gca,'DataAspectRatio',[1 1 1]);% set data aspect ratio
% set(gca,'PlotBoxAspectRatio',[1 1 1]);% set plot box aspect ratio
% %quiver3(point(:,1),point(:,2),point_z,norm_x,norm_y,norm_z,20)

%cross product
cx_vec = cross(n_vec,sl_vec);
if cx_vec(:,3) > 1e-8
    %cross vector is not flat along ground i.e. is not a contour
end
cx_vec = bsxfun(@rdivide, cx_vec,sqrt(sum(abs(cx_vec).^2,2)));

VectsStruct.sl = sl_vec;
VectsStruct.n = n_vec;
VectsStruct.cx = cx_vec;



end