% %artifical steer in
% steer_in_angle default = 10
%vel = [cx_veloity, slope velocity], single player only
function new_vel = artif_steer_in(vel,steer_in_angle)
%find the magnitude of velocity
mag = norm(vel);
%change steer angle by 10 degrees inwards?
t_angle = vel(2)/vel(1); %i.e. slope / contour velocities
angle = atand(t_angle);
%negative angle defined as steering inwards
angle2 = angle - steer_in_angle;


%keeping magnitude constant
new_vel(2) = mag*sind(angle2);

new_vel(1) = mag*cosd(angle2);



end