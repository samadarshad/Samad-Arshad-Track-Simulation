%script setting initial point and getting it to move
[MeshSt, VectsStruct] = MeshStruct
contour(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat)
axis square
hold on

%point = [-28.38 30.6; -28 0]
%point = [-24 18; -28 0]
point = [-25 14; -30 0];
%point = [-24.38 0; -28 0];
velocity = {[10*ones(1,100); -0*ones(1,100)], [10*ones(1,100); 0*ones(1,100)] };


for i = 1:100
    
p_z = get_z(MeshSt,point(:,1:2));
point3 = [point(:,1:2) p_z];
point_plot(point3);
VectsStruct = get_vects(MeshSt,point3);
vel = get_velo(i,velocity);

good_traverse_flag = false;
steer_angle=0.5;
sl_first = get_steer_in(vel);
while ~good_traverse_flag
    

    %[next_pt, new_vel, sl_first_changed]  = move_pt_bckp(sl_first,vel, point3,VectsStruct, MeshSt,steer_angle);
    [next_pt, new_vel]  = move_pt_bckp(sl_first,vel, point3,VectsStruct, MeshSt,steer_angle);
    
    if any(~cellfun(@isempty,new_vel)) %steering
        %redo with new vel
        %disp('redo')
        vel = new_vel;
       % sl_first = get_steer_in(vel);
        
    %elseif ~isnan(sl_first_changed) %inner/outer lane
        %sl_first = sl_first_changed;
    else
        good_traverse_flag = true;
    end
    
end


hold off
point_plot(next_pt)
hold on
contour(MeshSt.x_vec,MeshSt.y_vec,MeshSt.new_z_mat)
axis square
view([0 0 1]);
pause(0.4);
point = next_pt;
end