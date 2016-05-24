%function to get rear slip angles
%eqn 27

function camber_front = get_camber_front(roll_angle,steer,rake)

camber_front = roll_angle + steer*sind(rake);

end