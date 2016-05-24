%function to initiate aerodynamic grid


%2D grid using MeshSt
AeroGrid.x_vec = MeshSt.x_vec;
AeroGrid.y_vec = MeshSt.y_vec;
AeroGrid.x_mat = MeshSt.x_mat;
AeroGrid.y_mat = MeshSt.y_mat;
AeroGrid.new_z_mat = MeshSt.new_z_mat;
AeroGrid.z_mat = MeshSt.z_mat;

%Aero coefficients grid
AeroGrid.Coeffs = ones(size(AeroGrid.z_mat));


