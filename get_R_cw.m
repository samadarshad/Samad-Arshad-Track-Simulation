% kinematics to get R_cg, eqn 51
%lean in degrees
function R_cw = get_R_cw(R_w,D,lean_angle)

R_cw = R_w - (D/2)*sind(lean_angle);



end