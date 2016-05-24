%Mock up of physics model

desired_speed = 10;
desired_position = [5,4];
desired_time = 3;


time_step = 0.001;
time_length = desired_time/time_step;
current_speed=[];
current_position=zeros(time_length,2);
current_time=[];
current_AWC=[];
i=1;
current_speed(i) = 1;
current_position(i,:) = [0,1];
current_time(i) = 0;
current_AWC(i) = 20000;

desired_height = 3;
current_height(i) = 0;

mass = 60;
weight = mass*10;
%to avoid dividing by 0
desired_height_change = desired_height-current_height(i);
height_energy_requirement = desired_height_change*weight;
desired_speed_of_height_change = desired_height_change/(desired_time - current_time(i));
desired_linear_acceleration = (desired_speed - current_speed(i))/(desired_time - current_time(i));
height_linear_power_requirement = height_energy_requirement/(desired_time-current_time(i));

for i = 1:time_length

% desired_linear_acceleration = (desired_speed - current_speed(i))/(desired_time - current_time(i));
desired_direction_xy = desired_position-current_position(i,:);
desired_direction_xy = desired_direction_xy./norm(desired_direction_xy);
% desired_height_change = desired_height-current_height(i);
% desired_speed_of_height_change = desired_height_change/(desired_time - current_time(i));

instant_drag_forces = 100;

% height_energy_requirement = desired_height_change*weight;
% height_linear_power_requirement = height_energy_requirement/(desired_time-current_time(i));
drag_instant_power_requirement = instant_drag_forces * current_speed(i);
linear_acceleration_power_requirement = mass*desired_linear_acceleration*(current_speed(i));

total_power_requirement = height_linear_power_requirement+drag_instant_power_requirement+linear_acceleration_power_requirement;

%apply power and acceleration, achieve change in current speed/time/pos/AWC

current_time(i+1) = current_time(i)+time_step;
current_AWC(i+1) = current_AWC(i) - total_power_requirement;
current_position(i+1,:) = current_position(i,:) + desired_direction_xy*current_speed(i)*time_step + 0.5*desired_direction_xy*desired_linear_acceleration*time_step^2;
current_speed(i+1) = current_speed(i) + time_step*desired_linear_acceleration;
current_height(i+1) = current_height(i) + desired_speed_of_height_change*time_step;


end