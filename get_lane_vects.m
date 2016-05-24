%function to get vectors of lane


function lane_vects = get_lane_vects(lane, MeshSt)
%memory pre-allocation so doing it backwards

    lane_vects = get_vects(MeshSt,[lane.X lane.Y]);




end

% function lane_vects = get_lane_vects(lane, MeshSt)
% %memory pre-allocation so doing it backwards
% for i = lane.Length:-1:1
%     lane_vects(i) = get_vects(MeshSt,[lane.X(i) lane.Y(i)]);
% end
% 
% 
% 
% end