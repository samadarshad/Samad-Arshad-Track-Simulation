function meanR = radiusCurvature_modified(L_x, L_y)
%modified for circular vectors and getting R for each point

%tolerance for radii
tol = 100;


m = length(L_x);
meanR = zeros(m,1);
% the function computes the mean radius of curvature for a given set of x-y coordinates
% credit for these algorithms should be given to Roger Stafford, who posted
% these algorithms on the MATLAB newsreader:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/152405  
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/294297#796465

% make sure that x and y are column vectors
x = L_x(:);
y = L_y(:);

for i = 1:m
  
    if i == m-1
        %take circular at end
    x21   = x(i+1) - x(i); 
    y21   = y(i+1) - y(i);
    x31   = x(1) - x(i); 
    y31   = y(1) - y(i);
    h21   = x21^2 + y21^2; 
    h31   = x31^2 + y31^2;
    d     = 2*(x21*y31-x31*y21);
    meanR(m) = sqrt(h21*h31*((x(1) - x(i+1))^2 + (y(1) - y(i+1))^2)) / abs(d);   
    if meanR(m) > tol
        meanR(m) = 100;
    end
    
    elseif i == m
           %take circular at end
    x21   = x(1) - x(i); 
    y21   = y(1) - y(i);
    x31   = x(2) - x(i); 
    y31   = y(2) - y(i);
    h21   = x21^2 + y21^2; 
    h31   = x31^2 + y31^2;
    d     = 2*(x21*y31-x31*y21);
    meanR(1) = sqrt(h21*h31*((x(2) - x(1))^2 + (y(2) - y(1))^2)) / abs(d); 
    if meanR(1) > tol
        meanR(1) = nan;
    end
    else
    x21   = x(i+1) - x(i); 
    y21   = y(i+1) - y(i);
    x31   = x(i+2) - x(i); 
    y31   = y(i+2) - y(i);
    h21   = x21^2 + y21^2; 
    h31   = x31^2 + y31^2;
    d     = 2*(x21*y31-x31*y21);
    meanR(i+1) = sqrt(h21*h31*((x(i+2) - x(i+1))^2 + (y(i+2) - y(i+1))^2)) / abs(d);
    if meanR(i+1) > tol
        meanR(i+1) = nan;
    end
    end
    
end
    
end % function radiusCurvature