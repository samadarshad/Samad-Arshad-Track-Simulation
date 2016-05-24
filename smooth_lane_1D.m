%using a gaussian window of 40
%lane needs smoothening in z-direction because of sharp jumps

function sm_lane = smooth_lane_1D(lane, varargin)

%smooth lane
%need to add on to the vector because it is circular and the edges wont get
%smoothed
m = size(lane,1);
extended_lane = [lane; lane; lane]; %could be more efficient here by only 
%taking lane up to '40' steps away from either side, rather than taking the whole lane copies

if isempty(varargin)
    window_size = 20;
else
    window_size = varargin{1};
end

% Construct blurring window.
% windowWidth = int16(window_size);
% halfWidth = windowWidth / 2

gaussFilter = gausswin(window_size);
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.

% Do the blur.
%smoothedVector = conv(extended_lane, gaussFilter);
%ignore nans
smoothedVector = nanconv(extended_lane, gaussFilter);

sm_lane = [smoothedVector(m+1:2*m)];
sm_lane= sm_lane(:);

%% plot closed curve
%plot3([lane(:,1); lane(1,1)],[lane(:,2); lane(1,2)],[smoothedVector(m+1:2*m); smoothedVector(m+1)]);
%plot3(S.X,S.Y,S.Level*ones(m,1))



end