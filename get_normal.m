%function to get normal force eqn 17
%roll in degrees
function F_n = get_normal(P_contact,roll)

F_n = P_contact * cosd(roll);

end