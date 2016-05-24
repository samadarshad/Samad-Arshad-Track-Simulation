% using UCI rules to find the lanes

%want base height (assumed at z = 0 for simplicity's sake) at constant z
%i.e. contour
height = 0;
base = get_contour(height)

%base is a constant-height contour, assumed to be the base lane

%we want the black line, 20cm above the base lane. check that it is near
%250m. if not, we may have to change the base lane

black_space = 0.2;
black_lane = create_lane(black_space,base,MeshSt); %long 1-minute process
%get length
length_track = get_track_length(black_lane(:,1), black_lane(:,2), black_lane(:,3))
%  smoothen out
sm_black_lane = smooth_lane(black_lane);
length_track_sm = get_track_length(sm_black_lane(:,1), sm_black_lane(:,2), sm_black_lane(:,3))
%get length  250.7286 compared to non-smooth 250.7863
%therefore smoothening the lane is ok
%we could test whether the black_space could be better than 0.2m to achieve
%250m exactly, but for purposes of simplicity, this 0.7286m extra is ok and
%could be taken as a small error relative to all the other simplifications
%we will be making later in the model

%% sprinters lane, red
red_space = 0.85;

red_lane = create_lane(red_space,base,MeshSt); %long 1-minute process
%get length
length_track = get_track_length(red_lane(:,1), red_lane(:,2), red_lane(:,3))
%  smoothen out
sm_red_lane = smooth_lane(red_lane);

%% stayers lane, blue
blue_space = 2.45;

blue_lane = create_lane(blue_space,base,MeshSt); %long 1-minute process
%get length
length_track = get_track_length(blue_lane(:,1), blue_lane(:,2), blue_lane(:,3))
%  smoothen out
sm_blue_lane = smooth_lane(blue_lane);


%% plot lanes
plot_lane(sm_black_lane,'Color','black')
hold on;
plot_lane(sm_blue_lane,'Color','blue')
plot_lane(sm_red_lane,'Color','red')
plot3(base.X,base.Y,base.Level*ones(size(base.X)),'Color',[165 42 42]./255)
