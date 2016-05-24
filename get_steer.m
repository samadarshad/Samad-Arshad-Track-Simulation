%get steer
%steer calculated by relative angle difference between current direction
%and previous timestep direction


function steer_angle = get_steer(dir,prev_dir)
contour_vector = prev_dir;
contour_vector_next = dir;
steer_angle = atan2(norm(cross(contour_vector_next',contour_vector')),dot(contour_vector_next',contour_vector'));
steer_angle = 180/pi * steer_angle;


end