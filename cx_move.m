%function for cx movement
%returns NAN if outside velo

function point3_next = cx_move(point3, dist, dir,MeshSt)
 dist_achieved = 0; 
 step_me = dist*0.5;
 point_on_cx = zeros(2,3);
while dist_achieved <= dist %assuming always positive
    
            % move in guessed directon 
             point3_next = point3 + step_me*dir; %holding z
             point_on_cx(1,:) = reset_to_cx(MeshSt, point3, point3_next); %sticking to contour line
             dist_achieved = norm(point_on_cx(1,:) - point3);
             step_me = step_me + dist*0.25; %increase step size to reach velo distance
             if point_on_cx(1,:)==point_on_cx(2,:)
                % disp('edge of contour')
                 point3_next = nan;
             return
             end
             point_on_cx(2,:) = point_on_cx(1,:);
             
end
point3_next = point_on_cx(1,:);


end