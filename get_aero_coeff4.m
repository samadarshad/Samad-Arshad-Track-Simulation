%function to get aerodynamic coefficient based on position interpolation
%and averaging between the point immediately ahead of you and your final
%destination


function avg_coeff = get_aero_coeff4(AeroGrid,current_position,next_position)


direction_vector = next_position - current_position;
division = 9; %could be dynamic variable which varies based on speed 
success_interp=false;
end_coeff = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,next_position(1),next_position(2),'nearest');
current_pos_idx = [interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,current_position(1),current_position(2),'nearest') interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,current_position(1),current_position(2),'nearest')];
i =1;
while success_interp==false
   
    
    set_points = current_position + i*direction_vector./division;
    coeff = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,set_points(1),set_points(2),'nearest');
    idx = [interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,set_points(1),set_points(2),'nearest') interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,set_points(1),set_points(2),'nearest')];
        
    
    %want to compare indexes to ensure current-index is not the same as any of
    %the set_point indexes along the trajectory
    
    if isequal(idx,current_pos_idx)
        %disp('taking aero coeff on current position - need to move off current position')
        i = i+1; % i.e. do step further away from teh current position
        if i ==5
            disp('gone to the middle')
            coeff = end_coeff;
            success_interp = true;
        end
    else
        success_interp = true;
    end
    
    
    
end

%now we have a good set of coeffs, lets take the average
avg_coeff = 0.5*(end_coeff+coeff);





end