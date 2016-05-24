%function to get lane jumping in a specificed time

%creating a stepped ramp
function s_ramp = swooping_timed_stepped_ramp(lane_start,lane_end,time_of_drop,dt)

s_ramp = linspace(lane_start,lane_end,time_of_drop/dt);
s_ramp = round(s_ramp);









end
