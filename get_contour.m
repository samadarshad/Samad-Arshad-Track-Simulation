function S = get_contour(height)

[MeshSt, VectsStruct] = MeshStruct
% contour(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat)
% axis square
% hold on


S = contourcs(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat,[height height]);


%% keep on repeating this until size S == 1

m = size(S,1);
while m ~= 1
%find new F
F = zeros(m,2);
L = zeros(m,2);
for i = 1:m
F(i,:) = [S(i).X(1) S(i).Y(1)];
L(i,:) = [S(i).X(end) S(i).Y(end)];
end

%secton 1
collate_vec=[];
for i = 2:m
collate_vec = [collate_vec; F(i,:); L(i,:)];
end
idx_nearest = dsearchn(collate_vec,L(1,:)); 

%need a check to see if the search was successful?

%get segment
segment = 1+round(idx_nearest/2); %plus 1 because the first segment is already taken

%if odd, F, even L
if mod(idx_nearest,2) == 1
    %odd F
    %simply connect segment 1 with segment 
    S_new = S;
    %collate the segment
    S_new(1).Length = S(1).Length + S(segment).Length;
    S_new(1).X = [S(1).X S(segment).X];
    S_new(1).Y = [S(1).Y S(segment).Y];
    S_new(segment) = []; %delete the segment remains
    
else
    %even L
    %flip the segment and connect
    S_new = S;
    %collate the segment
    S_new(1).Length = S(1).Length + S(segment).Length;
    S_new(1).X = [S(1).X flip(S(segment).X)];
    S_new(1).Y = [S(1).Y flip(S(segment).Y)];
    S_new(segment) = []; %delete the segment remains
end
S = S_new;
m = size(S,1);
end

end

% 
% 
% 
% cline_vec = [[S.X]' [S.Y]'];
% idx_nearest = dsearchn(cline_vec,[point3_next(1) point3_next(2)]);
% interp_point = [cline_vec(idx_nearest,1:2) S(1).Level]; %assuming the same contour levels within S
