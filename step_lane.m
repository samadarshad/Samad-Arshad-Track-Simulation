%function to give new index and position for a specific travelled distance
%along a lane (struct input to use the dS)

function [new_idx, new_pos] = step_lane(current_idx,step_size,lane)

%want to travel 'step size' along lane

%therefore use culumative sum of lane.dS vector and find where it reaches
% stepsize


%return the index of the nearest index
new_idx = current_idx;
%old_pos = [lane.X(new_idx) lane.Y(new_idx) lane.Z(new_idx)]
distance_travelled=0;
while distance_travelled < step_size
    new_idx = new_idx+1;
    if new_idx > lane.Length %assumine we wont have step sizes of +250m which mean only one cross-over would take place
        distance_travelled = sum(lane.dS(current_idx:end)) + sum( lane.dS(1:new_idx-lane.Length));
    else
        
        distance_travelled = sum(lane.dS(current_idx:new_idx));
    end
    
    
    
    
end

if new_idx > lane.Length
    new_pos = [lane.X(mod(new_idx,lane.Length)) lane.Y(mod(new_idx,lane.Length)) lane.Z(mod(new_idx,lane.Length))];
    new_idx=mod(new_idx,lane.Length);
else
    new_pos = [lane.X(new_idx) lane.Y(new_idx) lane.Z(new_idx)];
end


end