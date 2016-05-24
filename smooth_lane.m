%using a gaussian window of 40
%lane needs smoothening in z-direction because of sharp jumps

function sm_lane = smooth_lane(lane)

%smooth lane
%need to add on to the vector because it is circular and the edges wont get
%smoothed
m = size(lane,1);
extended_lane = [lane; lane; lane]; %could be more efficient here by only 
%taking lane up to '40' steps away from either side, rather than taking the whole lane copies


window_size = 40;

% Construct blurring window.
% windowWidth = int16(window_size);
% halfWidth = windowWidth / 2

gaussFilter = gausswin(window_size);
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.

% Do the blur.
smoothedVector = conv(extended_lane(:,3), gaussFilter);

sm_lane = [lane(:,1) lane(:,2) smoothedVector(m+1:2*m)];


%% plot closed curve
%plot3([lane(:,1); lane(1,1)],[lane(:,2); lane(1,2)],[smoothedVector(m+1:2*m); smoothedVector(m+1)]);
%plot3(S.X,S.Y,S.Level*ones(m,1))



end