%control system function that gives the open-loop output (closed-loop
%achieved through iterations in time in the outer main function)
%function gives the chasing rider the needed power to catch up to their
%target

%input - desired relative-position (i.e. usually something like -2 meters, but in the sprint scenario we could make it +100meters
% so that the rider trying to overtake with max power is achieved. other inputs: actual position (this is the feedback
%part), power lost, and the 'desperate-calculated-or-chill' factor of the
%rider which determines how hard they push the pedals to catch up if theyre
%far away, or if they just take it steady and slowly

%relax_factor = 1: calculated, 0.5 = desperate, 2 = relaxing to catch up
%etc. ofcourse in the sprint, the relax_factor would be like 0.1 or 0, with
%desired distance being 100meters ahead
%whereas early in the race it would be more relaxed i.e. 10 or 5.

%relax slope is the actual slope of the 'calculated' power line. 


function power_needed = controlled_position_to_power(desired_distance,actual_distance,power_lost, max_power); %,relax_factor,relax_slope)

needed_dist = desired_distance - actual_distance;


relax_factor=2;
relax_slope = 2; %i.e. the K multiplier in the controller

power_needed = power_lost + relax_slope.*sign(needed_dist).*(abs(needed_dist).^relax_factor);

%negative power?
if power_needed<0;
    power_needed=0;
end

%saturation of power
if power_needed > max_power;
    power_needed = max_power;
end


end