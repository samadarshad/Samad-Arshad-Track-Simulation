%lane struct
%input lane should be a Nx3 matrix where N is the data points along the lane, varargin is for colour i.e. 'ro' for
%red circles
function lane_struct = lane_to_struct(lane,varargin) %MeshSt used for vectors along lane
% lane_struct.Distance = recall distance the lane is from the base?
lane_struct.Length = length(lane);
lane_struct.X = lane(:,1);
lane_struct.Y = lane(:,2);
lane_struct.Z = lane(:,3);
[lane_struct.tracklength, lane_struct.dS] = get_track_length(lane_struct.X,lane_struct.Y,lane_struct.Z);  
lane_struct.cumS = cumsum(lane_struct.dS);
if ~isempty(varargin)
    lane_struct.color = varargin{:};
else 
    lane_struct.color = [];
end


end
