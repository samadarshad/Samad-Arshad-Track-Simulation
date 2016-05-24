%script to make vectors from point cloud

%gradient vectors at spacing 0.5 (mesh spacing)
[PX,PY] = gradient(new_z_mat,0.5,0.5)


 F = TriScatteredInterp(x_mat(:),y_mat(:),new_z_mat(:))