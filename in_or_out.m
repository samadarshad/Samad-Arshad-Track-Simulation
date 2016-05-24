function in_flag = in_or_out(MeshSt,point)
in_val = -0.135%-0.225; %z-value of the inner surface of the real mesh
out_val = 9.3; % '' outer surface


p_z = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.z_mat,point(:,1),point(:,2));
if p_z <= in_val
    in_flag = true;
elseif p_z >= out_val
    in_flag = false;
else
    in_flag = nan;
end
    
end