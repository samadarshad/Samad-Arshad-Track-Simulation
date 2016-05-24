%wind script test 2

%smoothen wind
rel_wind = wind_speed - (wheel_speed .* 1000/3600);
smooth_wind = smooth_lane_1D(wind_speed,200);
smoothed_rel_wind = smooth_wind - (wheel_speed .* 1000/3600);
smooth_smooth_rel_wind = smooth_lane_1D(smoothed_rel_wind,200);
wheel_speed_ms = (wheel_speed .* 1000/3600);


%plotyy(secs1,smoothed_rel_wind,secs2,distance2)



plot(secs1,wheel_speed_ms,secs1,-smoothed_rel_wind)
% 
% %find delay
% [acor,lag] = xcorr(smoothed_rel_wind,wheel_speed);
% [acormax,I] = max(abs(acor))
% timeDiff = lag(I)
% lagDiff = timeDiff;
% 
% %aligning wind with wheel speed
% 
% wind_aligned = smoothed_rel_wind(1:lagDiff+end+1);
% wind_secs1_aligned = secs1(-lagDiff:end);
% 
% hold on
% plot(wind_secs1_aligned,-wind_aligned)


%finding correlation between wheel-speed and wind generated
%select the steady state region
%seconds
start_sec = 65;
end_sec = 300;

interval_st = find(abs(secs1-start_sec)<=0.01);
interval_en = find(abs(secs1-end_sec)<=0.01);

short_smoothed_rel_wind = smooth_smooth_rel_wind(interval_st:interval_en);
short_wheel = wheel_speed_ms(interval_st:interval_en);