%function to calculate rollling resistance based on lateral slip angle,
%pressure and camber angle
%eqn 69,70 in BF report

function C_rr = get_roll_resistance_coeff(slip,camber)
pressure_wheel = 130; %psi

%by experimental data
C_rr_a = 0.00168*(exp(0.621*slip))*(1+0.29*((100/pressure_wheel)-1));

%assumed linear
mu_y = 0.0072;
C_rr = C_rr_a * (1+ camber*mu_y);









end