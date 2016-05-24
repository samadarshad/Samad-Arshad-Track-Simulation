%script to just map the plume to the lanes

%new field = meshst (like aerofield)

%keep it simple - just test with lane from u = 0 to u = 45 (the limit in
%the plume) 

%script 19 to get image transformations of wake/velo defect shape

%script 18
%new physics aerodynamics incoorporation. 

%just some user friendly scollable axes
%incoorporates power and power losses for each rider and calculted
%aerodynamic losses
%uses power input rather than velocity input


%bool to prevent running of lanes i.e. 1 slow, 0 fast (skip lanes)
new = 0;


%script to incoorporate physics
%script for steering and correct distance of lane switches
%test out aerodynamic smoke model

close all

g = 10; %gravity
p = 1; %air density
v_air = 0; %velocity of air

dt =1; %seconds - arbitrary - used to update velocity per acceleration time step
num_players = 4;
riders = cyclist_struct(num_players);
test_velo = 5;
race_length = 100;
scroll_length = 100;
x = 1:race_length;
test_power = 30;
sub_plot_grid_x = 3;
sub_plot_grid_y = 3;


riders(1).position(1,:) = [-25 -3 0];
%riders(1).velocity = test_velo*ones(1,race_length);
riders(1).power_input = test_power*ones(1,race_length);
riders(1).color = 'ro';
riders(1).property_color = 'red';

riders(2).position(1,:) = [-25 3 0];
%riders(2).velocity = test_velo*ones(1,race_length);
riders(2).power_input = test_power*ones(1,race_length);
riders(2).color = 'bo';
riders(2).property_color = 'blue';

riders(3).position(1,:) = [25 -3 0];
%riders(3).velocity = test_velo*ones(1,race_length);
riders(3).power_input = test_power*ones(1,race_length);
riders(3).color = 'go';
riders(3).property_color = 'green';

riders(4).position(1,:) = [25 3 0];
%riders(3).velocity = test_velo*ones(1,race_length);
riders(4).power_input = test_power*ones(1,race_length);
riders(4).color = 'yo';
riders(4).property_color = 'yellow';




riders(1).lane = 3;
riders(2).lane = 3;
riders(3).lane = 3;
riders(4).lane = 3;
%for all players
for pl = 1:num_players
    riders(pl).mass = 60;
    riders(pl).base_Cd_A = 0.2;
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
    riders(pl).Ic1 = 10.168;
    riders(pl).Ic2 = 7.470;
    riders(pl).Iw1 = 0.0515;
    riders(pl).Iw2 = 0.0258;
    riders(pl).a_cg = zeros(1,race_length);
    riders(pl).m_wheel = 1.18; %kg, but for 1 wheel or two wheels?
    riders(pl).m_bike = 6.8;
    % preallocating memory for speed
    riders(pl).v_w = zeros(1,race_length);
    
    %start by assuming small speed
    riders(pl).v_w(1) = 1;
    
    riders(pl).Bluff = get_bluff();
end




%% for all lanes - LONG, only do if a completely new sim
if new
    load('Velo_info.mat', 'base', 'sm_lane', 'sm_red_lane', 'sm_blue_lane', 'MeshSt')
    clearvars lanes
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
        
        %get banking for each point in lane - so you can lookup rather than
        %calculate banking for the player
        lanes(lane_num).bank_angle = get_lane_banking(lanes(lane_num));
        
       %for the second lane, the banking is very rough, so increase window
       if lane_num == 2
            lanes(lane_num).bank_angle = smooth_lane_1D(lanes(lane_num).bank_angle,60); %smoothing
       end
       
       lanes(lane_num).aero_mapping = find_lane_aero_mesh(lanes(lane_num),MeshSt);
       
    end
end

for lane_num = 1:4
    lanes(lane_num).aero_mapping = find_lane_aero_mesh_finer_fast(lanes(lane_num),MeshSt);
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


