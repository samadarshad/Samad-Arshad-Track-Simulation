%function to get coefficient AT current position, then offset by the
%cyclist's own bluff coefficient (at the centre)

%position is CURRENT position i.e. will need to do (i-1) in the script
function coeff = get_aero_coeff3(AeroGrid,position,bluff_centre_coefficient)



coeff = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,position(1),position(2),'nearest');

coeff = coeff/bluff_centre_coefficient;
if coeff > 1
    coeff = 1;
end

end