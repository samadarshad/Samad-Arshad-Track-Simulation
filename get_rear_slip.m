%function to get rear slip angles
%eqn 29

function alpha_rear = get_rear_slip(velo_normal,velo_tang,b,angular_velo,bank_angle)

alpha_rear =  (b*angular_velo*cosd(bank_angle) - velo_normal)/velo_tang;

end