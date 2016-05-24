%returns Nan if outside the velodrome


function [next_pt, new_vel]  = move_pt(steer_in, vel,point3,VectsStruct, MeshSt,steer_angle)
new_vel = cell(1,length(vel)); %if a steering occurs, this nan is un'nan'ed and the outer function then has to re-do the drive
%for each player
next_pt = zeros(size(point3));

for k = 1:size(point3,1)
    
    if(steer_in(k))
        %slope then cx
        dir = VectsStruct.sl(k,:);
        if any(isnan(dir))
           % disp('on edge - no dx, (sl)-cx')
        end
        
        dist = vel{k}(2);
        point3_next = slope_move(point3(k,:), dist, dir,MeshSt);
        if any(isnan(point3_next))
            %steer in because its currently not enough - RISKY if at the
            %inner lane
            %disp('steer in - (sl)-cx');
            %guessing whether at inner lane or outer lane:
            in_flag = in_or_out(MeshSt,point3_next);
            
            if in_flag==true %then inner lane, and will need to steer out
                new_vel = vel;
                new_vel{k} = artif_steer_in(vel{k},-steer_angle);  
                return 
            elseif in_flag==false %at outerlane
            new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},steer_angle);
            return
            end
        end
        %cx
        dir = VectsStruct.cx(k,:);
        if any(isnan(dir))
            %disp('on edge - no dx, sl-(cx)')
        end
        dist = vel{k}(1);
        point3_next_cx = cx_move(point3_next, dist, dir,MeshSt);
        if any(isnan(point3_next_cx))
            %steer in because edge of contour, andcontour edges only occur
            %on outer edge
            %disp('steer in sl-(cx)');
            
            
            %guessing whether at inner lane or outer lane:
            if point3(k,3) < 1 %then inner lane, and will need to steer out
              new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},-steer_angle);  
               return 
            else
            
            new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},steer_angle);
            return
            end
        end
        
        next_pt(k,:) = point3_next_cx;
        
    else %steering out, ASSUMING at outer edge therefore do cx then sl
        
        %cx then slope
        %disp('cx-sl')
         %cx
        dir = VectsStruct.cx(k,:);
        if any(isnan(dir))
            %disp('on edge - no dx, (cx)-sl')
        end
        dist = vel{k}(1);
        point3_next = cx_move(point3(k,:), dist, dir,MeshSt);
        if any(isnan(point3_next))
            %steer in because edge of contour, andcontour edges only occur
            %on outer edge
            %disp('steer in (cx)-sl');
            %guessing whether at inner lane or outer lane:
            in_flag = in_or_out(MeshSt,point3);
            if point3(k,3) < 1 %then inner lane, and will need to steer out
              new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},-steer_angle);  
               return 
            else
            new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},steer_angle);
            return
            end
        end
        
        dir = VectsStruct.sl(k,:);
        if any(isnan(dir))
          %  disp('on edge - no dx, cx-(sl)')
        end
        dist = vel{k}(2);
        point3_next_sl = slope_move(point3_next, dist, dir,MeshSt);
        if any(isnan(point3_next_sl))
            %steer out
           % disp('steer in cx-(sl)'); %steer out or in??
           %guessing whether at inner lane or outer lane:
            if point3(k,3) < 1 %then inner lane, and will need to steer out
              new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},-steer_angle);  
               return 
            else
            new_vel = vel;
            new_vel{k} = artif_steer_in(vel{k},steer_angle);
            return
            end
        end
        
        next_pt(k,:) = point3_next_sl;
    end  
    
    
    
end





end
