%function to get lane a radius of curvature for each point

%to be used within lane_to_struct function
function radius_vec = get_rad_curv(lane)

%takes the current and previous position and norms to find the instant
%centre. perhaps a better one would be to take the next and previous
%positions (relative to current) to find the instant centre, but for
%simplicity lets do the former

m = lane.Length;
radius_vec = zeros(m,1);

for i = 1:m
    A = [lane.X(i) lane.Y(i)];
    Na = lane.vectors(i).n;
    
    if i == 1
     B = [lane.X(m) lane.Y(m)];   
     Nb = lane.vectors(m).n;
    else
    B = [lane.X(i-1) lane.Y(i-1)];
    Nb = lane.vectors(i-1).n;
    end
    
radius_vec(i) = get_radiustrack(A,B,Na,Nb);



end



end
