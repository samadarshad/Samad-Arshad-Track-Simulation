%Physio function: input: CP, AWC_max, AWC, AL, L,

function [AL,L,maxP_constrained] = M_M_PhysioModel(P,Pmax,AWC_max,AL,L,CP,dt)

%% Assumed constants/relationships valid for all cyclists (Billy Fitton used equations)
Mo = CP;
Ml = 1.1*CP;
Mr = CP/8;
lambda = 0.1;
phi = 0.05;
theta = 0.76;
ALratio = 0.32;
Lratio = 0.68;
H = 1;

%% Physio algorithm 

ALmax = ALratio*AWC_max;
Lmax = Lratio*AWC_max;
%check valid AL and L
if AL < 0;
    AL = 0;
end
if L < 0;
    L = 0;
end
if AL > ALmax
    AL = ALmax;
end


if L > Lmax
    L = Lmax;
end

ALmax = ALratio*AWC_max;
Lmax = Lratio*AWC_max;

l = (1-(L/Lmax))*(H-theta-lambda);
h = (1-(AL/ALmax))*(H);



if h > (l + theta)   %Deplete L
    
    if h < (H-phi) 
    AL = AL + (Mo*(h)/(H-phi) + Ml*((h-l-theta)/(H-theta-lambda)) - P)*dt ;
    L = L - (Ml*((h-l-theta)/(H-theta-lambda)))*dt;
    else %oxidative maximum power (Mo)
    AL = AL + (Mo + Ml*((h-l-theta)/(H-theta-lambda)) - P)*dt ;
    L = L - (Ml*((h-l-theta)/(H-theta-lambda)))*dt;    
     
        
    end
    
    
    if AL < 0;
        AL = 0;
    end
    if L < 0;
        L = 0;
    end
    if AL > ALmax
        AL = ALmax;
    end
    
    
    if L > Lmax
        L = Lmax;
    end
    
    
    
else                            %Replete L (amended for +Mr)
    if (l==0) %i.e. L tank is full
        AL = AL + (Mo*(h/(H-phi)) - P)*dt;
        L = L; %this should be the same as Lmax
    else
        AL = AL + (Mo*(h/(H-phi)) + +Mr*((h-l-theta)/(H-theta-lambda)) - P)*dt ;
        L = L - (+Mr*(h-l-theta)/(H-theta-lambda))*dt;
    end
    
    
    if AL < 0;
        AL = 0;
    end
    if L< 0;
        L = 0;
    end
    
    if AL > ALmax
        AL = ALmax;
    end
    
    
    if L > Lmax
        L = Lmax;
    end
end
l = (1-(L/Lmax))*(H-theta-lambda);
%h = (1-(AL/ALmax))*(H);
%disp([l h-(l + theta)])
maxP_constrained = Pmax * (H-theta-lambda-l)/(H - theta - lambda);


end





