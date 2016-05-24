%script 15
%incoorporates power and power losses for each rider and calculted
%aerodynamic losses

%bool to prevent running of lanes i.e. 1 slow, 0 fast (skip lanes)
new = 0;


%script to incoorporate physics
%script for steering and correct distance of lane switches
%test out aerodynamic smoke model

close all

g = 10; %gravity
p = 1; %air density
v_air = 0; %velocity of air


num_players = 3;
riders = cyclist_struct(num_players);
test_velo = 5;
race_length = 100;
test_power = 10;

riders(1).position(1,:) = [-28 10 0];
riders(1).velocity = test_velo*ones(1,race_length);
riders(1).power_input = test_power*ones(1,race_length);
riders(1).color = 'ro';
riders(1).property_color = 'red';

riders(2).position(1,:) = [-28 10 0];
riders(2).velocity = test_velo*ones(1,race_length);
riders(2).power_input = test_power*ones(1,race_length);
riders(2).color = 'bo';
riders(2).property_color = 'blue';

riders(3).position(1,:) = [-28 10 0];
riders(3).velocity = test_velo*ones(1,race_length);
riders(3).power_input = test_power*ones(1,race_length);
riders(3).color = 'go';
riders(3).property_color = 'green';





riders(1).lane = 2;
riders(2).lane = 3;
riders(3).lane = 4;

%for all players
for pl = 1:num_players
    riders(pl).mass = 60;
    riders(pl).Cd_A = 0.2;
    riders(pl).h_cg = 1;
    riders(pl).C_br = 0.001;
    riders(pl).a = 0.4; %m
    riders(pl).b = 0.6; %m
    riders(pl).rake_angle = 20; %deg
    riders(pl).wheel_diameter = 0.67; %m
    riders(pl).Ca = 0.267;
    riders(pl).Cy = 0.02;
    riders(pl).r_br = 0.012; %m bearing radius
    riders(pl).base_Cd_A = 0.219;
    % preallocating memory for speed
    
    
end




