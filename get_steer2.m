%get steer - using positions rather than vectors, to overcome lane-change
%problem


%position vector is a vector of size 3x3, where 3 points are used to
%determine steer

function steer_angle = get_steer2(position_vector)
prev_dir = position_vector(2,:)-position_vector(1,:);
next_dir = position_vector(3,:)-position_vector(2,:);

steer_angle = atan2(norm(cross(next_dir',prev_dir')),dot(next_dir',prev_dir'));
steer_angle = 180/pi * steer_angle;


end