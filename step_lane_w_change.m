%function to give new index and position for a specific travelled distance
%along a lane (struct input to use the dS)

function [new_idx, new_pos] = step_lane_w_change(current_idx,step_size,old_lane,new_lane,lanes_struct)

distance_travelled=0;
lane_switch_distance=0;
%check if lane change:
if new_lane ~= old_lane
    %perform lane change and record distance - it is assumed that the
    %distance will be below the step_size, so that the rider can continue
    %to travel along the lane
    prev_pos = [lanes_struct(old_lane).X(current_idx) lanes_struct(old_lane).Y(current_idx) lanes_struct(old_lane).Z(current_idx)];
    [lane_idx, next_pos] = lane_change2(new_lane, lanes_struct, prev_pos);
    lane_switch_distance = norm(prev_pos - next_pos);
    current_idx = lane_idx;
    
    distance_travelled = distance_travelled+lane_switch_distance;
end

lane = lanes_struct(new_lane);

%want to travel 'step size' along lane
%therefore use culumative sum of lane.dS vector and find where it reaches
% stepsize


%return the index of the nearest index
new_idx = current_idx;
%old_pos = [lane.X(new_idx) lane.Y(new_idx) lane.Z(new_idx)]

while distance_travelled < step_size
    new_idx = new_idx+1;
    if new_idx > lane.Length %assumine we wont have step sizes of +250m which mean only one cross-over would take place
        distance_travelled = lane_switch_distance+ sum(lane.dS(current_idx:end)) + sum( lane.dS(1:new_idx-lane.Length));
    else
        
        distance_travelled = lane_switch_distance+ sum(lane.dS(current_idx:new_idx));
    end
    
    
    
    
end

if new_idx > lane.Length
    new_pos = [lane.X(mod(new_idx,lane.Length)) lane.Y(mod(new_idx,lane.Length)) lane.Z(mod(new_idx,lane.Length))];
    new_idx=mod(new_idx,lane.Length);
else
    new_pos = [lane.X(new_idx) lane.Y(new_idx) lane.Z(new_idx)];
end


end