%% for all lanes - LONG, only do if a completely new sim
if new
    
    clear lanes
    lanes(1) = lane_to_struct([base.X;base.Y;base.Level*ones(size(base.X))]',[165 42 42]./255);
    lanes(2) = lane_to_struct(sm_lane,'black');
    lanes(3) = lane_to_struct(sm_red_lane,'red');
    lanes(4) = lane_to_struct(sm_blue_lane,'blue');
    
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
end


%get_lane_vects(lanes(1),MeshSt)';
%lane_struct.R = get_rad_curv(lane_struct)

%% Aerodynamic initiation

%2D grid using MeshSt
AeroGrid.x_vec = MeshSt.x_vec;
AeroGrid.y_vec = MeshSt.y_vec;
AeroGrid.x_mat = MeshSt.x_mat;
AeroGrid.y_mat = MeshSt.y_mat;
AeroGrid.new_z_mat = MeshSt.new_z_mat;
AeroGrid.z_mat = MeshSt.z_mat;


%Aero coefficients grid
AeroGrid.Coeffs = ones(size(AeroGrid.z_mat));
AeroGrid.BaseCoeffs = ones(size(AeroGrid.z_mat));
[AeroGrid.index_x, AeroGrid.index_y] = meshgrid(1:size(AeroGrid.Coeffs,2),1:size(AeroGrid.Coeffs,1))
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


Aero_fig = figure;
mesh(AeroGrid.Coeffs)



%% initial plots (zero-lines)
figure(h)
% initial plot, height
if plot_height
    subplot(test_h)
    hold on
    for player = 1:num_players
        
        riders(player).height = zeros(race_length,1);
        riders(player).height(1) =riders(player).position(1,3);
        riders(player).gobjects(plot_height) = plot(riders(player).height,'Color',riders(player).property_color);
        
    end
end

% initial plot, bank
if plot_bank
    subplot(test_b)
    hold on
    for player = 1:num_players
        riders(player).bank_angle = zeros(race_length,1);
        riders(player).gobjects(plot_bank) = plot(riders(player).bank_angle,'Color',riders(player).property_color);
    end
end

% initial plot, steer
if plot_steer
    subplot(test_s)
    hold on
    for player = 1:num_players
        riders(player).steer_angle = zeros(race_length,1);
        riders(player).gobjects(plot_steer) = plot(riders(player).steer_angle,'Color',riders(player).property_color);
    end
end

if plot_roll
    subplot(test_r)
    hold on
    for player = 1:num_players
        riders(player).roll_angle = zeros(race_length,1);
        riders(player).gobjects(plot_roll) = plot(riders(player).roll_angle,'Color',riders(player).property_color);
    end
end

if plot_incline
    subplot(test_i)
    hold on
    for player = 1:num_players
        riders(player).incline_angle = zeros(race_length,1);
        riders(player).gobjects(plot_incline) = plot(riders(player).incline_angle,'Color',riders(player).property_color);
    end
end

if plot_incline_pwr
    subplot(test_i_p)
    hold on
    for player = 1:num_players
        riders(player).power_inclination = zeros(race_length,1);
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
        %assumed velocity is in direction that the rider travelled previously, so taking norm of velocity
        
        % Samad: assuming aerodynamic coefficient is of that immediately 'on'
        % the cyclist's new position (i.e. they've 'stepped' on un-changed aero field)
        riders(player).Cd_A(i) = riders(player).base_Cd_A*get_aero_coeff(AeroGrid,riders(player).position(i,:));
        
        % Samad: assuming input velocity is of that at the wheel
        riders(player).v_w(i) = riders(1).velocity(i);
        
        % kinematics
        riders(player).necessary_steer_angle(i) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).velocity(i),lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx));
        riders(player).R_w(i) = get_instant_radius(lanes,riders(player).lane,riders(player).lane_idx);
        riders(player).R_cg(i) =  get_R_cg(riders(player).R_w(i),riders(player).h_cg,riders(player).lean_angle(i));
        riders(player).R_cw(i) = get_R_cw(riders(player).R_w(i),riders(player).wheel_diameter,riders(player).lean_angle(i));
        riders(player).camber_rear(i) = get_camber_rear(riders(player).roll_angle(i));
        riders(player).camber_front(i) = get_camber_front(riders(player).roll_angle(i),riders(player).necessary_steer_angle(i),riders(player).rake_angle);
        riders(player).slip_front(i) = get_slip_2(riders(player).roll_angle(i),riders(player).camber_front(i),riders(player).Cy,riders(player).Ca);
        riders(player).slip_rear(i) = get_slip_2(riders(player).roll_angle(i),riders(player).camber_rear(i),riders(player).Cy,riders(player).Ca);
        riders(player).angular_velo(i) = get_angular_velo(riders(player).v_w(i), riders(player).R_w(i));
        riders(player).v_cg(i) = get_v_at_R(riders(player).angular_velo(i),riders(player).R_cg(i));
        riders(player).v_cw(i) = get_v_at_R(riders(player).angular_velo(i),riders(player).R_cw(i));
        riders(player).w_w(i,:) = get_w_w(riders(player).angular_velo(i),riders(player).lean_angle(i),riders(player).v_cw(i),riders(player).wheel_diameter);
        
        
        % forces
        riders(player).f_contact(i) = get_reaction(riders(player).mass,g,riders(player).incline(i),riders(player).v_cg(i),riders(player).R_cg(i));
        [riders(player).f_norm_front(i),riders(player).f_norm_rear(i)] = get_normals(riders(player).a,riders(player).b,riders(player).f_contact(i),riders(player).roll_angle(i));
        
        
        
        % friction
        riders(player).Crr_front(i) = get_roll_resistance_coeff( riders(player).slip_front(i),riders(player).camber_front(i) );
        riders(player).Crr_rear(i) = get_roll_resistance_coeff(riders(player).slip_rear(i),riders(player).camber_rear(i));
        riders(player).f_rolling(i) = get_roll_resistance_force(riders(player).f_norm_front(i),riders(player).Crr_front(i)) + get_roll_resistance_force(riders(player).f_norm_rear(i),riders(player).Crr_rear(i));
        riders(player).f_bearing(i) = get_f_bearing((riders(player).f_norm_front(i)+riders(player).f_norm_rear(i)),riders(player).C_br);
        riders(player).f_drag(i) = get_drag(riders(player).Cd_A(i),p,(riders(player).v_cg(i) - v_air));
        riders(player).f_incline(i) = get_f_incline(riders(player).mass,g,riders(player).incline(i));
        
        % powers
        riders(player).p_rolling(i) = get_p_roll(riders(player).f_rolling(i),riders(player).v_w(i));
        riders(player).p_bearing(i) = get_p_bearing(riders(player).f_bearing(i),riders(player).r_br,abs(riders(player).w_w(i,1)));
        riders(player).p_drag(i) = get_p_drag(riders(player).f_drag(i),riders(player).v_cg(i));
        riders(player).p_incline(i) = get_p_incline(riders(player).f_incline(i),riders(player).v_cg(i));
        
        riders(player).p_loss_total(i) = riders(player).p_rolling(i)+riders(player).p_bearing(i)+riders(player).p_drag(i)+riders(player).p_incline(i);
        
        
        %update aero
        %first recover?
        %AeroGrid.Coeffs = recover_aerogrid(AeroGrid.Coeffs, AeroGrid.BaseCoeffs);
        %then update?
        AeroGrid.Coeffs = energise_aerogrid(AeroGrid,riders(player).position(i,:), riders(player).vectors.cx);
        AeroGrid.Coeffs = recover_aerogrid(AeroGrid.Coeffs, AeroGrid.BaseCoeffs);
        figure(Aero_fig)
        hold off
        axis square
        imagesc(AeroGrid.Coeffs);
        colormap jet;
        
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



