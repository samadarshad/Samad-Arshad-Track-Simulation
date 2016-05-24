%calibrating with wind data, test scripts
time2cropped = time2;
for i = 1:size(time2)
    time2cropped(i) =  cellstr(time2{i}(15:23));
end

vectorised_time2 = datevec(time2cropped);
 vectorised_seconds2 = zeros(size(time2));
for i = 1:size(time2)
    vectorised_seconds2(i) = (datenum(vectorised_time2(i,:)) - datenum(vectorised_time(1,:)))*60*60*24/60;
end

% cumudistance = cumtrapz(vectorised_seconds2,wheel_speed).*(1000/(60*60));
% 
% modcumudistance = mod(cumudistance,250);

relative_wind_speed = wind_speed - (wheel_speed .* 1000/3600);
smooth_wind = smooth_lane_1D(wind_speed,200);
smoothed_rel_wind = smooth_wind - (wheel_speed .* 1000/3600);
% smoothed_rel_wind = smooth_lane_1D(relative_wind_speed,150);

% hold on
% 
% plot(vectorised_seconds2,relative_wind_speed)
% plot(vectorised_seconds2,smoothed_rel_wind)