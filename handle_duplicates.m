function newtestlane = handle_duplicates(testlane)

%handle lane aeromesh double counting by averaging the uv coordinates that
%map to it
%want to achieve a 1-to-1 mapping between xy and uv
m = length(testlane.x(:));
A = [testlane.x(1:m); testlane.y(1:m)];
%for each xy in the aero mesh
[unique_vecs,~,ic] = unique(A','rows');

%find all its corresponding uvs
idxs=[];
u_mean=[];
v_mean=[];
for i=1:length(unique_vecs);
idxs{i} = find(ic==i);
u_s{i} = testlane.u(idxs{i}); %assuming the indexes are consistent between xy and uv
v_s{i} = testlane.v(idxs{i});


%average the uv coordinates
u_mean(i) = mean(u_s{i});
v_mean(i) = mean(v_s{i});
end

%create new unique xy with averaged uv (possibly keep order?
newtestlane.x = unique_vecs(:,1);
newtestlane.y = unique_vecs(:,2);
newtestlane.u = u_mean;
newtestlane.v = v_mean;


%scatter(newtestlane.x(:),newtestlane.y(:))

end