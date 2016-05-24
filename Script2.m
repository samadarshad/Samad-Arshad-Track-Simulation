%% NO lane velocity - just like scalatrix - lane switch by contours, nearest contour

%do a lane switch every 5 seconds
contour(x_vec,y_vec,new_z_mat)
axis square
% get a point to travel 300 meters along contour v = 0.2
cont =2; %only 2-5 works, other contours are broken
pos = 1;
[~,c_size] = size(new_s(cont).x);
point = [new_s(cont).x(pos) new_s(cont).y(pos) ]
hold on;
 hPlot = plot(NaN,NaN,'ro');
 set(hPlot,'XData',point(1),'YData',point(2));
 distance_trav = 0;
  
 xlim([-30 30]);
 ylim([-50 50]);
 
 velocity = 40;
 time_step = 0.05;
 dist_per_step = velocity*time_step;
 dist_needed = dist_per_step;
 velo_reached =0;
 mini_time_st = 1;
 time_trav = 0;
 tic;
 lane_clock = tic;
 
 vertical_vec = [0 0 1];
 while ~velo_reached
     
     
         
     pos = mod(mini_time_st,c_size);
     if pos == 0
         pos = 1
     end
     old_pt = point;
     
     point = [new_s(cont).x(pos) new_s(cont).y(pos) ];   
     
     lane_toc = toc(lane_clock);
     if lane_toc > 5
         
        point_dx = interp2(x_vec,y_vec,Fx,point(1),point(2),'nearest');
        point_dy = interp2(x_vec,y_vec,Fy,point(1),point(2),'nearest');
        point_dz = (point_dx^2+point_dy^2);
        sl_vec = [point_dx, point_dy, point_dz];
        
        height_difference = new_s(cont+1).v - new_s(cont).v; 
        angle_difference = dot(vertical_vec,sl_vec)/norm(sl_vec); %cos theta
        dist_diff = height_difference/angle_difference;
        point = point + (dist_diff)*[sl_vec(1) sl_vec(2)];
        cont = cont+1;
        % find new 'pos' across the contour
       disp('test')
        %new_point_in_new_cont(1) = interp2(new_s(cont).x,new_s(cont).y,new_s(cont).x,point(1),point(2),'nearest')
        %new_point_in_new_cont(1) = interp1(new_s(cont).x,new_s(cont).x,point(1));
        pos = dsearchn([new_s(cont).x' new_s(cont).y'],[point(1) point(2)])
        mini_time_st = pos;
        point = [new_s(cont).x(pos) new_s(cont).y(pos) ];
         lane_clock = tic; 
     end
     
     
     distance_trav = distance_trav+norm(point-old_pt);
     if distance_trav >=dist_needed
         if toc <= time_step %update only every -timestep- seconds
             pause(time_step-toc)
           end
          set(hPlot,'XData',point(1),'YData',point(2));
         % velo_reached = true
           drawnow
           dist_needed = dist_needed+ dist_per_step;
           tic
     else 
         mini_time_st = mini_time_st +1;
         
     end
    % pause(0.01)
     % update the plot graphics object with the next position
%      set(hPlot,'XData',point(1),'YData',point(2));
    
     % pause for 0.5 seconds
      %pause(0.001)
 end
