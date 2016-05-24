%bluff body shape, to be added on and rotated in the direction of travel


function Bluff = get_bluff()
%need minimum resolution of 0.5m

%taking a circle bluff body of one point
%construct bluff body centred on 0,0 - this will mean there will be
%negative indexes

Bluff.centre = [0 0]; %indicates the position of the rider relative to the bluff coordinates
 %indicates direction of cyclist travelling
% %single point bluff
% Bluff.values = [1];
% Bluff.x = [0];
% Bluff.y = [0];

%5x5 bluff 0.5m spacing
%Bluff.direction = [1 0];
% Bluff.values = [0.9 0.9 0.9 0.9 0.9; 
%                 0.9 0.8 0.8 0.8 0.9; 
%                 0.9 0.8 0.6 0.8 0.9
%                 0.9 0.8 0.8 0.8 0.9
%                 0.9 0.9 0.9 0.9 0.9];
% [Bluff.x, Bluff.y] = meshgrid(-1:0.5:1,-1:0.5:1);


% Bluff.direction = [0 1];
% Bluff.values = [0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9;
%                 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9];
% [Bluff.x, Bluff.y] = meshgrid(-0.5:0.5:0.5,-17:0.5:0); %i.e. y-values are negative only, as centre is on 0,0



% Bluff.direction = [0 1];
% Bluff.values = [0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 
%                               
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9; 
%                 0.9 0.1 0.9;
%                 0.9 0.1 0.9];
% [Bluff.x, Bluff.y] = meshgrid(-0.5:0.5:0.5,-7:0.5:0); 


% a more plumey bluff
Bluff.direction = [0 1];
Bluff.centre_co = 0.1; %the central 'coefficient' of the bluff
Bluff.values = [0.5 0.3 0.1 0.3 0.5; 
                0.5 0.3 0.1 0.3 0.5;
                0.5 0.3 0.1 0.3 0.5;
                0.5 0.3 0.1 0.3 0.5;
                0.5 0.3 0.1 0.3 0.5;
                
                0.7 0.5 0.3 0.5 0.7;
                0.7 0.5 0.3 0.5 0.7;
                0.7 0.5 0.3 0.5 0.7;
                0.7 0.5 0.3 0.5 0.7;
                0.7 0.5 0.3 0.5 0.7;
                
                              
                0.9 0.7 0.5 0.7 0.9;
                0.9 0.7 0.5 0.7 0.9;
                0.9 0.7 0.5 0.7 0.9;
                0.9 0.7 0.5 0.7 0.9;
                0.9 0.7 0.5 0.7 0.9;
                ];
[Bluff.x, Bluff.y] = meshgrid(-1:0.5:1,0:-0.5:-7); 






% error check that the number of bluff values is the same as the bluff x
% and y
if size(Bluff.values(:),1) ~= size(Bluff.x(:),1) || size(Bluff.values(:),1) ~= size(Bluff.y(:),1)
    disp('Bluff size error');
end


end