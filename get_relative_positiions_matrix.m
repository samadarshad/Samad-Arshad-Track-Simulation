%function to get relative positions of cyclists on the field
%inputs - all cyclists positions 3xn matrix, the function to project onto a lane, the
%250m lane
%outputs - a nxn matrix giving relative positions of each cyclist to one
%other in terms of lane segments, NOT meters

%cyclists_positions and IDs same size, num_players defines the size of the
%matrix to return so it is standardised. 
function [min_abs_matrix] = get_relative_positiions_matrix(cyclists_positions,lanes,num_players,IDs)
[m,~] = size(IDs);
lane250 = 1; %lane number for the 250m lane that were projecting to
zoom_in_distance = 100; %<588/2 lane-segments , assumed that riders are within x-lane segments of each other. accounts for big jumps across starting line. 
for player = 1:m
[lane_idx(player), ~] = lane_change2(lane250, lanes, cyclists_positions(player,:));
end

relative_distances_matrix = zeros(num_players);
relative_distances_matrix250 = zeros(num_players);
for front = 1:m
    for rear = 1:m
        relative_distances_matrix(IDs(front),IDs(rear)) = lane_idx(front) - lane_idx(rear);
        relative_distances_matrix250(IDs(front),IDs(rear)) = (lane_idx(front)- lanes(lane250).Length) - lane_idx(rear);
    end
end



%create matrix of relative positions
 %relative_pos_matrix = sign(relative_distances_matrix);
  relative_pos_matrix = relative_distances_matrix;
  
  
  %actually - lets keep the information about distances, because we will
  %need to know for knowing when to 'give up'
  
 %if the difference is greater than +- 125m, then the positions changes sign
 %(i.e. this means weve passed the starting point)
MinDistancesFlag = abs(relative_distances_matrix) >  abs(relative_distances_matrix250); %this stores hwhether the minimum is taken by 250m difference. we need to use the same convention for our next time step
        %now store only the distances below 50m in the filtered distances.
        mindistancesboth = relative_distances_matrix.*(1-MinDistancesFlag) + relative_distances_matrix250.*(MinDistancesFlag);
       % FilteredDistances = (mindistancesboth -Collisions.ThreshMat).*(abs(mindistancesboth) < 50); %corrected for thresholds
        
relative_pos_matrix = mindistancesboth;
min_abs_matrix = relative_pos_matrix;
%force matrix to be oppositely symmetric using the minimum distances only
neg_trans_distances = -transpose(mindistancesboth);
diff_mat = relative_pos_matrix - neg_trans_distances;
%ideally want the diff mat to equal 0. if it is not 0, this means the
%difference was taken through the long route rather than the short route


if ~isempty(find(diff_mat ~= 0))
%find the short route by taking the minimum of each element in the
%origional and transposed matrix
for i = 1:size(relative_distances_matrix,1)
    for j = 1:size(relative_distances_matrix,1)
        if abs(relative_pos_matrix(i,j))>abs(neg_trans_distances(i,j))
            min_abs_matrix(i,j) = neg_trans_distances(i,j);
        end
    end
end

            


end
% if any(any(ismember(diff_mat,0)))
%             
%             %force the '0' to be the opposite of its transpose
%             trans_previous_signs = transpose(Collisions.PreviousSignsMat);
%             idx = find(Collisions.PreviousSignsMat==0);
%             Collisions.PreviousSignsMat(idx) = -trans_previous_signs(idx);
%         end


end