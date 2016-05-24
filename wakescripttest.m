%script for empirical far-wake calculation
clear all

u_inf = 10; %m/s
momentum_thickness = 0.1; %m -< not sure what momentum thickness to choose
%can be dependant on rider area.
%momentum thickness can be calculated: when multiplied by u_inf^2, should
%equal the integral of the momentum deficiet across the boundary layer - it
%is the sum drag on the cyclist?

virtual_origin = -2.4*momentum_thickness;
a = 1.14;%scaling of half width to distance
b = 0.77; %scaling of peak velocity defciet with distance



%not quite, but for illustrative its ok
A = 0.049;
B = 0.128;
C = 0.345;
D = 0.134;

r = 0:0.1:10;


x = 1:100;


half_width = a*(x-virtual_origin).^(1/3)*momentum_thickness^(2/3);
centre_deficiet = b*u_inf*((x-virtual_origin)./momentum_thickness).^(-2/3);
velo_centre = u_inf - centre_deficiet;

r_mom_width = zeros(length(x),length(r));
U_r = zeros(length(x),length(r));
for i = 1:length(x)
r_mom_width(i,:) = r./half_width(i);
%U_r(r) = U_inf - ( (U_inf - U_centre)*(1 + A*r_mom_width^2 + B*r_mom_width^4)*exp( -C*r_mom_width^2 -D*r_mom_width^4));
U_r(i,:) = u_inf - ( (u_inf - velo_centre(i))*(1 + A*r_mom_width(i,:).^2 + B*r_mom_width(i,:).^4).*exp( -C*r_mom_width(i,:).^2 -D*r_mom_width(i,:).^4));
end

% 
% x = [1:10];
figure(1)
hold off
plot(x,half_width);

hold on;

plot(x,centre_deficiet);


figure(2)
hold off
g = surf(x,r,U_r')
set(g,'edgecolor','none')