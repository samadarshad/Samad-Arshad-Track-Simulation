%script for mass start instead of pursuit
%script for 8 opponents 


%script to investigate emerging gaps between swooping cyclist and his
%opponent who has a 1-second delay


%script to add up wind speeds by their cube rooted power (i.e. adding up
%kinetic energeies of wind, where KE prop to wind speed cubed - thus when
%working backwards to find the wind speed, we would get cube root addition)

%script to have variable lanes


%script to have position-controlled riders (next script will implement
%posterior collision detection to switch lanes automatically)

%new field = meshst (like aerofield)


%script 19 to get image transformations of wake/velo defect shape

%script 18
%new physics aerodynamics incoorporation.

%just some user friendly scollable axes
%incoorporates power and power losses for each rider and calculted
%aerodynamic losses
%uses power input rather than velocity input


%bool to prevent running of lanes i.e. 1 slow, 0 fast (skip lanes)
new =0;

new_fast = 1;


if new_fast
    load('Velo_info.mat', 'base', 'MeshSt')
    %load('lanes_premade_5.mat')
    load('lanes_premade_16_orange.mat')
   % load('wake_premade_default.mat')
   load('wake_premade_optimisedforCdA.mat')
end

%script to incoorporate physics
%script for steering and correct distance of lane switches
%test out aerodynamic smoke model

%close all
figure

g = 10; %gravity
p = 1; %air density
v_air = 0; %velocity of air
max_velo = 2;
u_inf = 10; %this does NOT act as a global variable - it needs to be manually updated in both makewake.m and here to be effective
%this is the scaling velocity for u_infinity IN THE AERODYNAMIC WAKES SCALING. divide rider velocity by
%u_inf to get the multiplication factor for the wake values.

dt =0.1; %seconds per time step - MUST BE GREATER THAN ~0.05 (i.e. a function of minimum velocity) otherwise at each time step, the rider would be rounded to the nearest discrete space and appear to be travelling round the velodrome even at '1m/s'
num_players =17;
riders = cyclist_struct(num_players);
race_length = 3000/dt;
scroll_length = 100;%round(race_length/5 + 1);
x = 1:race_length;
time_var = (1:race_length).*dt;
swirl_velo = 0;%num_players^(1/3); %approximate relationship between swirlling wind velocity and the number of players

test_power = 400;
sub_plot_grid_x = 3;
sub_plot_grid_y = 3;
num_lanes = 16; %limites the overtaking to within the number of lanes (otherwise it might crash if a rider tries to go into a nonexisting lane).

%overtaking power (TEMPORARY - for next year student to play with)
overtaking_power = 0;

