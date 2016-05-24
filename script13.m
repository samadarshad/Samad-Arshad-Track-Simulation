%script to incoorporate physics
%script for steering and correct distance of lane switches
%also possibly aerodynamics smoke model

clear lanes
g = 10; %gravity
p = 1; %air density
v_air = 0; %velocity of air


num_players = 3;
riders = cyclist_struct(num_players);

riders(1).position(1,:) = [-28 10 0];
riders(1).velocity = 10*ones(1,100);
riders(1).color = 'ro';
riders(1).property_color = 'red'

riders(2).position(1,:) = [-28 10 0];
riders(2).velocity = 10*ones(1,100);
riders(2).color = 'bo';
riders(2).property_color = 'blue';

riders(3).position(1,:) = [-28 10 0];
riders(3).velocity = 10*ones(1,100);
riders(3).color = 'go';
riders(3).property_color = 'green';


lanes(1) = lane_to_struct([base.X;base.Y;base.Level*ones(size(base.X))]',[165 42 42]./255);
lanes(2) = lane_to_struct(sm_lane,'black');
lanes(3) = lane_to_struct(sm_red_lane,'red');
lanes(4) = lane_to_struct(sm_blue_lane,'blue');




riders(1).lane = 2;
riders(2).lane = 3;
riders(3).lane = 4;

%for all players
for pl = 1:num_players
    riders(pl).mass = 60;
    riders(pl).Cd_A = 0.2;
    riders(pl).h_cg = 1;
end

%for all lanes
for lane_num = 1:4
lanes(lane_num).vectors = struct();
lanes(lane_num).vectors = get_lane_vects(lanes(lane_num),MeshSt)'; %this is long
%get lane centres of curvatures
lanes(lane_num).radius_curvatures = struct();
% lanes(lane_num).radius_curvatures = radiusCurvature_modified(lanes(lane_num).X,lanes(lane_num).Y);
% %smoothen vector
% lanes(lane_num).radius_curvatures = smooth_lane_1D(lanes(lane_num).radius_curvatures);

lanes(lane_num).radius_curvatures = smooth_radius(lanes(lane_num).X,lanes(lane_num).Y);



end



%get_lane_vects(lanes(1),MeshSt)';
%lane_struct.R = get_rad_curv(lane_struct)
%% Correct the cyclist to a lane/their chosen lane

for i = 1:num_players
lane_number = riders(i).lane;
riders(i).lane_idx =  dsearchn([lanes(lane_number).X lanes(lane_number).Y],riders(i).position(1,1:2));
riders(i).position(1,:) = [lanes(lane_number).X(riders(i).lane_idx) ...
                      lanes(lane_number).Y(riders(i).lane_idx) ...
                      lanes(lane_number).Z(riders(i).lane_idx) ];
riders(i).vectors = get_vects(MeshSt,riders(i).position(1,:));
end


%% initialise plots

race_length = 100;

% select the plots you want to plot (only 3 at a time)
plot_height = 0;
plot_bank = 0;
plot_steer = 1;
plot_roll = 1;
plot_incline = 0;
plot_incline_pwr = 1;

plot_num = 1; %for position on the subplots
g_object_num = 1; %for player.gobject(i), the 'if' statement still returns true if(h) where h = 5

h = figure;
ax1 = h.CurrentAxes;;
%subplot(3,2,[2 4 6],ax1)

if plot_height
test_h = subplot(3,2,plot_num,ax1)
hold on
title('Height from base (meters)','HandleVisibility','off'); %retaining title after overwrites
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num+2;
plot_height = g_object_num;
g_object_num = g_object_num+1;
end

if plot_bank
test_b = subplot(3,2,plot_num,ax1)
hold on
title('Bank Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num+2;
plot_bank = g_object_num;
g_object_num = g_object_num+1;
end

if plot_steer
test_s = subplot(3,2,plot_num,ax1)
hold on
title('GROUND Steer Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num + 2;
plot_steer = g_object_num;
g_object_num = g_object_num+1;
end

if plot_roll
test_r = subplot(3,2,plot_num,ax1)
hold on
title('Roll Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num + 2;
plot_roll = g_object_num;
g_object_num = g_object_num+1;
end

if plot_incline
test_i = subplot(3,2,plot_num,ax1)
hold on
title('Incline Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num + 2;
plot_incline = g_object_num;
g_object_num = g_object_num+1;
end

if plot_incline_pwr
test_i_p = subplot(3,2,plot_num,ax1)
hold on
title('Incline Power (Joules)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
plot_num = plot_num + 2;
plot_incline_pwr = g_object_num;
g_object_num = g_object_num+1;
end

test_3d = subplot(3,2,[2 4 6],ax1)
view(3)
subplot(test_3d)
hold on
plot_lane_st(lanes(1),h)
plot_lane_st(lanes(2),h)
plot_lane_st(lanes(3),h)
plot_lane_st(lanes(4),h)

% point_plot(cell2mat([{riders.position}']),cell2mat([{riders.color}']),h);
for player = 1:num_players
riders(player).gobjects(4) = point_plot2(riders(player).position(1,:), riders(player).color, h);
end

%% initial plots (zero-lines)

% initial plot, height 
if plot_height
 subplot(test_h)
 hold on
    for player = 1:num_players
         
    riders(player).height = zeros(race_length,1);   
    riders(player).height(1) =riders(player).position(1,3); 
   % riders(player).gobjects(1) = plot(test_h,riders(player).height,'Color',riders(player).property_color);
     riders(player).gobjects(plot_height) = plot(riders(player).height,'Color',riders(player).property_color);
  
    end
end

% initial plot, bank
if plot_bank
subplot(test_b)
hold on
    for player = 1:num_players        
    riders(player).bank_angle = zeros(race_length,1);
  %  riders(player).gobjects(2) = plot(test_b,riders(player).bank_angle,'Color',riders(player).property_color);
  riders(player).gobjects(plot_bank) = plot(riders(player).bank_angle,'Color',riders(player).property_color);
    end
end

% initial plot, steer
if plot_steer
subplot(test_s)
hold on
    for player = 1:num_players      
    riders(player).steer_angle = zeros(race_length,1);
    %riders(player).gobjects(3) = plot(test_s,riders(player).steer_angle,'Color',riders(player).property_color);
    riders(player).gobjects(plot_steer) = plot(riders(player).steer_angle,'Color',riders(player).property_color);
    end
end
    
if plot_roll
subplot(test_r)
hold on
    for player = 1:num_players      
    riders(player).roll_angle = zeros(race_length,1);
    %riders(player).gobjects(3) = plot(test_s,riders(player).steer_angle,'Color',riders(player).property_color);
    riders(player).gobjects(plot_roll) = plot(riders(player).roll_angle,'Color',riders(player).property_color);
    end
end

if plot_incline
subplot(test_i)
hold on
    for player = 1:num_players      
    riders(player).incline_angle = zeros(race_length,1);
    %riders(player).gobjects(3) = plot(test_s,riders(player).steer_angle,'Color',riders(player).property_color);
    riders(player).gobjects(plot_incline) = plot(riders(player).incline_angle,'Color',riders(player).property_color);
    end
end

if plot_incline_pwr
subplot(test_i_p)
hold on
    for player = 1:num_players      
    riders(player).power_inclination = zeros(race_length,1);
    %riders(player).gobjects(3) = plot(test_s,riders(player).steer_angle,'Color',riders(player).property_color);
    riders(player).gobjects(plot_incline_pwr) = plot(riders(player).power_inclination,'Color',riders(player).property_color);
    end
end
    
%% iterate position

for i= 1:race_length
%perform a step and update properties
%lane change when i = 50


for player = 1:num_players  
    if i == 50 && player ==1
        [new_idx, new_pos] = step_lane_w_change(riders(1).lane_idx,riders(1).velocity(i),riders(1).lane,3,lanes);
        riders(1).lane = 3;
    else
        [new_idx, new_pos] = step_lane(riders(player).lane_idx,riders(player).velocity(i),lanes(riders(player).lane));
    end
    
    riders(player).lane_idx = new_idx;
    riders(player).position(i,:) = new_pos;
    riders(player).height(i) = riders(player).position(i,3);
    prev_dir = riders(player).vectors.cx; %temporary for 1-time step for steering angle. Could incoorporate smoothening over more time steps
    
    riders(player).vectors = get_vects(MeshSt,riders(player).position(i,:));
    
    if i > 2
        riders(player).steer_angle(i) = get_steer2(riders(player).position(i-2:i,:));
    else
        riders(player).steer_angle(i) = get_steer(riders(player).vectors.cx,prev_dir);
    end
    
    riders(player).bank_angle(i) = get_bank(riders(player).position(i,:),riders(player).vectors);
    
    Rw = lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx);
    if i > 1
        riders(player).incline(i) = get_incline(riders(player).position(i-1:i,:));        
        riders(player).lean_angle(i) = get_lean(riders(player).incline(i),riders(player).velocity(i),g,Rw,riders(player).h_cg);
        riders(player).roll_angle(i) = riders(player).lean_angle(i) - riders(player).bank_angle(i);
    else
        riders(player).incline(i) = 0;
        riders(player).lean_angle(i) = 0;
        riders(player).roll_angle(i) = 0;
    end
    
    %section 3.1.2 Billy Finton Report
    riders(player).power_inclination(i) = riders(player).mass * g * sind(riders(player).incline(i)) * norm(riders(player).velocity(i)); 
    %assumed velocity is in direction that the rider travelled previously, so taking norm of velocity
    riders(player).power_drag(i) = get_drag(riders(player).Cd_A,p,(riders(player).velocity(i) - v_air))*riders(player).velocity(i);
    
    %get necessary steer
    test_steer2(i,player) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).velocity(i),lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx));
    test_a_velo(i,player) = riders(player).velocity(i)/lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx);
    
    
end





% update plots
 subplot(test_3d)
for player = 1:num_players
   
riders(player).gobjects(4) = update_plot(riders(player).position(i,:), riders(player).gobjects(4));
end

%height plot
if plot_height
subplot(test_h)
hold on
for player = 1:num_players
riders(player).gobjects(plot_height) = update_properties_plot(riders(player).height,riders(player).gobjects(plot_height));
end
end


%bank plot
if plot_bank
subplot(test_b)
hold on
for player = 1:num_players
riders(player).gobjects(plot_bank) = update_properties_plot(riders(player).bank_angle,riders(player).gobjects(plot_bank));
end
end

%steer plot
if plot_steer
subplot(test_s)
hold on
for player = 1:num_players
riders(player).gobjects(plot_steer) = update_properties_plot(riders(player).steer_angle,riders(player).gobjects(plot_steer));
end
end

if plot_roll
subplot(test_r)
hold on
for player = 1:num_players
riders(player).gobjects(plot_roll) = update_properties_plot(riders(player).roll_angle,riders(player).gobjects(plot_roll));
end
end

if plot_incline
subplot(test_i)
hold on
for player = 1:num_players
riders(player).gobjects(plot_incline) = update_properties_plot(riders(player).incline_angle,riders(player).gobjects(plot_incline));
end
end

if plot_incline_pwr
subplot(test_i_p)
hold on
for player = 1:num_players
riders(player).gobjects(plot_incline_pwr) = update_properties_plot(riders(player).power_inclination,riders(player).gobjects(plot_incline_pwr));
end
end



pause(0.1)
end



