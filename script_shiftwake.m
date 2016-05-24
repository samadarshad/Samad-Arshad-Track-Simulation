%function to create wake from position
%use position to offset the wake u value

function wakeprofile = shift_wake_profile(highreswake,lane,u_offset)

max_u_wake = lane.tracklength;
u_modded = mod(lane.aero_mapping.u+u_offset,max_u_wake);
wakeprofile = get_wake(u_modded,lane.aero_mapping.v,highreswake);


% scatter3(lanes(1).aero_mapping.x,lanes(1).aero_mapping.y,wakeprofile); 
% zlim([0 1])

end

