%script to use billy's M-M model to plot the initial gradients


CP = 280;
MaxP = 976;

constant_power_time = 2000; %seconds
dt = 1;%second
store = zeros(length(SRM),constant_power_time);
store2 = zeros(length(SRM),constant_power_time-1); %store diff's
SRM = [0:40:400];
figure
hold on
constant_power_time= constant_power_time/2;

for i = 1:length(SRM)
    SRM_constant = [ones(constant_power_time,1)*SRM(i); zeros(constant_power_time,1)];
    
[AWC,E_profile,AL,L,E_profile2] = MandM(CP,MaxP,SRM_constant,dt);
 plot(E_profile);
store(i,:) = E_profile;
store2(i,:) = E_profile2;
end







% legend(num2str(SRM'))
% 
% time_slope = [1 50:50:1000];
% figure
% hold on
% for i = 1:length(time_slope)
%  plot(SRM,store(:,time_slope(i)))
% end
%  legend(num2str(time_slope'))
 
 %plot how the critical power changes with time
%  
%  for i = 1:length(time_slope)
%  zero_power(i) = crossing(store(:,time_slope(i)));
%  end
% figure
%  plot(time_slope(1:length(zero_power)),zero_power*5)
% 
% 
%  for i = 1:length(time_slope)
%  zero_AWC(i) = store(zero_power(i),time_slope(i));
%  end
% figure

%  scatter(zero_AWC,zero_power*5)


figure
hold on
for i = 1:4:length(SRM)

plot(store(i,1:999),store2(i,1:999))

end

legend(num2str(SRM(1:4:end)'))