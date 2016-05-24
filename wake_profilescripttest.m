%script for velocity profile



U_inf = 10;
U_centre = 9;
momentum_width = 1; %not quite, but for illustrative its ok
A = 0.049;
B = 0.128;
C = 0.345;
D = 0.134;

r = 0:0.1:10;


r_mom_width = r./momentum_width;
%U_r(r) = U_inf - ( (U_inf - U_centre)*(1 + A*r_mom_width^2 + B*r_mom_width^4)*exp( -C*r_mom_width^2 -D*r_mom_width^4));
U_r = ( (U_inf - U_centre)*(1 + A*r_mom_width.^2 + B*r_mom_width.^4).*exp( -C*r_mom_width.^2 -D*r_mom_width.^4));



plot(r,U_r);



hold on
%laminar
U_r2 = exp(-r.^2);


plot(r,U_r2);