%function to get inclincation angle (degrees)

%position is a 2x3 vector with 2 points of before and after
function incline = get_incline(position)
vec = position(2,:) - position(1,:);

flat_vec = [vec(1:2) 0];

%angle between flat_vec and vec
%using tan method to perserve sign
dH = vec(3);
dist = norm(vec);

angle = atan2d(dH,dist);

incline = angle;




end