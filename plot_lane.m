%function to plot3 lane
%lane to be nx3 vector
function plot_lane(lane, varargin)


plot3(lane(:,1), lane(:,2), lane(:,3), varargin{:});

end