%collision detection distance (must be less than 250m/2 - v.dt to avoid
%problem of sign-changing at the 125m distance

%TURN ON (1) or OFF (0) the POWER to VELOCITY MODEL (i.e. if you want to
%'fix' the velocity of the cyclist
Power_model_on = 1;
test_velo = 14.5; %if power model off, then set your velocity here

%TURN ON (1)or OFF (0) AERODYNAMICS MODELS
Aerodynamics_on = 0; 
%TURN ON (1)or OFF (0) COLLISION/OVERTAKING MODELS
Collisions.on = 1; %turn on to activate collision detection and default automatic overtaking procedures
if ~Collisions.on
    Collisions.RedoTimeStep = 0;
end


Collisions.detection_distance = 50; %maximum distance to consider for collisions between cyclists i.e. we will ignore any distances greater than 50m.
overtakingdistance = 5;
giveupdistance = -10; %, must be less than 125. when 100 meters behind your 'victim' cyclist, then give up and return to our origional lane

%standing start velocity
standing_start_velocity = 0.5;
%if want to de-active the standing-start acceleration, just set velocity to
%0
visual_speed = 1; %speed up or slow down simulation 
graphical_display = 1; %turn on/off to turn off graphical draw-now. also need to turn off the individual graphic bools in the section below.

%calibration
power_loss_callibration = 1;%2.5;%2.5; 


time_of_attack = 20/dt;%seconds %14 is at mid-lap
power_of_attack = 1200; %watts
duration_of_attack = race_length-time_of_attack; %i.e. remainder of the race the cyclists are attacking
opponent_delay = 1/dt; %seconds
recorded_seperation_distance = zeros(1,race_length);

riders(1).position(1,:) = [25 3 0];%[0 -50 0];
 riders(1).power_input = test_power*ones(1,race_length);%[test_power*ones(1,time_of_attack) power_of_attack*ones(1,duration_of_attack) ];
% riders(1).v_w = test_velo*ones(1,race_length);
%tamp test
%riders(1).power_input = s_ramp;
%riders(1).power_input = power1(3295:race_length+3295-1); %jon dibben input
%powers (needs jon_dibben_data.mat to be loaded)
riders(1).color = 'ko';
riders(1).property_color = 'black';

riders(2).position(1,:) = [25 3 0];
%riders(2).v_w = 14.52*ones(1,race_length);
riders(2).power_input = (100+test_power)*ones(1,race_length);%[test_power*ones(1,time_of_attack+opponent_delay) power_of_attack*ones(1,duration_of_attack-opponent_delay) ];%test_power*ones(1,race_length);
riders(2).color = 'ko';
riders(2).property_color = 'red';

riders(3).position(1,:) =  [25 0 0];
%riders(3).v_w = test_velo*ones(1,race_length);
riders(3).power_input = test_power*ones(1,race_length);
riders(3).color = 'ko';
riders(3).property_color = 'red';

riders(4).position(1,:) =  [25 0 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(4).power_input = test_power*ones(1,race_length);
riders(4).color = 'ko';
riders(4).property_color = 'red';%'yellow';



riders(5).position(1,:) = [25 0 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(5).power_input = test_power*ones(1,race_length);
riders(5).color = 'ko';
riders(5).property_color = 'blue';%'yellow';

riders(6).position(1,:) = [25 -3 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(6).power_input = test_power*ones(1,race_length);
riders(6).color = 'ko';
riders(6).property_color = 'green';%'yellow';

riders(7).position(1,:) = [25 -3 0];
%riders4).v_w = test_velo*ones(1,race_length);
riders(7).power_input = test_power*ones(1,race_length);
riders(7).color = 'ko';
riders(7).property_color = 'green';%'yellow';

riders(8).position(1,:) = [25 -3 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(8).power_input = test_power*ones(1,race_length);
riders(8).color = 'ko';
riders(8).property_color = 'green';%'yellow';

riders(9).position(1,:) = [25 -3 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(9).power_input = test_power*ones(1,race_length);
riders(9).color = 'ko';
riders(9).property_color = 'blue';%'yellow';

riders(10).position(1,:) = [25 -6 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(10).power_input = test_power*ones(1,race_length);
riders(10).color = 'ko';
riders(10).property_color = 'green';%'yellow';

riders(11).position(1,:) = [25 -6 0];
%riders4).v_w = test_velo*ones(1,race_length);
riders(11).power_input = test_power*ones(1,race_length);
riders(11).color = 'ko';
riders(11).property_color = 'green';%'yellow';

riders(12).position(1,:) = [25 -6 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(12).power_input = test_power*ones(1,race_length);
riders(12).color = 'ro';
riders(12).property_color = 'green';%'yellow';

riders(13).position(1,:) = [25 -6 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(13).power_input = test_power*ones(1,race_length);
riders(13).color = 'ko';
riders(13).property_color = 'blue';%'yellow';

riders(14).position(1,:) =[25 -6 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(14).power_input = test_power*ones(1,race_length);
riders(14).color = 'ko';
riders(14).property_color = 'green';%'yellow';

riders(15).position(1,:) = [25 -9 0];
%riders4).v_w = test_velo*ones(1,race_length);
riders(15).power_input = test_power*ones(1,race_length);
riders(15).color = 'ko';
riders(15).property_color = 'green';%'yellow';

riders(16).position(1,:) = [25 -9 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(16).power_input = test_power*ones(1,race_length);
riders(16).color = 'ko';
riders(16).property_color = 'green';%'yellow';

riders(17).position(1,:) = [25 -9 0];
%riders(4).v_w = test_velo*ones(1,race_length);
riders(17).power_input = test_power*ones(1,race_length);
riders(17).color = 'ko';
riders(17).property_color = 'blue';%'yellow';




swoop_time=1;
lane_ramp = swooping_timed_stepped_ramp(14,2,swoop_time,dt);
% 2*ones(1,race_length);%
riders(1).lane =5*ones(1,race_length);%[14*ones(1,time_of_attack) lane_ramp 2*ones(1,race_length-size(lane_ramp,1)-time_of_attack)];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];  %[4 4 2*ones(1,race_length-2)];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];%2*ones(1,race_length);%[4 4 2*ones(1,race_length-2)];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];%[4 2*ones(1,race_length-1)]; %kinetic energy from 4th lane applied to rider
%riders(1).lane = roundtowardvec(5+(-5.*riders(1).power_input./1200),[2 5]);
%riders(1).lane = [lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];  %[4 4 2*ones(1,race_length-2)];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];%2*ones(1,race_length);%[4 4 2*ones(1,race_length-2)];%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];%[4 2*ones(1,race_length-1)]; %kinetic energy from 4th lane applied to rider
riders(2).lane = 7*ones(1,race_length);%[14*ones(1,time_of_attack+opponent_delay) lane_ramp 2*ones(1,race_length-size(lane_ramp,1)-time_of_attack-opponent_delay)];
%2*ones(1,race_length);%[lane_ramp 2*ones(1,race_length-size(lane_ramp,1))];

riders(3).lane = 4*ones(1,race_length);
riders(4).lane = 6*ones(1,race_length);
riders(5).lane = 8*ones(1,race_length);

riders(6).lane = 3*ones(1,race_length);
riders(7).lane = 5*ones(1,race_length);
riders(8).lane = 7*ones(1,race_length);
riders(9).lane = 9*ones(1,race_length);

riders(10).lane = 2*ones(1,race_length);
riders(11).lane = 4*ones(1,race_length);
riders(12).lane = 6*ones(1,race_length);
riders(13).lane = 8*ones(1,race_length);
riders(14).lane = 10*ones(1,race_length);

riders(15).lane = 4*ones(1,race_length);
riders(16).lane = 6*ones(1,race_length);
riders(17).lane = 8*ones(1,race_length);





%for all players
for pl = 1:num_players
    riders(pl).mass = 85;
    
    
    riders(pl).h_cg = 1;
    riders(pl).C_br = 0.003;%1;
    riders(pl).a = 0.4; %m
    riders(pl).b = 0.6; %m
    riders(pl).rake_angle = 20; %deg
    riders(pl).wheel_diameter = 0.67; %m
    riders(pl).Ca = 0.267;
    riders(pl).Cy = 0.02;
    riders(pl).r_br = 0.012; %m bearing radius
    riders(pl).base_Cd_A = 0.25;%25;%19;
    riders(pl).Cd_A = riders(pl).base_Cd_A; %to calibrate with real data, ive multiplied by 2 to represent the losses
    riders(pl).Ic1 = 10.168;
    riders(pl).Ic2 = 7.470;
    riders(pl).Iw1 = 0.0515;
    riders(pl).Iw2 = 0.0258;
    riders(pl).a_cg = zeros(1,race_length);
    riders(pl).m_wheel = 1.18; %kg, but for 1 wheel or two wheels?
    riders(pl).m_bike = 6.8;
    if Power_model_on
    riders(pl).v_w = zeros(1,race_length);
    end
    % Starting off
    riders(pl).Tmax = [];% Newton-meters - calculate this using Billy Fitton eqn 64 rearranged
    riders(pl).GR = 3.85; %gear ratio (Andy Tennant, Billy Fitton paper
    %start by assuming small speed/initial kinetic energy
    riders(pl).v_w(1) = 8;
    riders(pl).w_c_max = 236*(2*pi/60); %cadence rpm. Scott Gardiner (page 95)
    riders(pl).w_c_start = 40*(2*pi/60); %cadence rpm. Scott Gardiner (page 119)
    
    %riders(pl).Bluff = get_bluff();
    riders(pl).v_air = zeros(1,race_length);
    
    
  
    
    
    %collision detection
    riders(pl).collision_distance = 0.5; %meters ahead and behind minimum, along lanes
    riders(pl).demand_lane = riders(pl).lane; %hidden - lane which is referred to when overtaking and wanting to return to the origional lane
    riders(pl).demand_power = riders(pl).power_input; %for future student to refer to. this is just here (should be deleted) to act as the reference power to resort to when completing the overtaking

    %physiological
    riders(pl).Pmax = 1210; %maximum power initially, watts
    riders(pl).constrained_Pmax = riders(pl).Pmax*ones(1,race_length); %this is the constrained maximum power that decreases according to the MM model (to account for fatigue), watts
    riders(pl).AWC_max = 20000; %maximum AWC, joules
    riders(pl).AL = 0.32*riders(pl).AWC_max*ones(1,race_length); %maximum Alactic work capacity, joules
    riders(pl).L = 0.68*riders(pl).AWC_max*ones(1,race_length); %maximum lactic work capacity, joules
    riders(pl).AWC = riders(pl).AL + riders(pl).L; %billy fitton: AL + L = AWC
    riders(pl).CP = 280*ones(1,race_length); %maximum oxidative work, analogous to critical power

  %position control
    riders(pl).controlpos.on=0;
    riders(pl).controlpos.follow_id=[];
    riders(pl).controlpos.rel_dist= -3; %-1.5; %meters relative distance
    riders(pl).controlpos.chase_power = 40; %i.e. maybe criticalpower*1.1? the maximum power the rider would expend in catching up - i.e. either slow and steady catch up, or rapid high power catchup
    riders(pl).max_power = riders(pl).constrained_Pmax;
    riders(pl).controlpos.inline_distance = zeros(1,race_length);
end

if Collisions.on
% collision detection thresholds matrix
Collisions.ThreshMat = zeros(num_players);
for i = 1:num_players
    for j  = 1:num_players
        Collisions.ThreshMat(i,j) = riders(i).collision_distance + riders(j).collision_distance; %notice notation convention (i,j) = i - j
    end
end

% collision detection matrix (1, 0, -1 corresponding to signs of distances
% of for N/A distances) - collision detected if difference between two time
% stepped matricies contain a +-2.
Collisions.SignsMat = zeros(num_players);
Collisions.mindistances = zeros(num_players); %hidden
Collisions.mindistances250 = zeros(num_players); %hidden. distances relative to 250m - position
Collisions.MinDistancesFlag = zeros(num_players); %flag to store whether the 250m was taken as reference. used for next time step
Collisions.mindistancesboth = zeros(num_players); %stores the minimum of both 0 and 250m referenced distances. hidden
Collisions.FilteredDistances = zeros(num_players);
Collisions.BeingOverTakenID = []; %records for each time step, which players have collided (i.e. pairs of cyclists)
Collisions.OverTakersID = []; %records the cyclists who are trying to over take (i.e. coming from the rear)
Collisions.PreviousSignsMat = zeros(num_players);
Collisions.RedoTimeStep = 0;

end


% %getting rider 2 to follow rider 1 at 3 meters behind
% riders(2).controlpos.on=1;
% riders(2).controlpos.follow_id = 1;
% riders(2).controlpos.rel_dist= -3;
% 
% riders(3).controlpos.on=1;
% riders(3).controlpos.follow_id = 1;
% riders(3).controlpos.rel_dist= -6;
% 
% riders(4).controlpos.on=1;
% riders(4).controlpos.follow_id = 1;
% riders(4).controlpos.rel_dist= -9;
% 
% riders(6).controlpos.on=1;
% riders(6).controlpos.follow_id = 5;
% riders(6).controlpos.rel_dist= -3;
% 
% riders(7).controlpos.on=1;
% riders(7).controlpos.follow_id = 5;
% riders(7).controlpos.rel_dist= -6;
% 
% riders(8).controlpos.on=1;
% riders(8).controlpos.follow_id = 5;
% riders(8).controlpos.rel_dist= -9;



%%
%cooporation from team - following their leader
% 
% riders(2).controlpos.on=1;
% riders(2).controlpos.follow_id = 1;
% riders(2).controlpos.rel_dist= -2;
% 
% riders(3).controlpos.on=1;
% riders(3).controlpos.follow_id = 2;
% riders(3).controlpos.rel_dist= -2;
% 
% % riders(4).controlpos.on=1;
% % riders(4).controlpos.follow_id = 3;
% % riders(4).controlpos.rel_dist= -2;
% 
% riders(6).controlpos.on=1;
% riders(6).controlpos.follow_id = 5;
% riders(6).controlpos.rel_dist= -2;
% 
% riders(7).controlpos.on=1;
% riders(7).controlpos.follow_id = 6;
% riders(7).controlpos.rel_dist= -2;
% 
% riders(8).controlpos.on=1;
% riders(8).controlpos.follow_id = 7;
% riders(8).controlpos.rel_dist= -2;
% 
% % %competitiveness from team leaders = trying to beat the opponent
% % riders(5).controlpos.on=1;
% riders(5).controlpos.follow_id = 1;
% riders(5).controlpos.rel_dist= 0;
% 
% riders(1).controlpos.on=0;
% riders(1).controlpos.follow_id = 2;
% riders(1).controlpos.rel_dist= +2;

%% function to create a completely new lane (long 1-minute process per lane)
create_new_lane = 0;
if create_new_lane
   height_base = 0;
    base = get_contour(height_base);
    
    
        x_space = 8; %meters from base
        
        x_lane = create_lane(x_space,base,MeshSt); %long 1-minute process
        %get length
        length_track = get_track_length(x_lane(:,1), x_lane(:,2), x_lane(:,3))
        %  smoothen out
        sm_x_lane = smooth_lane(x_lane);
    
    
end
    
    

%% for all lanes - LONG, only do if a completely new sim
if new
    load('Velo_info.mat', 'base', 'sm_lane', 'sm_red_lane', 'sm_blue_lane', 'MeshSt')
    load('lanes_premade_5.mat')
    %additional lanes
    load_lane=load('sm_1_lane.mat','sm_x_lane')
    sm_1_lane = load_lane.sm_x_lane;
    load_lane=load('sm_1_5_lane.mat','sm_x_lane')
    sm_1_5_lane = load_lane.sm_x_lane;
    load_lane=load('sm_2_lane.mat','sm_x_lane')
    sm_2_lane = load_lane.sm_x_lane;
   
    load_lane=load('sm_3_lane.mat','sm_x_lane')
    sm_3_lane = load_lane.sm_x_lane;
    load_lane=load('sm_3_5_lane.mat','sm_x_lane')
    sm_3_5_lane = load_lane.sm_x_lane;
    load_lane=load('sm_4_lane.mat','sm_x_lane')
    sm_4_lane = load_lane.sm_x_lane;
    load_lane=load('sm_4_5_lane.mat','sm_x_lane')
    sm_4_5_lane = load_lane.sm_x_lane;
    load_lane=load('sm_5_lane.mat')
    sm_5_lane = load_lane.sm_5_lane;
    load_lane=load('sm_5_5_lane.mat','sm_x_lane')
    sm_5_5_lane = load_lane.sm_x_lane;
    load_lane=load('sm_6_lane.mat','sm_x_lane')
    sm_6_lane = load_lane.sm_x_lane;
    load_lane=load('sm_6_5_lane.mat','sm_x_lane')
    sm_6_5_lane = load_lane.sm_x_lane;
    load_lane=load('sm_7_lane.mat','sm_x_lane')
    sm_7_lane = load_lane.sm_x_lane;  
    
    
    
    clearvars lanes
    lanes(1) = lane_to_struct([base.X;base.Y;base.Level*ones(size(base.X))]',[165 42 42]./255); %0
    
    lanes(2) = lane_to_struct(sm_lane,'black'); %0.2
    lanes(3) = lane_to_struct(sm_red_lane,'red'); %0.85
    
    lanes(4) = lane_to_struct(sm_1_lane,'cyan'); %1
    lanes(5) = lane_to_struct(sm_1_5_lane,'cyan'); %1.5
    lanes(6) = lane_to_struct(sm_2_lane,'cyan'); %2
    
    lanes(7) = lane_to_struct(sm_blue_lane,'blue'); %2.45
    
    lanes(8) = lane_to_struct(sm_3_lane,'cyan'); %3
    lanes(9) = lane_to_struct(sm_3_5_lane,'cyan'); %3.5
    lanes(10) = lane_to_struct(sm_4_lane,'cyan'); %4
    lanes(11) = lane_to_struct(sm_4_5_lane,'cyan'); %4.5    
    lanes(12) = lane_to_struct(sm_5_lane,'cyan'); %5    
    lanes(13) = lane_to_struct(sm_5_5_lane,'cyan'); %5.5
    lanes(14) = lane_to_struct(sm_6_lane,'cyan'); %6
    lanes(15) = lane_to_struct(sm_6_5_lane,'cyan'); %6.5
    lanes(16) = lane_to_struct(sm_7_lane,'cyan'); %7
    
    
    
    
    for lane_num = 1:16
        lanes(lane_num).vectors = struct();
        lanes(lane_num).vectors = get_lane_vects(lanes(lane_num),MeshSt)';
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
        
        %lanes(lane_num).aero_mapping = find_lane_aero_mesh(lanes(lane_num),MeshSt);
        lanes(lane_num).aero_mapping = find_lane_aero_mesh_finer_fast(lanes(lane_num),MeshSt);
    end
    
    highreswake = make_wake;
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
% AeroGrid.velocity.x = zeros(size(AeroGrid.z_mat));
% AeroGrid.velocity.y  = zeros(size(AeroGrid.z_mat));
% AeroGrid.velocity.mag = zeros(size(AeroGrid.z_mat));
AeroGrid.Coeffs = zeros(size(AeroGrid.z_mat));
[AeroGrid.index_x, AeroGrid.index_y] = meshgrid(1:size(AeroGrid.z_mat,2),1:size(AeroGrid.z_mat,1));
%% Correct the cyclist to a lane/their chosen lane

for i = 1:num_players
    lane_number = riders(i).lane(1);
    riders(i).lane_idx =  dsearchn([lanes(lane_number).X lanes(lane_number).Y],riders(i).position(1,1:2));
    riders(i).position(1,:) = [lanes(lane_number).X(riders(i).lane_idx) ...
        lanes(lane_number).Y(riders(i).lane_idx) ...
        lanes(lane_number).Z(riders(i).lane_idx) ];
    riders(i).vectors = get_vects(MeshSt,riders(i).position(1,:));
end


%% initialise plots

if graphical_display

% select the plots you want to plot (only 3 at a time)
%select 3 from here
plot_height = 0;
plot_bank = 0;
plot_steer = 0;
plot_roll = 0;
plot_incline = 0;
plot_incline_pwr = 0;
plot_power_lost = 0;
plot_velo = 0;
plot_accel = 0;
plot_drag_pwr = 0;
plot_drag_c = 0;
plot_v_air = 0;
plot_input_pwr = 0;
%physiological
plot_AWC = 0;
plot_constrained_maxP = 0;
plot_AL = 0;
plot_L = 0;


%select both/either/none
%3D positions
plot_3d = 1;

%aero
plot_aero = 1;



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
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_bank
    test_b = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Bank Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_bank = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_steer
    test_s = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('GROUND Steer Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_steer = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_roll
    test_r = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Roll Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_roll = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_incline
    test_i = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Incline Angle (degrees)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_incline = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_incline_pwr
    test_i_p = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Incline Power (Joules)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_incline_pwr = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end


if plot_power_lost
    test_p_l = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Power Lost (Watts)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_power_lost = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_velo
    test_v = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Velocity wheel (m/s)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_velo = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_accel
    test_a = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Acceleration centre (m/s2)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_accel = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end


if plot_drag_pwr
    test_dp = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1)
    hold on
    title('Drag Power (W)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_drag_pwr = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_drag_c
    test_dc = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Drag Force (N)','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_drag_c = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_v_air
    test_va = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Velo Air','HandleVisibility','off');
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num + 3;
    plot_v_air = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_input_pwr
    test_p_input = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Input Power (Watts)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_input_pwr = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_AWC
    test_AWC = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Anerobic Work Capacity (Joules)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_AWC = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_constrained_maxP
    test_cmaxP = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Max Power Capacity (Watts)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_constrained_maxP = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_AL
    test_AL = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Alactic Tank (Joules)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_AL = g_object_num;
     if g_object_num==3
        xlabel('Time(seconds)');
     end
    g_object_num = g_object_num+1;
end

if plot_L
    test_L = subplot(sub_plot_grid_x,sub_plot_grid_y,plot_num,ax1);
    hold on
    title('Lactic Tank (Watts)','HandleVisibility','off'); %retaining title after overwrites
    set(gca,'NextPlot','replacechildren') ;
    plot_num = plot_num+3;
    plot_L = g_object_num;
    if g_object_num==3
        xlabel('Time(seconds)');
    end
    g_object_num = g_object_num+1;
end




if plot_3d
    test_3d = subplot(sub_plot_grid_x,sub_plot_grid_y,[2 5 8],ax1);
    view(2)
    %view(3)
    subplot(test_3d)
    hold on
    axis equal
    axis tight
    daspect auto
    plot_lane_st(lanes(1),h)
    plot_lane_st(lanes(2),h)
    plot_lane_st(lanes(3),h)
    plot_lane_st(lanes(4),h)
    plot_lane_st(lanes(5),h)
    plot_lane_st(lanes(6),h)
    plot_lane_st(lanes(7),h)
    plot_lane_st(lanes(8),h)
    plot_lane_st(lanes(9),h)
    plot_lane_st(lanes(10),h)
    plot_lane_st(lanes(11),h)
    plot_lane_st(lanes(12),h)
    plot_lane_st(lanes(13),h)
    plot_lane_st(lanes(14),h)
    plot_lane_st(lanes(15),h)
    plot_lane_st(lanes(16),h)
    axis equal
    
    % point_plot(cell2mat([{riders.position}']),cell2mat([{riders.color}']),h);
    for player = 1:num_players
        riders(player).gobjects(4) = point_plot2(riders(player).position(1,:), riders(player).color, h);
    end
end

if plot_aero
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
    test_handle_image = imagesc(AeroGrid.Coeffs,[0,max_velo]);
    colormap jet;
    axis xy
    axis equal
    colorbar('southoutside')
    caxis([0 4])
    title('Air Speed (m/s)','HandleVisibility','off'); %retaining title after overwrites
end
%% initial plots (zero-lines)
figure(h)
% initial plot, height
if plot_height
    subplot(test_h)
    hold on
    for player = 1:num_players
        
        riders(player).height = zeros(race_length,1);
        riders(player).height(1) =riders(player).position(1,3);
        riders(player).gobjects(plot_height) = plot(time_var,riders(player).height,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

% initial plot, bank
if plot_bank
    subplot(test_b)
    hold on
    for player = 1:num_players
        riders(player).bank_angle = zeros(race_length,1);
        riders(player).gobjects(plot_bank) = plot(time_var,riders(player).bank_angle,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

% initial plot, steer
if plot_steer
    subplot(test_s)
    hold on
    for player = 1:num_players
        riders(player).steer_angle = zeros(race_length,1);
        riders(player).gobjects(plot_steer) = plot(time_var,riders(player).steer_angle,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_roll
    subplot(test_r)
    hold on
    for player = 1:num_players
        riders(player).roll_angle = zeros(race_length,1);
        riders(player).gobjects(plot_roll) = plot(time_var,riders(player).roll_angle,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_incline
    subplot(test_i)
    hold on
    for player = 1:num_players
        riders(player).incline = zeros(race_length,1);
        riders(player).gobjects(plot_incline) = plot(time_var,riders(player).incline,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_incline_pwr
    subplot(test_i_p)
    hold on
    for player = 1:num_players
        riders(player).p_incline = zeros(race_length,1);
        riders(player).gobjects(plot_incline_pwr) = plot(time_var,riders(player).p_incline,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_velo
    subplot(test_v)
    hold on
    for player = 1:num_players
        riders(player).gobjects(plot_velo) = plot(time_var,riders(player).v_w,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_accel
    subplot(test_a)
    hold on
    for player = 1:num_players
        riders(player).gobjects(plot_accel) = plot(time_var,riders(player).a_cg,'Color',riders(player).property_color);
    end
    xlim([time_var(1),time_var(scroll_length)])
end



if plot_power_lost
    subplot(test_p_l)
    hold on
    for player = 1:num_players
        riders(player).p_loss_total = zeros(race_length,1);
        riders(player).gobjects(plot_power_lost) = plot(time_var,riders(player).p_loss_total,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end



if plot_drag_pwr
    subplot(test_dp)
    hold on
    for player = 1:num_players
        riders(player).p_drag = zeros(race_length,1);
        riders(player).gobjects(plot_drag_pwr) = plot(time_var,riders(player).p_drag,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_drag_c
    subplot(test_dc)
    hold on
    for player = 1:num_players
        riders(player).f_drag = zeros(race_length,1);
        riders(player).gobjects(plot_drag_c) = plot(time_var,riders(player).f_drag,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_v_air
    subplot(test_va)
    hold on
    for player = 1:num_players
        riders(player).v_air = zeros(race_length,1);
        riders(player).gobjects(plot_v_air) = plot(time_var,riders(player).v_air,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_input_pwr
    subplot(test_p_input)
    hold on
    for player = 1:num_players
        
        riders(player).gobjects(plot_input_pwr) = plot(time_var,riders(player).power_input,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_AWC
    subplot(test_AWC)
    hold on
    for player = 1:num_players
        
        riders(player).gobjects(plot_AWC) = plot(time_var,riders(player).AWC,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_constrained_maxP
    subplot(test_cmaxP)
    hold on
    for player = 1:num_players
        
        riders(player).gobjects(plot_constrained_maxP) = plot(time_var,riders(player).constrained_Pmax,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_AL
    subplot(test_AL)
    hold on
    for player = 1:num_players
        
        riders(player).gobjects(plot_AL) = plot(time_var,riders(player).AL,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end

if plot_L
    subplot(test_L)
    hold on
    for player = 1:num_players
        
        riders(player).gobjects(plot_L) = plot(time_var,riders(player).L,'Color',riders(player).property_color);
        
    end
    xlim([time_var(1),time_var(scroll_length)])
end









end





%% iterate position
%while loop, now have to force iterate on the condition that there have
%been no collisions

%variable to time how long it takes for rider(1) to complete a lap


i = 1;
while i < race_length
    
    tic
 
%     if i>=time_of_attack
%         riders(2).controlpos.on=0;
%     end
       %give seperation distance between cyclist and their opponent 
%     [relative_pos_matrix] = get_relative_positiions_matrix([riders(1).position(end,:); riders(2).position(end,:)],lanes,num_players,[1; 2]);
%     recorded_seperation_distance(i) = relative_pos_matrix(1,2);
%     if recorded_seperation_distance(i)<=0
%         i=race_length;
%     end
    
    for player = 1:num_players
        
%         %test to see if dibben changes his CdA linearly with power 
%         riders(player).Cd_A =  roundtowardvec(riders(1).power_input(i)./1200,[0.25 1]); %0.25 + 0.75 * riders(player).power_input(i)/1.2461e+03;
%         if riders(1).power_input(i) == 0
%             riders(1).lane(i) = 5;
%         end
        
       if riders(player).power_input(i) > riders(player).constrained_Pmax(i)
            riders(player).power_input(i) = riders(player).constrained_Pmax(i);
        end
       
         
        
        
        
        
        
        
        
        
%         if Collisions.on
        if ~isempty(riders(player).overtakingvictimID) %this means the cyclist is currently overtaking someone else
            %so need to check whether the overtaking operation is complete
            %by comparing positions

       
       

           
            [relative_pos_matrix] = get_relative_positiions_matrix([riders(player).position(end,:); riders(riders(player).overtakingvictimID).position(end,:)],lanes,num_players,[player; riders(player).overtakingvictimID]);
            if relative_pos_matrix(player,riders(player).overtakingvictimID)>overtakingdistance %could be 0 meters ahead of the other cyclist but this could be too tight
                %overtake complete, the rider is now ahead of their victim
                %cyclist
                %return to origional lane
                
                 fprintf('%s successfully overtook %s.\n',riders(player).property_color,riders(riders(player).overtakingvictimID).property_color);
                 riders(player).lane(i:end) = riders(player).demand_lane(i:end);
%                  riders(player).controlpos.on=0;
                riders(player).overtakingvictimID = [];
                 riders(player).power_input(i:end) = riders(player).demand_power(i:end);
                 Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i);
            elseif relative_pos_matrix(player,riders(player).overtakingvictimID)<giveupdistance %|| riders(riders(player).overtakingvictimID).lane(i) ~= riders(player).lane(i) - 1
                
                %lost to maximum distance behind - give up and return to
                %origional lane

                % OR, the rider you were trying to overtake is no longer in
                % the lane beneath you
                fprintf('%s giving up overtaking %s.\n',riders(player).property_color, riders(riders(player).overtakingvictimID).property_color);
                riders(player).lane(i:end) = riders(player).demand_lane(i:end);
                riders(player).overtakingvictimID = [];
                % update Collisions.PreviousSignsMat!
                
%                 riders(player).controlpos.on=0;
                Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i);
                riders(player).power_input(i:end) = riders(player).demand_power(i:end);
            else
                %overtake not yet complete, keep on cycling until you reach
                %ahead or giveup
                %Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i);
            
            end
            
            %if complete, return the overtaking cyclist back to their
            %origional lane
            
        end
%         end
        
        
        step_size = riders(player).v_w(i)*dt;
        if i>1
            [new_idx, new_pos] = step_lane_w_change(riders(player).lane_idx,step_size,riders(player).lane(i-1),riders(player).lane(i),lanes);
        else
            [new_idx, new_pos] = step_lane(riders(player).lane_idx,step_size,lanes(riders(player).lane(i)));
        end
        
        
        
        
        if Collisions.on
            if Collisions.RedoTimeStep
                % prev_dir = prev_dir;
            else
                prev_dir = riders(player).vectors.cx;
            end
        else
            prev_dir = riders(player).vectors.cx;
        end
        
        %normal step in position - considering lane changes in each
        %step
        %no faff with the collision detection stuff - just compare
        %lanes. the collision detection just modifies the lanes of the
        %players.
        
        
        
        riders(player).prev_lane_idx = riders(player).lane_idx; %to store previous position for collisions
        riders(player).lane_idx = new_idx;
        riders(player).position(i,:) = new_pos;
        riders(player).height(i) = riders(player).position(i,3);
        
        
        riders(player).vectors = get_vects(MeshSt,riders(player).position(i,:));
        
        if i > 2
            riders(player).steer_angle(i) = get_steer2(riders(player).position(i-2:i,:));
        else
            riders(player).steer_angle(i) = get_steer(riders(player).vectors.cx,prev_dir);
        end
        
        %riders(player).bank_angle(i) = get_bank(riders(player).position(i,:),riders(player).vectors);
        riders(player).bank_angle(i) = lanes(riders(player).lane(i)).bank_angle(riders(player).lane_idx);
        
        Rw = lanes(riders(player).lane(i)).radius_curvatures(riders(player).lane_idx);
        
        
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
            riders(player).v_air(i) = get_aero_coeff(AeroGrid,riders(player).position(i,:));
        else
            %get_aero_coeff2(AeroGrid,current_position,next_position)
            riders(player).v_air(i) = get_aero_coeff5(AeroGrid,riders(player).position(i-1,:),riders(player).position(i,:)); %use the average method
            % riders(player).Cd_A(i) = riders(player).base_Cd_A*get_aero_coeff3(AeroGrid,riders(player).position(i-1,:),riders(player).Bluff.centre_co); %use the centre-minussing the rider's centre, method
        end
        
        % Samad: assuming input velocity is of that at the wheel
        %riders(player).v_w(i) = riders(1).velocity(i);
        
        % kinematics - new_iteration calculations
        
        % kinematics - follow_up calculations
        % TEMP USING 'v_w' rather than 'v_cg' as there is some recursion needed for v_cg        riders(player).necessary_steer_angle(i) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).v_w(i),lanes(riders(player).lane).radius_curvatures(riders(player).lane_idx));
        riders(player).necessary_steer_angle(i) = get_necessary_steer(riders(player).incline(i),riders(player).bank_angle(i),riders(player).v_w(i),lanes(riders(player).lane(i)).radius_curvatures(riders(player).lane_idx));
        
        riders(player).R_w(i) = get_instant_radius(lanes,riders(player).lane(i),riders(player).lane_idx);
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
        
        % riders(player).v_air(i) = get_aero_coeff(AeroGrid,riders(player).position(i,:));
        riders(player).f_drag(i) = get_drag(riders(player).Cd_A,p,(riders(player).v_cg(i) - riders(player).v_air(i)));
        
        riders(player).f_incline(i) = get_f_incline(riders(player).mass,g,riders(player).incline(i));
        
        % powers
        riders(player).p_rolling(i) = get_p_roll(riders(player).f_rolling(i),riders(player).v_w(i));
        riders(player).p_bearing(i) = get_p_bearing(riders(player).f_bearing(i),riders(player).r_br,abs(riders(player).w_w(i,1)));
        riders(player).p_drag(i) = get_p_drag(riders(player).f_drag(i),riders(player).v_cg(i));
        riders(player).p_incline(i) = get_p_incline(riders(player).f_incline(i),riders(player).v_cg(i));
        
        %if we turn off aerodynamics, we also turn off the drag from
        %aerodynamics
        %riders(player).p_drag = riders(player).p_drag.*Aerodynamics_on;
        
        riders(player).p_loss_total(i) = riders(player).p_rolling(i)+riders(player).p_bearing(i)+(riders(player).p_drag(i).*Aerodynamics_on)+riders(player).p_incline(i);
        riders(player).p_loss_total(i) = riders(player).p_loss_total(i)*power_loss_callibration; %CALLIBRATION ADJUSTMENT TO GET MATCHING SPEEDS
        % power from controlled-distance roders
        
        if riders(player).controlpos.on
%             inline_distance = get_distance(riders(player),riders(riders(player).controlpos.follow_id).position(i,:),lanes,i);
    
            [relative_pos_matrix] = get_relative_positiions_matrix([riders(player).position(i,:); riders(riders(player).controlpos.follow_id).position(i,:)],lanes,2,[1; 2]);
            inline_distance = relative_pos_matrix(1,2);
riders(player).controlpos.inline_distance(i) = inline_distance;%get_distance(riders(player),riders(riders(player).controlpos.follow_id).position(i,:),lanes);
           
            riders(player).max_power = riders(player).constrained_Pmax(i);
            
           % power_input = controlled_position_to_power(riders(player).controlpos.rel_dist,inline_distance,riders(player).p_loss_total(i),riders(player).max_power);
           power_input = simple_controller(riders(player).controlpos.rel_dist,inline_distance,riders(player).p_loss_total(i),riders(player).max_power, riders(player).v_w(i),riders(player).mass); 
           
           if power_input > riders(player).constrained_Pmax(i)
                riders(player).power_input(i) = riders(player).constrained_Pmax(i);
            end
            
            riders(player).power_input(i) = power_input;% controlled_position_to_power(riders(player).controlpos.rel_dist,inline_distance,riders(player).p_loss_total(i));
            riders(player).demand_power(i) = power_input;
            %any need to implement this? riders(pl).controlpos.chase_power
            %= 40; - we've already got that nice function for varying power
            %based on relative distance, so this shouldnt be needed
            
        end
        
        if riders(player).power_input(i) > riders(player).constrained_Pmax(i)
            riders(player).power_input(i) = riders(player).constrained_Pmax(i);
        end
        
        riders(player).power_left(i) = riders(player).power_input(i) - riders(player).p_loss_total(i);
        
        
         
     
        
        %forced forward movement
        if  riders(pl).v_w(i) < 0
           riders(player).a_cg(i)=0;
           riders(pl).v_w(i) = 0;
        end
        
        
        if i == 1 || riders(pl).v_w(i) == 0%Starting off acceleration, t=0, OR if speed <= 0 but power input is not zero (we assume the rider then applies full torque)
        
            %first find Tmax
            riders(player).Tmax = get_Tmax_standing(riders(player).power_input(i),riders(player).w_c_start,riders(player).w_c_max);
            
            riders(player).a_cg(i) = get_a_cg_starting(riders(player).Tmax,riders(player).GR,riders(player).R_cw(i), riders(player).R_cg(i), riders(player).R_c(i),riders(player).m_wheel, (riders(player).mass+riders(player).m_bike - riders(player).m_wheel), riders(player).wheel_diameter,...
            riders(player).lean_angle(i), riders(player).Ic1, riders(player).Ic2, riders(player).Iw1, riders(player).Iw2);  
        elseif riders(pl).v_w(i) <= standing_start_velocity %i.e. standing start velocity
            %apply equation 67 in billy's model
           riders(player).Tmax = get_Tmax_standing(riders(player).power_input(i),riders(player).w_c_start,riders(player).w_c_max);
            
         
         riders(player).a_cg(i) = get_a_cg_starting_period(riders(player).Tmax,riders(player).GR,riders(player).p_loss_total(i),riders(player).v_cg(i),riders(player).w_c_max,riders(player).R_cw(i), riders(player).R_cg(i), riders(player).R_c(i),riders(player).m_wheel, (riders(player).mass+riders(player).m_bike - riders(player).m_wheel), riders(player).wheel_diameter,...
            riders(player).lean_angle(i), riders(player).Ic1, riders(player).Ic2, riders(player).Iw1, riders(player).Iw2);    
            
            
        else
          %get acceleration from power
        riders(player).a_cg(i) = get_a_cg(riders(player).power_left(i),riders(player).v_cg(i),riders(player).R_cw(i), riders(player).R_cg(i), riders(player).R_c(i),riders(player).m_wheel, (riders(player).mass+riders(player).m_bike - riders(player).m_wheel), riders(player).wheel_diameter,...
            riders(player).lean_angle(i), riders(player).Ic1, riders(player).Ic2, riders(player).Iw1, riders(player).Iw2);  
            
        end
        
        %get acceleration at wheel
        riders(player).a_w(i) = riders(player).a_cg(i);
       
        
             
        %can we assume acceleration at wheel is the same as the acceleration of
        %the centre gravity?
        
        %change velocity of wheel by time step
        %POWER MODEL ON or OFF
        if Power_model_on
        riders(player).v_w(i+1) = riders(player).v_w(i) + riders(player).a_w(i)*dt;
        end
        
        % physiological maximum_power reduction
        [riders(player).AL(i+1),riders(player).L(i+1),riders(player).constrained_Pmax(i+1)] = M_M_PhysioModel(riders(player).power_input(i),riders(player).Pmax,riders(player).AWC_max,riders(player).AL(i),riders(player).L(i),riders(player).CP(i),dt);
        riders(player).AWC(i+1) = riders(player).AL(i+1) + riders(player).L(i+1);
        
    end
    
   
    
    % check collisions here
    if Collisions.on
    for k = 1:num_players
        for j  = 1:num_players
            %if riders are on the same lane
            if riders(k).lane(i) == riders(j).lane(i)
                %take the minimum distance
                Collisions.mindistances(k,j) = riders(k).lane_idx - riders(j).lane_idx; %notice notation convention (i,j) = i - j
                Collisions.mindistances250(k,j) = (riders(k).lane_idx - lanes(riders(k).lane(i)).Length) - riders(j).lane_idx;
                
            else
                Collisions.mindistances(k,j) = nan;
                Collisions.mindistances250(k,j) = nan;
            end
            %else set distance to nan/0
        end
    end
    
    if i == 1 %i.e. the first time step
        Collisions.MinDistancesFlag = abs(Collisions.mindistances) >  abs(Collisions.mindistances250); %this stores hwhether the minimum is taken by 250m difference. we need to use the same convention for our next time step
        %now store only the distances below 50m in the filtered distances.
        Collisions.mindistancesboth = Collisions.mindistances.*(1-Collisions.MinDistancesFlag) + Collisions.mindistances250.*(Collisions.MinDistancesFlag);
        Collisions.FilteredDistances = (Collisions.mindistancesboth -Collisions.ThreshMat).*(abs(Collisions.mindistancesboth) < 50); %corrected for thresholds
        Collisions.PreviousSignsMat = sign(Collisions.FilteredDistances ); %THIS is the signs matrix we want to compare each time step. We need information about whether the 250m was used or not aswell.
        
    else %i.e. now we're using the previous time-step's mindistanceflags to choose 250m or not
%         Collisions.PreviousSignsMat = Collisions.SignsMat;
        Collisions.MinDistancesFlag = Collisions.MinDistancesFlag; %i.e. this is the same as previous time step's one - no change happened across time steps.
        %now store only the distances below 50m in the filtered distances.
        Collisions.mindistancesboth = Collisions.mindistances.*(1-Collisions.MinDistancesFlag) + Collisions.mindistances250.*(Collisions.MinDistancesFlag);
        Collisions.FilteredDistances = (Collisions.mindistancesboth -Collisions.ThreshMat).*(abs(Collisions.mindistancesboth) < 50); %corrected for thresholds
        Collisions.SignsMat = sign(Collisions.FilteredDistances );
        
        %shall we force signs-mat to be non-zero too?
         if any(any(ismember(Collisions.SignsMat,0)))
           % fprintf('0 sign');
            %force the '0' to be the opposite of its transpose
            trans_signs = transpose(Collisions.SignsMat);
            idx = find(Collisions.SignsMat==0);
            Collisions.SignsMat(idx) = -trans_signs(idx);
        end
        
        
        Collisions.Differences = Collisions.SignsMat - Collisions.PreviousSignsMat;
        Collisions.Differences = Collisions.Differences.*(ones(num_players) - eye(num_players)); %removing 'self-overtaking'
        %     Collisions.OverTakersID = [];
        %     Collisions.BeingOverTakenID  = [];
        Collisions.RedoTimeStep = 0;
        if any(Collisions.Differences(:) == -2)
            %collision occured
            % disp('collision occured')
            %between who and who? who is trying to overtake?
            %(i,j) = -2. this means j overtakes i.
            [beingovertakenID,overtakerID] =  find(Collisions.Differences==-2);
            Collisions.OverTakersID = overtakerID;
            Collisions.BeingOverTakenID  = beingovertakenID;
            Collisions.RedoTimeStep = 1;
            for collisions = 1:size(beingovertakenID)
                fprintf('%s over taking %s.\n',riders(overtakerID(collisions)).property_color,riders(beingovertakenID(collisions)).property_color);
                if riders(overtakerID(collisions)).lane(i) == num_lanes
                fprintf('cannot overtake because at edge of velodrome - allow collision to occur (temporary solution - expect next student to solve this) \n')
                Collisions.RedoTimeStep = 0;
%                 riders(overtakerID(collisions)).controlpos.on=1;
%                 % follow the nearest rider to you on that lane
%                 riders(overtakerID(collisions)).controlpos.follow_id = beingovertakenID(collisions);
                else
                riders(overtakerID(collisions)).lane(i:end) = riders(overtakerID(collisions)).lane(i:end) + 1; %check if lane is less than 4 (as 4 is max). if it goes above 4, then either have to choose lower lane, or slow down
                
                riders(overtakerID(collisions)).power_input(i:end) = riders(player).demand_power(i:end) + overtaking_power;
                riders(overtakerID(collisions)).overtakingvictimID = beingovertakenID(collisions);
                end
            end
            
            
%             %temporary
           %Collisions.PreviousSignsMat = Collisions.SignsMat;
           Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i);
           
        elseif any(Collisions.Differences(:) == 2) %just incase the overtaking is not detected as its too long across time steps i.e. sign change doesnt occur across one time step
            %collision occured
            % disp('collision occured - 2')
            %between who and who? who is trying to overtake?
            %(i,j) = -2. this means j overtakes i.
            [overtakerID,beingovertakenID] =  find(Collisions.Differences==2);
            Collisions.OverTakersID = overtakerID;
            Collisions.BeingOverTakenID  = beingovertakenID;
            Collisions.RedoTimeStep = 1;
            for collisions = 1:size(beingovertakenID)
                fprintf('%s over taking %s.\n',riders(overtakerID(collisions)).property_color,riders(beingovertakenID(collisions)).property_color);
                if riders(overtakerID(collisions)).lane(i) == num_lanes
                   fprintf('cannot overtake because at edge of velodrome - allow collision to occur (temporary solution - expect next student to solve this) \n')
                Collisions.RedoTimeStep = 0;
                else
                    riders(overtakerID(collisions)).lane(i:end) = riders(overtakerID(collisions)).lane(i:end) + 1; %check if lane is less than 4 (as 4 is max). if it goes above 4, then either have to choose lower lane, or slow down
                    riders(overtakerID(collisions)).power_input(i:end) = riders(player).demand_power(i:end) + overtaking_power;
                    riders(overtakerID(collisions)).overtakingvictimID = beingovertakenID(collisions);
                end
            end
            
%             %temporary
            %Collisions.PreviousSignsMat = Collisions.SignsMat;
            Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i);
            
            
            
        end
       
        
    end
    end
    
    
   
    % if collision
    % change lanes, power penalty
    % reset time step back to i
    
    
    if ~Collisions.RedoTimeStep || ~Collisions.on
        
        AeroGrid.Coeffs = zeros(size(AeroGrid.z_mat));
        for player = 1:num_players
            %ADDING ENERGIES INSTEAD OF VELOCITIES therefore take to the
            %power of 3, sum, then take to the power of 1/3
            wakeprofile = shift_wake_profile(highreswake,lanes(riders(player).lane(i)),lanes(riders(player).lane(i)).cumS(riders(player).lane_idx));
            kernel = wake_to_kernel(AeroGrid,wakeprofile,lanes(riders(player).lane(i)));
            scaled_kernel = kernel*riders(player).v_w(i)/u_inf;
            AeroGrid.Coeffs = AeroGrid.Coeffs + scaled_kernel.^3;
            
            
            
        end
        AeroGrid.Coeffs = AeroGrid.Coeffs.^(1/3);
        AeroGrid.Coeffs = AeroGrid.Coeffs + swirl_velo*ones(size(AeroGrid.Coeffs));
%         AeroGrid.Coeffs = AeroGrid.Coeffs.*Aerodynamics_on;
        %     % ENERGISATION SHOULD BE AFTER ALL THE PLAYERS HAVE BEEN UPDATED
        %         for player = 1:num_players
        %         AeroGrid.Coeffs = energise_aerogrid(AeroGrid,riders(player).position(i,:), riders(player).vectors.cx, riders(player).Bluff);
        %
        %         end
        %         AeroGrid.Coeffs = recover_aerogrid(AeroGrid.Coeffs, AeroGrid.BaseCoeffs);
        
        
        %% UPDATE GRAPHICS
        
        if graphical_display
            if plot_3d
                subplot(test_3d)
                for player = 1:num_players
                    
                    riders(player).gobjects(4) = update_plot(riders(player).position(i,:), riders(player).gobjects(4));
                end
            end
            
            %height plot
            if plot_height
                subplot(test_h)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_height) = update_properties_plot(riders(player).height,riders(player).gobjects(plot_height));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            
            %bank plot
            if plot_bank
                subplot(test_b)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_bank) = update_properties_plot(riders(player).bank_angle,riders(player).gobjects(plot_bank));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            %steer plot
            if plot_steer
                subplot(test_s)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_steer) = update_properties_plot(riders(player).steer_angle,riders(player).gobjects(plot_steer));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_roll
                subplot(test_r)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_roll) = update_properties_plot(riders(player).roll_angle,riders(player).gobjects(plot_roll));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_incline
                subplot(test_i)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_incline) = update_properties_plot(riders(player).incline,riders(player).gobjects(plot_incline));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_incline_pwr
                subplot(test_i_p)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_incline_pwr) = update_properties_plot(riders(player).p_incline,riders(player).gobjects(plot_incline_pwr));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_power_lost
                subplot(test_p_l)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_power_lost) = update_properties_plot(riders(player).p_loss_total,riders(player).gobjects(plot_power_lost));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_velo
                subplot(test_v)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_velo) = update_properties_plot(riders(player).v_w,riders(player).gobjects(plot_velo));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_accel
                subplot(test_a)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_accel) = update_properties_plot(riders(player).a_cg,riders(player).gobjects(plot_accel));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_drag_pwr
                subplot(test_dp)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_drag_pwr) = update_properties_plot(riders(player).p_drag,riders(player).gobjects(plot_drag_pwr));
                end
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_drag_c
                subplot(test_dc)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_drag_c) = update_properties_plot(riders(player).f_drag,riders(player).gobjects(plot_drag_c));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_v_air
                subplot(test_va)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_v_air) = update_properties_plot(riders(player).v_air,riders(player).gobjects(plot_v_air));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_input_pwr
                subplot(test_p_input)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_input_pwr) = update_properties_plot(riders(player).power_input,riders(player).gobjects(plot_input_pwr));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            
            if plot_AWC
                subplot(test_AWC)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_AWC) = update_properties_plot(riders(player).AWC,riders(player).gobjects(plot_AWC));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_constrained_maxP
                subplot(test_cmaxP)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_constrained_maxP) = update_properties_plot(riders(player).constrained_Pmax,riders(player).gobjects(plot_constrained_maxP));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_AL
                subplot(test_AL)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_AL) = update_properties_plot(riders(player).AL,riders(player).gobjects(plot_AL));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_L
                subplot(test_L)
                hold on
                for player = 1:num_players
                    riders(player).gobjects(plot_L) = update_properties_plot(riders(player).L,riders(player).gobjects(plot_L));
                end
                
                %set scrolling axes
                if i>scroll_length
                    xmax = i;
                    xmin = i-scroll_length;
                    xlim([time_var(xmin),time_var(xmax)])
                end
            end
            
            if plot_aero
                subplot(Aero_fig)
                set(test_handle_image,'CData',AeroGrid.Coeffs);
            end
            
            
            drawnow
            while toc<=dt*visual_speed
                
            end
        end
        
        
        Collisions.OverTakersID = [];
        Collisions.BeingOverTakenID  = [];
        i = i+1;
        if mod(i,race_length/100)==0
            fprintf('%d percent \n',i/100)
        end
        
    else
        % collision has occured, need to change player lane, penalty, and
        % repeat iteration i.e. i = i.
        % i = i;
        disp('collision occured: repeating iteration')
        for player = 1:num_players
            riders(player).lane_idx = riders(player).prev_lane_idx;
        end
        %Collisions.OverTakersID
    end
    
    
end



