%for optimisation purposes, the function finds the 'artificial' lane 
%'defect' is the target of the fminsearch and will be minimised,
%point_correct is returned
function [defect, point_correct] = find_artif_lane(artif_space,lane_space,S,MeshSt,i)
%function to create a track lane which is equidistant from a contour

%point on base contour

% i = 1;
% lane_space = 1;

point = [S.X(i) S.Y(i)];
p_z = get_z(MeshSt,point);
point3 = [point p_z];

%get slope
VectsStruct = get_vects(MeshSt,point3);

%guess new location
point_guess = point3 + VectsStruct.sl * artif_space;
%correct guess
p_z_2 = get_z(MeshSt,point_guess);
point_correct = [point_guess(:,1:2) p_z_2];

dist = norm(point_correct- point3);
defect = abs(lane_space-dist);
%for optimisation purposes
end

