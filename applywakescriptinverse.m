load('WakeMat.mat')

%choose lane 3 as our lane

%choose player at idx = 0, so u = u (+0) no offset

%INVERSE mapping - choosing points on grid and finding the corresponding
%wake index
%% for each pixel in the aero
ztest_velox = zeros(size(MeshSt.z_mat));
gtest.x_vec = MeshSt.x_vec;
gtest.y_vec = MeshSt.y_vec;
[gtest.index_x, gtest.index_y] = meshgrid(1:size(AeroGrid.z_mat,2),1:size(AeroGrid.z_mat,1)); %just stealing from aerogrid
testlane = lanes(3);
testwake.x = Wx2;
testwake.y = Wy;
testwake.z = Wzg2;


x_all = MeshSt.x_mat(:);
y_all = MeshSt.y_mat(:);

%for interpolation - it requires the format of meshgrid
testlane.aero_mapping.x_vec = testlane.aero_mapping.x(:);
testlane.aero_mapping.y_vec = testlane.aero_mapping.y(:);
testlane.aero_mapping.u_vec = testlane.aero_mapping.u(:);
testlane.aero_mapping.v_vec = testlane.aero_mapping.v(:);

%%

%%

 dt = delaunayTriangulation([testlane.aero_mapping.x_vec,testlane.aero_mapping.y_vec]);
 
  [xi,dd] = nearestNeighbor(dt, [x_all,y_all]); %inverse-mapping: indicies of aeromapping all the mesh points are nearest to
  %want to make sure the mapping makes sense and there is a tolerance to
  %the nearness i.e. output the distances and return only the ones with

%   %note - these two arrays may NOT be matched because multiple grid points
  %may converge to teh same lane mesh because of dd<0.9
  
  %lets try dd==0
  idx_aeromesh = xi;
  dist_to_aeromesh = dd;
 % idx_exactly_on_mesh = find(dd==0);
  
  %idx_near(dd>1.5) = nan;
  
  
  %get x and y points on the grid which were successfully matched
  x_vals = testlane.aero_mapping.x_vec(idx_aeromesh);
  y_vals = testlane.aero_mapping.y_vec(idx_aeromesh);
  
%   x_vals_grid = x_all(dd==0);
%   y_vals_grid = y_all(dd==0);
  
  
  %get u and v values
  u_vals = testlane.aero_mapping.u_vec(idx_aeromesh);
  v_vals = testlane.aero_mapping.v_vec(idx_aeromesh);
  
  %now interpolate to the wake uv values and return z i.e. we're
  %interpolating TO the wake, which means there shouldnt be any gaps.
  %(rather than interpolating TO the grid)
  z_wake = interp2(testwake.x,testwake.y,testwake.z,u_vals,v_vals,'nearest'); %but even in here, we have to cut away the ones with distance > 0.5
  
  
  %this z is in the index form of x_vals and y_vals (i.e. the interpolated-to values from the grid to the aeromesh)
  %. we need to make it into the index form of x_all and y_all i.e. the
  %grid.
  
  
  %now can use the consistent indexing scheme to map the z_wake onto the
  %grid
  
  height_tol = 6;
  dist_tol = 0;
  
   % scatter3(x_vals(dd<=dist_tol & z_wake<height_tol),y_vals(dd<=dist_tol & z_wake<height_tol),z_wake((dd<=dist_tol)&(z_wake<height_tol)));
  scatter3(x_all(dd<=dist_tol & z_wake<height_tol),y_all(dd<=dist_tol & z_wake<height_tol),z_wake(dd<=dist_tol & z_wake<height_tol));
    

% 
% % want to find lane point at this point
% % assuming testlane
% 
% input_val_u = interp2(Xsorted,Ysorted, Usorted,output_val_x,output_val_y,'nearest')
% input_val_v = interp2(testlane.aero_mapping.x,testlane.aero_mapping.y, testlane.aero_mapping.v,output_val_x,output_val_y,'nearest')
% 
% 
% 
% 
% input_idx_i = 1
% 
% input_idx_j = 5
% 
% inputu = testlane.aero_mapping.u(input_idx_i,input_idx_j); %range from 0-250
% inputv = testlane.aero_mapping.v(input_idx_i,input_idx_j); %range from -5 to 5
% outputx = testlane.aero_mapping.x(input_idx_i,input_idx_j); %range from -60 to 60
% outputy = testlane.aero_mapping.y(input_idx_i,input_idx_j); % range from -40 to 40
% 
% 
% 
% 
% output_value = interp2(testwake.x,testwake.y,testwake.z,inputu,inputv,'nearest');
% 
% ztest_velox(output_idx_x,output_idx_y) = output_value;
%     
% 
% % sweep across v, get z value and apply to xy(u0v-)
% 

%iterate u using indexes




%% get the corresponding input-coordinates (note this transformation is
%already done)

%use these input-coordinates to retrieve the z value from the wake image

%adjust the aerogrid z value