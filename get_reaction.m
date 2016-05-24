%functions in Billy Finton's Report section 3.1.4 (rolling resistance)
%eqn 12

function P_contact = get_reaction(m,g,incline,V_cg,R_cg)


P_contact = m * sqrt( g*cosd(incline)^2 + (V_cg^4)/(R_cg^2));


end