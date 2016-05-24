%script to make the mesh struct
function [MeshSt, VectsStruct] = MeshStruct
load('Working1feb.mat')
% nan_zeros_test = isnan(Fx).*Fx + isnan(Fy).*Fy + isnan(Nx).*Nx + isnan(Ny).*Ny + isnan(Nz).*Nz;
% cropped_z = new_z_mat + nan_zeros_test;
%% normal
% MeshSt = struct('x_vec',x_vec,'y_vec',y_vec,'x_mat',x_mat,'y_mat',y_mat,'Fx',Fx,'Fy',Fy,'Nx',Nx,'Ny',Ny,'Nz',Nz,'new_z_mat',...
%     new_z_mat, 'orig_z', z_mat)

%% cropped z
% MeshSt = struct('x_vec',x_vec,'y_vec',y_vec,'x_mat',x_mat,'y_mat',y_mat,'Fx',Fx,'Fy',Fy,'Nx',Nx,'Ny',Ny,'Nz',Nz,'new_z_mat',...
%     cropped_z, 'fullz',new_z_mat)



%% expanded dx
% %expand Dx and Dy
% [PX,PY] = gradient(new_z_mat,0.1,0.1)
% MeshSt = struct('x_vec',x_vec,'y_vec',y_vec,'x_mat',x_mat,'y_mat',y_mat,'Fx',PX,'Fy',PY,'Nx',Nx,'Ny',Ny,'Nz',Nz,'new_z_mat',...
%     cropped_z, 'fullz',new_z_mat)

%% inpainted dx (using fileexchange) using interpolation and extrapolation (Warning about extrapolation)

iptFx = inpaint_nans(Fx);
iptFy = inpaint_nans(Fy);
iptNx = inpaint_nans(Nx);
iptNy = inpaint_nans(Ny);
iptNz = inpaint_nans(Nz);
MeshSt = struct('x_vec',x_vec,'y_vec',y_vec,'x_mat',x_mat,'y_mat',y_mat,'Fx',iptFx,'Fy',iptFy,'Nx',iptNx,'Ny',iptNy,'Nz',iptNz,'new_z_mat',...
    new_z_mat,'z_mat', z_mat)

%% script for struct of vectors

VectsStruct = struct('sl',[],'n',[],'cx',[])

end