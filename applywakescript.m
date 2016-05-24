load('WakeMat.mat')

%choose lane 3 as our lane

%choose player at idx = 0, so u = u (+0) no offset

%forward mapping - choosing points on wake and finding the corresponding
%grid index
%% for each pixel in the aero
ztest_velox = zeros(size(MeshSt.z_mat));
gtest.x_vec = MeshSt.x_vec;
gtest.y_vec = MeshSt.y_vec;
[gtest.index_x, gtest.index_y] = meshgrid(1:size(AeroGrid.z_mat,2),1:size(AeroGrid.z_mat,1)); %just stealing from aerogrid
testlane = lanes(3);
testwake.x = Wx;
testwake.y = Wy;
testwake.z = Wzg;
% start at lane uv 00
for input_idx_i = 1:588

    for input_idx_j = 1:9

inputu = testlane.aero_mapping.u(input_idx_i,input_idx_j); %range from 0-250
inputv = testlane.aero_mapping.v(input_idx_i,input_idx_j); %range from -5 to 5
outputx = testlane.aero_mapping.x(input_idx_i,input_idx_j); %range from -60 to 60
outputy = testlane.aero_mapping.y(input_idx_i,input_idx_j); % range from -40 to 40


% get z value (by interpolation just in case teh uv are not compatible with the wake uv, which they arent i.e. as the spacing isnt 0.5m perfect)
% and apply to lane xy(uv 00)

output_idx_x = interp2(gtest.x_vec,gtest.y_vec, gtest.index_x,outputx,outputy,'nearest');
output_idx_y = interp2(gtest.x_vec,gtest.y_vec, gtest.index_y,outputx,outputy,'nearest');
output_value = interp2(testwake.x,testwake.y,testwake.z,inputu,inputv,'nearest');

ztest_velox(output_idx_x,output_idx_y) = output_value;
    end
end
% sweep across v, get z value and apply to xy(u0v-)


%iterate u using indexes




%% get the corresponding input-coordinates (note this transformation is
%already done)

%use these input-coordinates to retrieve the z value from the wake image

%adjust the aerogrid z value