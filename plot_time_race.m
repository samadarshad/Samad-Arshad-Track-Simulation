figure(2)
hold on
plot3(riders(1).position(:,1),riders(1).position(:,2),riders(1).position(:,3),'Color','red')
axis equal
dt = 0.1;
%markers every 2 seconds?
every_secs = 2;
%until 25 seconds?
up_to_time = 26.5;


%copy and paste the below line onto the command window the find the single
%index which represents the cyclist at the 'bottom' of the velodrome again
find(riders(1).position(:,2)<=-49.1) %i.e. the rider started at the bottom, I am trying to find the next point in time when they reached this place (i.e. the time for a lap)
%VVV then update the 'end data point' with the number above

end_data_point = 256;%find(time_var==up_to_time);

datapoints = [1:every_secs/dt:end_data_point end_data_point]; %length(riders(1).position(:,1))
xmarkers = riders(1).position(datapoints,1);
ymarkers = riders(1).position(datapoints,2);
zmarkers = riders(1).position(datapoints,3);

hold on
text(xmarkers,ymarkers,zmarkers,num2str([datapoints.*dt - dt]'),'Color','red')
 
 
 
 
 %ramped lane:  lane_ramp = stepped_ramp(4.9,2,1,0.1)