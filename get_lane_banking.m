


function banking_lookup = get_lane_banking(lane)

for i = lane.Length:-1:1
    
    vert_vec = [0 0 1]; %relative to z=0
    slope_vec = lane.vectors.sl(i,:);
%// angle between plane and line, equals pi/2 - angle between slope_vec and N
alpha = abs( pi/2 - acos( dot(slope_vec, vert_vec)/norm(vert_vec)/norm(slope_vec) ) );

%// in degrees: 
alpha = alpha * 180/pi;

    banking_lookup(i) = alpha;
    
end

banking_lookup= banking_lookup(:);





end