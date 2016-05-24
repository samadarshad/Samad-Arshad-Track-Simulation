function point_on_cx = reset_to_cx(MeshSt, starting_pt, guessed_pt)


S = contourcs(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat,[starting_pt(3) starting_pt(3)]);
                cline_vec = [[S.X]' [S.Y]'];
                idx_nearest = dsearchn(cline_vec,[guessed_pt(1) guessed_pt(2)]);
                point_on_cx = [cline_vec(idx_nearest,1:2) S(1).Level]; %

end
