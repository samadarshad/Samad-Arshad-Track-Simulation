%function to get relative positions of cyclists on the field
%inputs - all cyclists positions 3xn matrix, the function to project onto a lane, the
%250m lane
%outputs - a nxn matrix giving relative positions of each cyclist to one
%other in terms of lane segments, NOT meters

%cyclists_positions and IDs same size, num_players defines the size of the
%matrix to return so it is standardised. 
function [relative_pos_matrix] = get_relative_positiions_matrix(cyclists_positions,lanes,num_players,IDs)
[m,~] = size(cyclists_positions);
lane250 = 1; %lane number for the 250m lane that were projecting to
zoom_in_distance = 100; %<588/2 lane-segments , assumed that riders are within x-lane segments of each other. accounts for big jumps across starting line. 
for player = 1:m
[lane_idx(player), ~] = lane_change2(lane250, lanes, cyclists_positions(player,:));
end

relative_distances_matrix = zeros(m);
relative_distances_matrix250 = zeros(m);
for front = 1:m
    for rear = 1:m
        relative_distances_matrix(front,rear) = lane_idx(front) - lane_idx(rear);
        relative_distances_matrix250(front,rear) = (lane_idx(front)- lanes(lane250).Length) - lane_idx(rear);
    end
end



%create matrix of relative positions
 %relative_pos_matrix = sign(relative_distances_matrix);
  relative_pos_matrix = relative_distances_matrix;
  
  
  %actually - lets keep the information about distances, because we will
  %need to know for knowing when to 'give up'
  
 %if the difference is greater than +- 125, then the positions changes sign
 %(i.e. this means weve passed the starting point)

relative_pos_matrix_standardised = zeros(num_players);


end