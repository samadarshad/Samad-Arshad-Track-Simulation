%function to find instant centre of curvature for track based on rider
%position

%uses vector algebra to get radius by intersecting two normals

function radius_of_track = get_radiustrack(A,B,Na,Nb)

%checks for parallel lines
if cross([Na(1:2) 0],[Nb(1:2) 0]) == 0
    %collinear/parallel
    radius_of_track = nan; %infinity
    return
end


t = cross([(B - A) 0],[Nb(1:2) 0]) / cross([Na(1:2) 0],[Nb(1:2) 0]); %vector algebra part,
% http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
centre = A + t*Na(1:2);
radius_of_track = norm(centre - A); %assuming circular/curved
%tolerance 
tol = 50; %arbitrary tolerance for radius to cut out any larger radii
if radius_of_track>tol
    radius_of_track = nan;
end

end