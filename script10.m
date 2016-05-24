%script 10 multiple riders




%get starting position on the blue lane (to see max height change etc)

point = [-25 14; -25 14]; %guessed starting point - will be corrected to go onto lane

velocity = [10*ones(1,100); 10*ones(1,100)];

%interpolate to find point on lane
blue = lane_to_struct(sm_blue_lane)
red = lane_to_struct(sm_red_lane)


idx_nearest(1) = dsearchn([blue.X blue.Y],point(1,:));


idx_nearest(2) = dsearchn([red.X red.Y],point(2,:));
point_on_lane =  [blue.X(idx_nearest(1)) blue.Y(idx_nearest(1)) blue.Z(idx_nearest(1));
    red.X(idx_nearest(2)) red.Y(idx_nearest(2)) red.Z(idx_nearest(2))]';%
point_plot(point_on_lane', ['bo'; 'ro'])



%% advance along lane at velocity distance
%starting steer vector
VectsStruct = get_vects(MeshSt,point_on_lane');
contour_vector = VectsStruct.cx;

% next point properties
next_idx = idx_nearest;
players = 2;
steps = 100;

height_vec = zeros(steps,players);
bank_angle =  zeros(steps,players);
steer_angle =  zeros(steps,players);
multi_plot = figure(1)
test_h = subplot(3,2,1)
test_b = subplot(3,2,3)
test_s = subplot(3,2,5)
test_3d = subplot(3,2,[2 4 6])

subplot(test_h)
test_h_pl1 = plot(height_vec(:,1));
hold on
test_h_pl2 = plot(height_vec(:,2));
title('Height from base (meters)')
set(test_h_pl1,'YData',height_vec(:,1));
set(test_h_pl2,'YData',height_vec(:,2));


subplot(test_b)
test_b_pl1 = plot(bank_angle(:,1));
hold on
test_b_pl2 = plot(bank_angle(:,2));
title('Bank Angle (degrees)')
set(test_b_pl1,'YData',bank_angle(:,1));
set(test_b_pl2,'YData',bank_angle(:,2));


subplot(test_s)
test_s_pl1 = plot(steer_angle(:,1));
hold on
test_s_pl2 = plot(steer_angle(:,2));
title('Steer Angle (degrees)')
set(test_s_pl1,'YData',steer_angle(:,1));
set(test_s_pl2,'YData',steer_angle(:,2));


subplot(test_3d)
hPlot = plot3(NaN,NaN,NaN,'bo');
hold on;
plot_lane(sm_black_lane,'Color','black')
plot_lane(sm_blue_lane,'Color','blue')
plot_lane(sm_red_lane,'Color','red')
plot3(base.X,base.Y,base.Level*ones(size(base.X)),'Color',[165 42 42]./255)

for i=1:100
next_idx = mod([next_idx(1) + 10 next_idx(2) + 10],[blue.Length red.Length]);
if next_idx(1)==0
    next_idx(1)=blue.Length;
end
if next_idx(2)==0
    next_idx(2)=red.Length;
end

next_pt =[blue.X(next_idx(1)) blue.Y(next_idx(1)) blue.Z(next_idx(1));
    red.X(next_idx(2)) red.Y(next_idx(2)) red.Z(next_idx(2))]; 
height_vec(i,:) = next_pt(:,3);
VectsStruct = get_vects(MeshSt,next_pt);
flat_vec = [VectsStruct.sl(:,1:2) zeros(2,1)]; %relative to z=0
bank_angle(i,:) = atan2(norm(cross(VectsStruct.sl',flat_vec')),dot(VectsStruct.sl',flat_vec'));
bank_angle(i,:) = 180/pi * bank_angle(i,:);
%steer angle as relative angle between previous contour direction and
%current one
contour_vector_next = VectsStruct.cx;
steer_angle(i,:) = atan2(norm(cross(contour_vector_next',contour_vector')),dot(contour_vector_next',contour_vector'));
steer_angle(i,:) = 180/pi * steer_angle(i,:);

% point_plot(next_pt)
subplot(test_3d)
set(hPlot,'XData',next_pt(:,1),'YData',next_pt(:,2),'ZData',next_pt(:,3)); 
contour_vector = contour_vector_next;
% refreshdata(test_h_pl)
% refreshdata(test_b_pl)
% refreshdata(test_s_pl)
% refreshdata
set(test_h_pl1,'YData',height_vec(:,1));
set(test_h_pl2,'YData',height_vec(:,2));

set(test_b_pl1,'YData',bank_angle(:,1));
set(test_b_pl2,'YData',bank_angle(:,2));

set(test_s_pl1,'YData',steer_angle(:,1));
set(test_s_pl2,'YData',steer_angle(:,2));

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


