%function to get aerodynamic coefficient based on point immediately ahead
%(e.g. 0.1*distance)


function avg_coeff = get_aero_coeff5(AeroGrid,current_position,next_position)


direction_vector = next_position - current_position;
division = 10; %could be dynamic variable which varies based on speed 
success_interp=false;
%end_coeff = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.Coeffs,next_position(1),next_position(2),'nearest');
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
        if i ==10
            %disp('gone to far into the linear interpolation - we could be travelling too slow');% such that we may be taking advantage of inside bends - the averaging should only be within the first few paces <5')            
            %exit the interpolation anyway
            success_interp = true;
        end
    else
        success_interp = true;
    end
    
    
    
end

%now we have a good set of coeffs, lets take the average
avg_coeff = coeff;





end