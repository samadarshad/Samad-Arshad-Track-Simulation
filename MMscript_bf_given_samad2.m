%script to use billy's M-M model to plot the initial gradients


CP = 280;
MaxP = 976;

constant_power_time = 20000; %seconds
dt = 1;%second

SRM = 0:50:1000;
hold on

constant_power_time= constant_power_time/2; %test2 
for i = 1:length(SRM)
    SRM_constant = [ones(constant_power_time,1)*SRM(i); zeros(constant_power_time,1)];
    
%[AWC,E_profile,AL,L] = MandM(CP,MaxP,SRM_constant,dt);
[AWC,E_profile,AL,L] = MM_function_samad3(SRM_constant);

plot(E_profile);
end

legend(num2str(SRM'))