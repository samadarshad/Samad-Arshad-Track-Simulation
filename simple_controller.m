%simple PD controller (input distance deficit, current velocity) calculated
%the acceleration needed and the power associated with that acceleration (
%F=ma, P = Fv = mav)


function power_needed = simple_controller(desired_distance,actual_distance,power_lost, max_power,current_velocity,overall_mass); %

needed_dist = desired_distance - actual_distance;


catchup_time = 0.3; %seconds to catch up - used to calculate acceleration for closing the needed_dist deficit

needed_accel = (needed_dist - current_velocity*catchup_time)*2/(catchup_time^2);

power_needed = overall_mass*needed_accel*current_velocity;
power_needed = real(power_needed + power_lost);

%find the acceleration needed to catch up in 1 second



%negative power?
if power_needed<0;
    power_needed=0;
end

%saturation of power
if power_needed > max_power;
    power_needed = max_power;
end


end



%FOR PLOTTING
% 
% needed_dist = -5:0.5:5;
% relax_factor=1;
% relax_slope = 200; %i.e. the K multiplier in the controller
% figure; plot(needed_dist,relax_slope.*sign(needed_dist).*(abs(needed_dist).^relax_factor))
