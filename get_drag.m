%function to get drag

%Billy finton section 3.1.3.1

function drag_force = get_drag(Cd_A,p,vD)

drag_force = Cd_A * 0.5 * p * vD * vD;


end