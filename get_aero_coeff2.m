%function to get aerodynamic coefficient based on position interpolation
%and averaging between the point immediately ahead of you and your final
%destination

% edit: there may be some influence of the rider's own sheltering on
% himself?

function avg_coeff = get_aero_coeff2(AeroGrid,current_position,next_position)

%take a set of points between current and next position for the averaging
%of coefficients in the aerogrid. Note, that we cant take the actual
%current position (because that will be influenced by the cyclist) rather
%take the position just immediately ahead of the current position




direction_vector = next_position - current_position;
division = 5;
success_interp=false;

while success_interp==false
    set_points = [];
    coeff = [];
    idx = [];
    for i = 1:division
        set_points(i,:) = current_position + i*direction_vector./division;
        coeff(i) = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,set_points(i,1),set_points(i,2),'nearest');
        idx(i,:) = [interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,set_points(i,1),set_points(i,2),'nearest') interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,set_points(i,1),set_points(i,2),'nearest')];
        
    end
    %want to compare indexes to ensure current-index is not the same as any of
    %the set_point indexes along the trajectory
    current_pos_idx = [interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,current_position(1),current_position(2),'nearest') interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,current_position(1),current_position(2),'nearest')];
    if any(ismember(idx,current_pos_idx,'rows'))
        disp('taking aero coeff on current position - need to move off current position')
        division = division-1;
        if division == 0
            disp('division too sparse error')
        end
    else
        success_interp = true;
    end
    
    
    
end

%now we have a good set of coeffs, lets take the average
avg_coeff = mean(coeff);





end