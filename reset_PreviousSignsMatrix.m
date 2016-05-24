%function to reset/recalculate the signs matrix


function Collisions = reset_PreviousSignsMatrix(riders,num_players,lanes,Collisions,i)

 % check collisions here
    for k = 1:num_players
        for j  = 1:num_players
            %if riders are on the same lane
            if riders(k).lane(i) == riders(j).lane(i)
                %take the minimum distance
                Collisions.mindistances(k,j) = riders(k).lane_idx - riders(j).lane_idx; %notice notation convention (i,j) = i - j
                Collisions.mindistances250(k,j) = (riders(k).lane_idx + lanes(riders(k).lane(i)).Length) - riders(j).lane_idx;
                
            else
                Collisions.mindistances(k,j) = nan;
                Collisions.mindistances250(k,j) = nan;
            end
            %else set distance to nan/0
        end
    end
    
 
        Collisions.MinDistancesFlag = abs(Collisions.mindistances) >  abs(Collisions.mindistances250); %this stores hwhether the minimum is taken by 250m difference. we need to use the same convention for our next time step
        %now store only the distances below 125m in the filtered distances.
        Collisions.mindistancesboth = Collisions.mindistances.*(1-Collisions.MinDistancesFlag) + Collisions.mindistances250.*(Collisions.MinDistancesFlag);
        Collisions.FilteredDistances = (Collisions.mindistancesboth -Collisions.ThreshMat).*(abs(Collisions.mindistancesboth) < 290); %corrected for thresholds. 588(lane length)/2
        Collisions.PreviousSignsMat = sign(Collisions.FilteredDistances ); %THIS is the signs matrix we want to compare each time step. We need information about whether the 250m was used or not aswell.
        if any(any(ismember(Collisions.PreviousSignsMat,0)))
            %fprintf('0 sign');
            %force the '0' to be the opposite of its transpose
            trans_previous_signs = transpose(Collisions.PreviousSignsMat);
            idx = find(Collisions.PreviousSignsMat==0);
            Collisions.PreviousSignsMat(idx) = -trans_previous_signs(idx);
        end
end