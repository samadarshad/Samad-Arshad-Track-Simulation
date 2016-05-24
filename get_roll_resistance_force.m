%function to get roll resistance force
%eqn 28

function F_R_x = get_roll_resistance_force(normal_force,roll_coeff)

F_R_x = normal_force*roll_coeff;


end