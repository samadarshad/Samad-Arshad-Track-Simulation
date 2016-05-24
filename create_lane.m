%function to get vector of new points along lane, optimises on artif lane
function lane_point = create_lane(space,S,MeshSt)
m = length(S.X);
artif_space = zeros(m,1);
lane_point = zeros(m,3);
tic
for i = 1:m %if want this to be quick to test, change this m to something like '5'
artif_space(i) = fminsearch(@(x)find_artif_lane(x,space,S,MeshSt,i),1);
[~,lane_point(i,:)] = find_artif_lane(artif_space(i),space,S,MeshSt,i);
end
toc
% plot3(lane(:,1),lane(:,2),lane(:,3))
% hold on
% plot3(S.X,S.Y,S.Level*ones(m,1))
end
