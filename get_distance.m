%function to find actual distance (along track u-direction, ignoring
%v-direction) between two players. value is taken as the 'current player' -
%the 'reference player' so that its a negative number

%which u-distance do you take? there are multiple lanes with different
%distances - perhaps interpolate the 'target' rider to your lane and
%calculate the distance? or interpolate yourself to the target rider's lane
%and calculate the distance? lets go with the first option - for no reason

%inputs are 'you' rider.struct containing rider lane and position, then
%also the 'target rider' rider position
%lanes for interpolation and distance measuring

function inline_distance = get_distance(you,target_rider_position,lanes,i)

%first interpolate the target rider to your lane
inline_target_rider_lane_idx = dsearchn([lanes(you.lane(i)).X lanes(you.lane(i)).Y],target_rider_position(1:2));

%then calculate distance along lane from you to him
current_pos_lane_idx = you.lane_idx;
%assuming just catching up within the same lap (i.e. rather than trying to
%make up 2 over-laps to get to him)

%assuming lane index keeps increasing along the direction of the race

%have to make an assumption: that any rider behind you by half of the
%court, is behind you, and any rider infront by half is infront. . so this
%determines which 'arc' of the loop you take i.e. you always take the
%shorter arc
tol =10; %= 
behind=0;
idxs=[];
if inline_target_rider_lane_idx<current_pos_lane_idx && (current_pos_lane_idx-inline_target_rider_lane_idx)>=(tol) %lanes(you.lane).Length/2
    %here the rider has just crossed the zero-resetting line and is infront
    %of you
    idxs = [current_pos_lane_idx:lanes(you.lane(i)).Length 1:inline_target_rider_lane_idx];
elseif inline_target_rider_lane_idx<current_pos_lane_idx && (current_pos_lane_idx-inline_target_rider_lane_idx)<(lanes(you.lane(i)).Length-tol) %lanes(you.lane).Length/2
    %here your target rider is BEHIND you i.e. positive distance
    idxs = inline_target_rider_lane_idx:current_pos_lane_idx;
    behind  =1;    
elseif inline_target_rider_lane_idx>current_pos_lane_idx
    %here the rider is infront of you (and has not yet crossed the zero
    %resetting line)
    idxs = current_pos_lane_idx:inline_target_rider_lane_idx;
end

%if on top of each other
if length(idxs)==1 || isempty(idxs)
    idxs=[];
end



%sum up the distance (negative because if rider is infront of you, you are
%negative distance from him
inline_distance = -sum(lanes(you.lane(i)).dS(idxs));

if behind
    inline_distance = -inline_distance;
end


end
