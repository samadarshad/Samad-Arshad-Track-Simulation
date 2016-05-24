%function to get necessary steer angle, eqn 33 of Billy Finton report

%inputs from existing variables - incline angle (degrees), bank angle (degrees), Pcontact,
%velocity_wheel,

%inputs from new variables - a, b, rake angle (bike geometry and COM)


%calculated variables - rear tyre coefficient, X, normal velocity,
%tangential velocity, delta

%outputs: delta - necessary steer angle



function delta = get_necessary_steer(incline,bank,velo_wheel,R_to_wheel)

l = 1; %wheelbase l = a + b. Taken as 1m because average from http://www.ribblecycles.co.uk/blog/choosing-correct-size-road-bike-geometry-explained/ 
b = 0.6; %guessing front-centre to be 60cm
a = l-b;

rake = 20;
Ca = 0.267;
Cy = 0.02;
R_wheels = 0.67/2;

angular_velo = velo_wheel/R_to_wheel; %eqn 49

gamma_2 = incline; %eqn 27
alpha_2 = (tand(incline) - gamma_2*Cy)/Ca; %eqn 25

%X = asind( (b * cosd(bank)/R_wheels)/sqrt((alpha_2^2) + 1)) - atand(alpha_2); %eqn 32
X = asind( (b * cosd(bank)/R_to_wheel)/sqrt((alpha_2^2) + 1)) - atand(alpha_2); %eqn 32
u_n = velo_wheel*sind(X);
u_t = velo_wheel*cosd(X);

%solving eqn 33 for delta
delta = (l*angular_velo*cosd(bank)/u_t) / (cosd(rake)*(1 + (Cy*tand(rake)/Ca)));
delta = delta * 180/pi;

end
