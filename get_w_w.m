%function to get angular velocity at centre of wheel
%eqn 53

function w_w = get_w_w(angular_velo,lean_angle,v_cw,wheel_diameter)

w_w_cyclist = v_cw / (wheel_diameter/2);

w_w = [angular_velo*sind(lean_angle)-w_w_cyclist, angular_velo*cosd(lean_angle), 0];

end