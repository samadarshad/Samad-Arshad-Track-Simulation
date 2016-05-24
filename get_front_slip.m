%function to get front slip angles
%eqn 28

function alpha_front = get_front_slip(steer_angle,rake_angle,velo_normal,velo_tang,a,angular_velo,bank_angle)



alpha_front = steer_angle*cosd(rake_angle) - (velo_normal + a*angular_velo*cosd(bank_angle))/velo_tang;


end