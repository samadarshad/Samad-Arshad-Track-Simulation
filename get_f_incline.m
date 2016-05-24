%function to get incline force
%incline in degrees
function f_incline = get_f_incline(mass,g,incline)

f_incline = mass * g * sind(incline);

end