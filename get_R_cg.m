% kinematics to get R_cg, eqn 51
%lean in degrees
function R_cg = get_R_cg(R_w,h_cg,lean_angle)

R_cg = R_w - h_cg*sind(lean_angle);



end