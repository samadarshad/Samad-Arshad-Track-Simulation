%function to get lean angle (degrees) using force balance and iterative method, from
%Billy Finton's report 3.1.4, eqn 15


function lean_angle = get_lean(incline_angle,v_cg,g,Rw,h_cg)

angle_guess(1) = 0;
for i = 1:5
angle_guess(i+1) = atan( v_cg^2 / (g * cosd(incline_angle)*(Rw - h_cg*sin(angle_guess(i)))));
end
lean_angle = angle_guess(end) * 180/pi;
end