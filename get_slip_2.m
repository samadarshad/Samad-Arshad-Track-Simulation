%function to get slip angles
%eqn 24/25 rearranged

function alpha = get_slip_2(roll_angle,camber_angle,Cy,Ca)

%if tangential velocity = 0, then take limit of alpha = 90 degrees

alpha = (tand(roll_angle) - camber_angle*Cy)/Ca;


end