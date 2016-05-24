%function to get acceleration 
%eqn 61

function a_cg = get_a_cg_starting(Tmax,GR,R_cw,R_cg,R_c,m_w,m_c,D,lean,Ic1,Ic2,Iw1,Iw2)

numerator = Tmax * (R_cw/(R_cg*GR*D/2));

denom = m_w*(R_cw/R_cg)^2 + 0.5*m_c*(R_c/R_cg)^2 + Iw1*((sind(lean)/R_cg) - R_cw/(R_cg*(D/2)))^2 + 0.5*Ic1*(sind(lean)/R_cg)^2 + (Iw2 + 0.5*Ic2)*(cosd(lean)/R_cg)^2;

a_cg = numerator/denom;

end