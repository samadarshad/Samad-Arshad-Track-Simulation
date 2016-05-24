%cyclist struct



function rider_struct = cyclist_struct(number_players)

%% RIDER PROPERTIES
% lane_struct.Distance = recall distance the lane is from the base?
rider_struct(number_players).position = []; %contains history of positions
rider_struct(number_players).velocity = [];
rider_struct(number_players).color = [];
rider_struct(number_players).property_color = [];
rider_struct(number_players).lane = [];

%% BASE INPUTS
rider_struct(number_players).power_input = [];


%% RIDER TO LANE

%or just, for simplicity, combine it here - tighly coupled
rider_struct(number_players).lane_idx = [];
rider_struct(number_players).vectors = [];
rider_struct(number_players).bank_angle = [];
rider_struct(number_players).steer_angle = [];
rider_struct(number_players).height = [];
rider_struct(number_players).incline = [];

%% KINEMATICS
rider_struct(number_players).v_cg = [];
rider_struct(number_players).R_cg = [];

rider_struct(number_players).v_w = [];
rider_struct(number_players).R_w = [];

rider_struct(number_players).v_cw = [];
rider_struct(number_players).R_cw = [];

rider_struct(number_players).angular_velo = [];
%rider_struct(number_players).wheel_angular_velo = [];

rider_struct(number_players).a_cg = [];

rider_struct(number_players).R_c = [];

% standing start
rider_struct(number_players).w_c_max = []; 
rider_struct(number_players).w_c_start = [];



%% GRAPHICS
%3 properties - height, banking, steer, 3D point plot
graphic_props = 5;
rider_struct(number_players).gobjects = gobjects(graphic_props,1);


%% RIDER CONSTANTS
rider_struct(number_players).mass = [];
rider_struct(number_players).base_Cd_A = [];


rider_struct(number_players).Cd_A = []; %drag coefficient
rider_struct(number_players).h_cg = []; %centre of gravity height
rider_struct(number_players).power_inclination = [];
rider_struct(number_players).power_drag = [];


rider_struct(number_players).Ic1 = []; %moment of intertia of bike frame
rider_struct(number_players).Ic2 = [];

%% ENERGY
%rider_struct(number_players).power_loss = [];
rider_struct(number_players).power_left = [];


%% FORCES
rider_struct(number_players).f_contact = [];
rider_struct(number_players).f_norm_front = [];
rider_struct(number_players).f_norm_rear = [];

%% RESISTANCE FORCES

%rider_struct(number_players).f_friction = [];
rider_struct(number_players).f_rolling = [];
rider_struct(number_players).f_bearing = [];
rider_struct(number_players).f_incline = [];
rider_struct(number_players).f_drag = [];

%% RESISTANCE POWERS (may contain duplicates)
rider_struct(number_players).p_loss_total = [];
%rider_struct(number_players).p_friction = [];
rider_struct(number_players).p_rolling = [];
rider_struct(number_players).p_bearing = [];
rider_struct(number_players).p_incline = [];
rider_struct(number_players).p_drag = [];

%% BICYCLE CONSTANTS
rider_struct(number_players).Ca = [];
rider_struct(number_players).Cy = [];
rider_struct(number_players).rake_angle = [];
rider_struct(number_players).wheel_diameter = [];
rider_struct(number_players).r_br = [];
rider_struct(number_players).C_br = [];
rider_struct(number_players).m_bike = [];
rider_struct(number_players).m_wheel = []; %mass of one or two wheels?
rider_struct(number_players).Iw1 = []; %moment of inertia of wheel
rider_struct(number_players).Iw2 = [];

%% BICYCLE VARIABLES
rider_struct(number_players).Crr_front = [];
rider_struct(number_players).Crr_rear = [];
rider_struct(number_players).slip_front = [];
rider_struct(number_players).slip_rear = [];
rider_struct(number_players).camber_front = [];
rider_struct(number_players).camber_rear = [];
rider_struct(number_players).velo_normal = [];
rider_struct(number_players).velo_tang = [];
rider_struct(number_players).heading_angle = [];
rider_struct(number_players).lean_angle = [];
rider_struct(number_players).roll_angle = [];
rider_struct(number_players).necessary_steer_angle = [];




%% BODY POSITION
rider_struct(number_players).a = [];
rider_struct(number_players).b = [];

%% AERODYNAMICS

rider_struct(number_players).Bluff = []; %get bluff()


%% COLLISION DETECTION
% this is the minimum distance ahead and behind the cyclist. Only one
% length, assuming symmetric thresholds either side. The sideways threshold
% is assumed to be 0 (i.e. cyclists can be elbow-to-elbow) - however this
% threshold for sideways distance is not really needed because we assume
% the cyclist travels in scaletrix lanes only which gives sufficient
% spacing between the cyclists across lanes.
rider_struct(number_players).collision_distance = [];
rider_struct(number_players).prev_lane_idx = [];
rider_struct(number_players).demand_lane = [];
rider_struct(number_players).overtakingvictimID = [];



%% PHYSIOLOGICAL (Margaria Morton model)
rider_struct(number_players).Pmax = [];
rider_struct(number_players).constrained_Pmax = [];
rider_struct(number_players).AWC_max = [];
rider_struct(number_players).AL = [];
rider_struct(number_players).L = [];
rider_struct(number_players).AWC = [];
rider_struct(number_players).CP = [];


end



    
    
    
    
