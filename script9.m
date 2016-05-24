%script 9

%getting cyclist to travel along a lane

%get starting position on the blue lane (to see max height change etc)

point = [-25 14]; %guessed starting point - will be corrected to go onto lane

velocity = 10*ones(1,100);

%interpolate to find point on lane
blue = lane_to_struct(sm_blue_lane)
idx_nearest = dsearchn([blue.X blue.Y],point);
point_on_lane =  [blue.X(idx_nearest); blue.Y(idx_nearest); blue.Z(idx_nearest)];%
point_plot(point_on_lane')

%% advance along lane at velocity distance
%starting steer vector
VectsStruct = get_vects(MeshSt,point_on_lane');
contour_vector = VectsStruct.cx;

% next point properties
next_idx = idx_nearest;

height_vec = zeros(100,1);
bank_angle =  zeros(100,1);
steer_angle =  zeros(100,1);
multi_plot = figure(1)
test_h = subplot(3,2,1)
test_b = subplot(3,2,3)
test_s = subplot(3,2,5)
test_3d = subplot(3,2,[2 4 6])
subplot(test_h)
test_h_pl = plot(height_vec);
title('Height from base (meters)')
set(test_h_pl,'YDataSource','height_vec');

subplot(test_b)
test_b_pl = plot(bank_angle);
title('Bank Angle (degrees)')
set(test_b_pl,'YDataSource','bank_angle');


subplot(test_s)
test_s_pl = plot(steer_angle);
title('Steer Angle (degrees)')
set(test_s_pl,'YDataSource','steer_angle');
subplot(test_3d)
hPlot = plot3(NaN,NaN,NaN,'bo');
hold on;
plot_lane(sm_black_lane,'Color','black')
plot_lane(sm_blue_lane,'Color','blue')
plot_lane(sm_red_lane,'Color','red')
plot3(base.X,base.Y,base.Level*ones(size(base.X)),'Color',[165 42 42]./255)

for i=1:100
next_idx = mod(next_idx + 10,blue.Length);
if next_idx==0
    next_idx=blue.Length;
end

next_pt =[blue.X(next_idx); blue.Y(next_idx); blue.Z(next_idx)]; 
height_vec(i) = blue.Z(next_idx);
VectsStruct = get_vects(MeshSt,next_pt');
flat_vec = [VectsStruct.sl(1:2) 0]; %relative to z=0
bank_angle(i) = atan2(norm(cross(VectsStruct.sl',flat_vec')),dot(VectsStruct.sl',flat_vec'));
bank_angle(i) = 180/pi * bank_angle(i);
%steer angle as relative angle between previous contour direction and
%current one
contour_vector_next = VectsStruct.cx;
steer_angle(i) = atan2(norm(cross(contour_vector_next',contour_vector')),dot(contour_vector_next',contour_vector'));
steer_angle(i) = 180/pi * steer_angle(i);

% point_plot(next_pt)
subplot(test_3d)
set(hPlot,'XData',next_pt(1),'YData',next_pt(2),'ZData',next_pt(3)); 
contour_vector = contour_vector_next;
refreshdata(test_h)
refreshdata(test_b)
refreshdata(test_s)
% refreshdata
drawnow
pause(0.1)

end

%% plot cyclist height, banking, steer

% at each step find the height, slope vector as angle to horizontal, steer
% as contour angle relative to previous contour angle




%get banking angle
%get normal
%get horizontal
%get angle between vectors


