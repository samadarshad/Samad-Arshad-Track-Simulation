%function to energise aerogrid as a rider is on the position


function new_coeffs = energise_aerogrid(AeroGrid,position, contour_direction,Bluff)  %assumed rider is travelling along contour direction for simplicity - in reality direction may be different i.e. changing lanes


%interpolate to find discrete position on grid
% idx_x = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,position(:,1),position(:,2),'nearest');
% idx_y = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,position(:,1),position(:,2),'nearest');

%get body shape and energisation values (i.e. bluff body)
%currently let this be a single point on the grid
%Bluff = get_bluff();

kernel = get_kernel(AeroGrid, Bluff, position, contour_direction);

new_coeffs = AeroGrid.Coeffs.*kernel;
%translate bluff body to position on grid (rotation not included because is
%circular)


%apply single convolution with the 2d kernel multiplication
%energise by halving current value?


end