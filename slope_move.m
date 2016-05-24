%function for slope movement
%returns NAN if outside velo

function point3_next = slope_move(point3, dist, dir,MeshSt)

point3_next = point3;
dist_achieved = 0; %linear distance between the points in the time step
        
        step_me = dist*0.5;
        
       
        while abs(dist_achieved) < abs(dist) %problem might be here when dealing with positive/negaitve distance?
            %guess
            point3_next = point3 + step_me*dir; 
            %correction
            p_z = get_z(MeshSt,point3_next); %returns nan if invalid
            point3_next = [point3_next(:,1) point3_next(:,2) p_z];
            dist_achieved = point3_next - point3;
            dist_achieved = norm(dist_achieved);
            step_me = step_me+ dist*0.25;
        end
     
end