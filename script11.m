%script 11 - more object orientated
num_players = 3;
riders = cyclist_struct(num_players);

riders(1).position(1,:) = [-28 10 0];
riders(1).velocity = 10*ones(1,100);
riders(1).color = 'ro';
riders(1).property_color = 'red';

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


h = figure;
ax1 = h.CurrentAxes;;
%subplot(3,2,[2 4 6],ax1)
test_h = subplot(3,2,1,ax1)
hold on
title('Height from base (meters)','HandleVisibility','off'); %retaining title after overwrites
set(gca,'NextPlot','replacechildren') ;
test_b = subplot(3,2,3,ax1)
hold on
title('Bank Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
test_s = subplot(3,2,5,ax1)
hold on
title('Steer Angle (degrees)','HandleVisibility','off');
set(gca,'NextPlot','replacechildren') ;
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
 
 subplot(test_h)
 hold on
    for player = 1:num_players
         
    riders(player).height = zeros(race_length,1);   
    riders(player).height(1) =riders(player).position(1,3); 
   % riders(player).gobjects(1) = plot(test_h,riders(player).height,'Color',riders(player).property_color);
     riders(player).gobjects(1) = plot(riders(player).height,'Color',riders(player).property_color);
  
    end
    
% initial plot, bank
subplot(test_b)
hold on
    for player = 1:num_players        
    riders(player).bank_angle = zeros(race_length,1);
  %  riders(player).gobjects(2) = plot(test_b,riders(player).bank_angle,'Color',riders(player).property_color);
  riders(player).gobjects(2) = plot(riders(player).bank_angle,'Color',riders(player).property_color);
    end
% initial plot, steer
subplot(test_s)
hold on
    for player = 1:num_players      
    riders(player).steer_angle = zeros(race_length,1);
    %riders(player).gobjects(3) = plot(test_s,riders(player).steer_angle,'Color',riders(player).property_color);
    riders(player).gobjects(3) = plot(riders(player).steer_angle,'Color',riders(player).property_color);
    end

    
 
    
%% iterate position

for i= 1:race_length
%perform a step and update properties
%lane change when i = 60
if i == 50
    [riders(1).lane, riders(1).lane_idx, riders(1).position(i,:)] = lane_change(3,lanes,riders(1).position(i-1,:), MeshSt);
end

for player = 1:num_players    
    [new_idx, new_pos] = step_lane(riders(player).lane_idx,riders(player).velocity(i),lanes(riders(player).lane));
    riders(player).lane_idx = new_idx;
    riders(player).position(i,:) = new_pos;
    riders(player).height(i) = riders(player).position(i,3);
    prev_dir = riders(player).vectors.cx; %temporary for 1-time step for steering angle. Could incoorporate smoothening over more time steps
    
    riders(player).vectors = get_vects(MeshSt,riders(player).position(i,:));
    %riders(player).steer_angle(i) = get_steer(riders(player).vectors.cx,prev_dir);
    if i > 2
        riders(player).steer_angle(i) = get_steer2(riders(player).position(i-2:i,:));
    else
        riders(player).steer_angle(i) = get_steer(riders(player).vectors.cx,prev_dir);
    end
    
    riders(player).bank_angle(i) = get_bank(riders(player).position(i,:),riders(player).vectors);
    
    if i > 1
    riders(player).incline(i) = get_incline(riders(player).position(i-1:i,:));
    else
        riders(player).incline(i) = 0;
    end
end





% update plots
 subplot(test_3d)
for player = 1:num_players
   
riders(player).gobjects(4) = update_plot(riders(player).position(i,:), riders(player).gobjects(4));
end

%height plot
subplot(test_h)
hold on
for player = 1:num_players
riders(player).gobjects(1) = update_properties_plot(riders(player).height,riders(player).gobjects(1));
end

%bank plot
subplot(test_b)
hold on
for player = 1:num_players
riders(player).gobjects(2) = update_properties_plot(riders(player).bank_angle,riders(player).gobjects(2));
end

%steer plot
subplot(test_s)
hold on
for player = 1:num_players
riders(player).gobjects(3) = update_properties_plot(riders(player).steer_angle,riders(player).gobjects(3));
end

pause(0.1)
end



