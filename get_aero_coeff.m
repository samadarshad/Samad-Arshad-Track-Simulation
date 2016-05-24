%function to get aerodynamic coefficient based on position interpolation

function coeff = get_aero_coeff(AeroGrid,position)

coeff = interp2_custom(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,position(1),position(2),'nearest');




end