%Aero velocities - real physics. in 2D
AeroGrid.velocity.x = zeros(size(AeroGrid.z_mat));
AeroGrid.velocity.y  = zeros(size(AeroGrid.z_mat));
AeroGrid.velocity.mag = zeros(size(AeroGrid.z_mat));
[AeroGrid.index_x, AeroGrid.index_y] = meshgrid(1:size(AeroGrid.z_mat,2),1:size(AeroGrid.z_mat,1));
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
plot_steer = 0;
plot_roll = 0;
plot_incline = 0;
plot_incline_pwr = 0;
plot_power_lost = 1;
plot_velo = 1;
plot_accel = 0;
plot_drag_pwr = 0;
plot_drag_c = 1;

plot_num = 1; %for position on the subplots
g_object_num = 1; %for player.gobject(i), the 'if' statement still returns true if(h) where h = 5

h = figure;
ax1 = h.CurrentAxes;
%subplot(3,2,[2 4 6],ax1)

if plot_height
    test_h = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Height from base (meters)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_height = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_bank
    test_b = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Bank Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_bank = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_steer
    test_s = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('GROUND Steer Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_steer = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_roll
    test_r = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Roll Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_roll = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_incline
    test_i = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Incline Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_incline = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_incline_pwr
    test_i_p = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Incline Power (Joules)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_incline_pwr = g_object_num;
    g_object_num = g_object_num+1;
end


if plot_power_lost
    test_p_l = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Power Lost (Watts)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_power_lost = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_velo
    test_v = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Velocity wheel (m/s)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_velo = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_accel
    test_a = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Acceleration centre (m/s2)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_accel = g_object_num;
    g_object_num = g_object_num+1;
end


if plot_drag_pwr
    test_dp = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Drag Power (W)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_drag_pwr = g_object_num;
    g_object_num = g_object_num+1;
end

if plot_drag_c
    test_dc = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Drag Coeff','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_drag_c = g_object_num;
    g_object_num = g_object_num+1;
end

test_3d = subplot(sub_plot_grid_x,sub_plot_grid_y,[2 5 8],ax1)
view(2)
%view(3)
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


Aero_fig = subplot(sub_plot_grid_x,sub_plot_grid_y,[3 6 9],ax1);
% view(2)
% mesh(AeroGrid.Coeffs)
% hold on
% % for player = 1:num_players
% %     riders(player).gobjects(5) = point_plot2([riders(player).position(1,1:2) 0], riders(player).color, h); %keeping z out
% % end
% axis xy


 subplot(Aero_fig) 
%     A_fig_child = get(Aero_fig,'children');    
%     set(A_fig_child.Surface,'ZData',AeroGrid.Coeffs)
%     hold off    
    axis square    
    test_handle_image = imagesc(AeroGrid.velocity.mag);
    colormap jet;
    axis xy

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
    xlim([0,scroll_length])
end

% initial plot, bank
if plot_bank
    subplot(test_b)
    hold on
    for player = 1:num_players
        riders(player).bank_angle = zeros(race_length,1);
        riders(player).gobjects(plot_bank) = plot(riders(player).bank_angle,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

% initial plot, steer
if plot_steer
    subplot(test_s)
    hold on
    for player = 1:num_players
        riders(player).steer_angle = zeros(race_length,1);
        riders(player).gobjects(plot_steer) = plot(riders(player).steer_angle,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

if plot_roll
    subplot(test_r)
    hold on
    for player = 1:num_players
        riders(player).roll_angle = zeros(race_length,1);
        riders(player).gobjects(plot_roll) = plot(riders(player).roll_angle,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

if plot_incline
    subplot(test_i)
    hold on
    for player = 1:num_players
        riders(player).incline_angle = zeros(race_length,1);
        riders(player).gobjects(plot_incline) = plot(riders(player).incline_angle,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

if plot_incline_pwr
    subplot(test_i_p)
    hold on
    for player = 1:num_players
        riders(player).power_inclination = zeros(race_length,1);
        riders(player).gobjects(plot_incline_pwr) = plot(riders(player).power_inclination,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

if plot_velo
    subplot(test_v)
    hold on
    for player = 1:num_players        
        riders(player).gobjects(plot_velo) = plot(riders(player).v_w,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end

if plot_accel
    subplot(test_a)
    hold on
    for player = 1:num_players        
        riders(player).gobjects(plot_accel) = plot(riders(player).a_cg,'Color',riders(player).property_color);
    end
    xlim([0,scroll_length])
end



if plot_power_lost
    subplot(test_p_l)
    hold on
    for player = 1:num_players
        riders(player).p_loss_total = zeros(race_length,1);
        riders(player).gobjects(plot_power_lost) = plot(riders(player).p_loss_total,'Color',riders(player).property_color);
    
    end  
    xlim([0,scroll_length])
end



if plot_drag_pwr
    subplot(test_dp)
    hold on
    for player = 1:num_players
        riders(player).p_drag = zeros(race_length,1);
        riders(player).gobjects(plot_drag_pwr) = plot(riders(player).p_drag,'Color',riders(player).property_color);
       
    end
    xlim([0,scroll_length])
end

if plot_drag_c
    subplot(test_dc)
    hold on
    for player = 1:num_players
        riders(player).Cd_A = zeros(race_length,1);
        riders(player).gobjects(plot_drag_c) = plot(riders(player).Cd_A,'Color',riders(player).property_color);
       
    end
    xlim([0,scroll_length])
end

%% iterate position

for i= 1:race_length
    %perform a step and update properties
    %lane change when i = 50
    
    
     
    
    for player = 1:num_players
        
        if i == 50 && player ==1 && 1 == 0 %i.e. no lane change
            [new_idx, new_pos] = step_lane_w_change(riders(1).lane_idx,riders(1).v_w(i),riders(1).lane,3,lanes);
            riders(1).lane = 3;
        else
            [new_idx, new_pos] = step_lane(riders(player).lane_idx,riders(player).v_w(i),lanes(riders(player).lane));
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
        
        %riders(player).bank_angle(i) = get_bank(riders(player).position(i,:),riders(player).vectors);
        riders(player).bank_angle(i) = lanes(riders(player).lane).bank_angle(riders(player).lane_idx);
        
        Rw = lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx);
        
        
        if i > 1
            riders(player).incline(i) = get_incline(riders(player).position(i-1:i,:));
            % TEMP: using v_w rather than v_cg as cg requires recursion riders(player).lean_angle(i) = get_lean(riders(player).incline(i),riders(player).v_cg(i),g,Rw,riders(player).h_cg);
            riders(player).lean_angle(i) = get_lean(riders(player).incline(i),riders(player).v_w(i),g,Rw,riders(player).h_cg);
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
        if i == 1
        riders(player).Cd_A(i) = riders(player).base_Cd_A*get_aero_coeff(AeroGrid,riders(player).position(i,:));
        else
            %get_aero_coeff2(AeroGrid,current_position,next_position)
            riders(player).Cd_A(i) = riders(player).base_Cd_A*get_aero_coeff5(AeroGrid,riders(player).position(i-1,:),riders(player).position(i,:)); %use the average method
           % riders(player).Cd_A(i) = riders(player).base_Cd_A*get_aero_coeff3(AeroGrid,riders(player).position(i-1,:),riders(player).Bluff.centre_co); %use the centre-minussing the rider's centre, method
        end
        % Samad: assuming input velocity is of that at the wheel
        %riders(player).v_w(i) = riders(1).velocity(i);
        
        % kinematics - new_iteration calculations
        
        
        % kinematics - follow_up calculations
 % TEMP USING 'v_w' rather than 'v_cg' as there is some recursion needed for v_cg        riders(player).necessary_steer_angle(i) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).v_w(i),lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx));
        riders(player).necessary_steer_angle(i) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).v_w(i),lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx));

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
        riders(player).R_c(i) = get_Rc(riders(player).R_w(i),riders(player).h_cg,riders(player).m_wheel,(riders(player).mass + riders(player).m_bike - riders(player).m_wheel),riders(player).wheel_diameter,riders(player).lean_angle(i));
        
        
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
        riders(player).power_left(i) = riders(player).power_input(i) - riders(player).p_loss_total(i);
        
        %get acceleration from power
        riders(player).a_cg(i) = get_a_cg(riders(player).power_left(i),riders(player).v_cg(i),riders(player).R_cw(i), riders(player).R_cg(i), riders(player).R_c(i),riders(player).m_wheel, (riders(player).mass+riders(player).m_bike - riders(player).m_wheel), riders(player).wheel_diameter,...
            riders(player).lean_angle(i), riders(player).Ic1, riders(player).Ic2, riders(player).Iw1, riders(player).Iw2);
        
       
        
        
 
    
    %get acceleration at wheel
    riders(player).a_w(i) = riders(player).a_cg(i);
    %can we assume acceleration at wheel is the same as the acceleration of
    %the centre gravity?
    
    
    %change velocity of wheel by time step
        riders(player).v_w(i+1) = riders(player).v_w(i) + riders(player).a_w(i)*dt;
        
        
        
        
    end
    
    
    
    % ENERGISATION SHOULD BE AFTER ALL THE PLAYERS HAVE BEEN UPDATED       
        for player = 1:num_players
        AeroGrid.Coeffs = energise_aerogrid(AeroGrid,riders(player).position(i,:), riders(player).vectors.cx, riders(player).Bluff);
        
        end
        AeroGrid.Coeffs = recover_aerogrid(AeroGrid.Coeffs, AeroGrid.BaseCoeffs);
    
    
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
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
    
    %bank plot
    if plot_bank
        subplot(test_b)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_bank) = update_properties_plot(riders(player).bank_angle,riders(player).gobjects(plot_bank));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
    %steer plot
    if plot_steer
        subplot(test_s)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_steer) = update_properties_plot(riders(player).steer_angle,riders(player).gobjects(plot_steer));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
    if plot_roll
        subplot(test_r)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_roll) = update_properties_plot(riders(player).roll_angle,riders(player).gobjects(plot_roll));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
    if plot_incline
        subplot(test_i)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_incline) = update_properties_plot(riders(player).incline_angle,riders(player).gobjects(plot_incline));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
    if plot_incline_pwr
        subplot(test_i_p)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_incline_pwr) = update_properties_plot(riders(player).power_inclination,riders(player).gobjects(plot_incline_pwr));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
    end
    
     if plot_power_lost
        subplot(test_p_l)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_power_lost) = update_properties_plot(riders(player).p_loss_total,riders(player).gobjects(plot_power_lost));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
     end
     
     if plot_velo
         subplot(test_v)
         hold on
         for player = 1:num_players
             riders(player).gobjects(plot_velo) = update_properties_plot(riders(player).v_w,riders(player).gobjects(plot_velo));
         end
         if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
     end
     
     if plot_accel
         subplot(test_a)
         hold on
         for player = 1:num_players
             riders(player).gobjects(plot_accel) = update_properties_plot(riders(player).a_cg,riders(player).gobjects(plot_accel));
         end
         if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
     end
    
      if plot_drag_pwr
        subplot(test_dp)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_drag_pwr) = update_properties_plot(riders(player).p_drag,riders(player).gobjects(plot_drag_pwr));
        end
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
      end
     
      if plot_drag_c
        subplot(test_dc)
        hold on
        for player = 1:num_players
            riders(player).gobjects(plot_drag_c) = update_properties_plot(riders(player).Cd_A,riders(player).gobjects(plot_drag_c));
        end
        
        %set scrolling axes
        if i>100
            xmax = i;
            xmin = i-scroll_length;
            xlim([xmin,xmax])
        end
     end
     
    subplot(Aero_fig)
    set(test_handle_image,'CData',AeroGrid.Coeffs);
%     A_fig_child = get(Aero_fig,'children');    
%     set(A_fig_child.Surface,'ZData',AeroGrid.Coeffs)
%     hold off    
%     axis square    
%     test_handle_image = imagesc(AeroGrid.Coeffs);
%     colormap jet;
%     axis xy
%     hold on
%      for player = 1:num_players        
%         riders(player).gobjects(5) = update_plot([riders(player).position(i,1:2) 0], riders(player).gobjects(5));
%     end
    
   
    
    
    pause(0.1)
end



