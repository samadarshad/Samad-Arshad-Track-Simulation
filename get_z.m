function p_z = get_z(MeshSt,point)

p_z = interp2_custom(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat,point(:,1),point(:,2));

end