%function gives high resolution wake that can be quickly referenced for u-v
%position, rather than having to compute u-v position for each cell in the
%x-y mesh. This should be faster. 
%wake velocities caused by cyclist travelling at 10m/s

%note that v is symmetrical

%inputs for narargin are a and b values - which scale the height and width
%of the wake

%Reference of far-field wake goes to: Johansson paper
function highreswake = make_wake(varargin)
if ~isempty(varargin)
    a = varargin(1);
    b = varargin(2);
else
%     a = 1.14;%scaling of half width to distance
%     b = 0.77; %scaling of peak velocity defciet with distance

%OPTIMISED TO CdA FILD
   a = 0.93;%scaling of half width to distance
   b = 1.05; %scaling of peak velocity defciet with distance
end
%resolution
r = 0:0.1:5;
x = 0:0.5:300;
%script for empirical far-wake calculation


u_inf = 10; %m/s - constant scaling factor of wake magnitude - this MUST be updated in the main function too
momentum_thickness = 0.5; %m -< not sure what momentum thickness to choose
%can be dependant on rider area.
%momentum thickness can be calculated: when multiplied by u_inf^2, should
%equal the integral of the momentum deficiet across the boundary layer - it
%is the sum drag on the cyclist?

virtual_origin = -2.4*momentum_thickness;





A = 0.049;
B = 0.128;
C = 0.345;
D = 0.134;




half_width = a*(x-virtual_origin).^(1/3)*momentum_thickness^(2/3);
centre_deficiet = b*u_inf*((x-virtual_origin)./momentum_thickness).^(-2/3);
velo_centre = u_inf - centre_deficiet;

r_mom_width = zeros(length(x),length(r));
U_r = zeros(length(x),length(r));
for i = 1:length(x)
r_mom_width(i,:) = r./half_width(i);
%U_r(r) = U_inf - ( (U_inf - U_centre)*(1 + A*r_mom_width^2 + B*r_mom_width^4)*exp( -C*r_mom_width^2 -D*r_mom_width^4));
%U_r(i,:) = u_inf - ( (u_inf - velo_centre(i))*(1 + A*r_mom_width(i,:).^2 + B*r_mom_width(i,:).^4).*exp( -C*r_mom_width(i,:).^2 -D*r_mom_width(i,:).^4));
U_r(i,:) = ( (u_inf - velo_centre(i))*(1 + A*r_mom_width(i,:).^2 + B*r_mom_width(i,:).^4).*exp( -C*r_mom_width(i,:).^2 -D*r_mom_width(i,:).^4));

end

% 
% x = [1:10];
% figure(1)
% hold off
% plot(x,half_width);
% 
% hold on;
% 
% plot(x,centre_deficiet);
% 
% 
% figure(2)
% hold off
% g = surf(x,r,U_r')
% %axis equal
% set(g,'edgecolor','none')

highreswake.velo = U_r;
highreswake.u = x;
highreswake.v = r;

[highreswake.u_mat, highreswake.v_mat] = meshgrid(highreswake.u,highreswake.v);
highreswake.gi = griddedInterpolant(highreswake.u_mat',highreswake.v_mat',highreswake.velo,'nearest');

end