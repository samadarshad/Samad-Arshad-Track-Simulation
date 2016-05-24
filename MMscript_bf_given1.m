%script to use billy's M-M model to plot the initial gradients


CP = 280;
MaxP = 976;

constant_power_time = 2000; %seconds
dt = 1;%second
store = zeros(length(SRM),constant_power_time-1);
SRM = [0:5:400];
hold on
constant_power_time= constant_power_time/2;

for i = 1:length(SRM)
    SRM_constant = [ones(constant_power_time,1)*SRM(i); zeros(constant_power_time,1)];
    
[AWC,E_profile,AL,L] = MandM(CP,MaxP,SRM_constant,dt);
plot(E_profile);
store(i,:) = E_profile;
end

legend(num2str(SRM'))


