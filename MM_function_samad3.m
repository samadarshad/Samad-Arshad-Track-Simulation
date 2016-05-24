%script to test the M-M model

%numbers from Billy's report
%equations from Comparing bioenergetic models for the optimisation of pacing
%strategy in road cycling
function [AWC,W,AL,L] = MM_function_samad(P)


AWC = 0; %dummy returns

CP = 280;

ALmax = 9600;
Lmax = 2.125*ALmax;
Mo = CP;
Mp = 976;

Ml = 1.1*CP;
Mr = CP/8;

lambda = 0.1;
phi = 0.05;
theta = 0.76;
H=1;

dt = 1;
tmax = length(P);







AL = zeros(tmax,1);
L = zeros(tmax,1);
h = zeros(tmax,1);
l = zeros(tmax,1);
Pm = zeros(tmax,1);





i=1;
AL(i) = ALmax;
L(i) = Lmax;
h(i) = 0;
l(i) = 0;
Pm(i) = Mp;

for i = 2:dt:tmax
    
if h(i-1) > l(i-1) + theta    %then we depelete L
    
   AL(i) = AL(i-1) + ( Mo*h(i-1)/(H-phi) + Ml*(h(i-1) - l(i-1) - theta)/(H - theta - lambda) - P(i))*dt;
   L(i) = L(i-1) - (Ml*(h(i-1) - l(i-1) - theta)/(H - theta - lambda))*dt;
else                            %then we replete L
   AL(i) = AL(i-1) + ( Mo*h(i-1)/(H-phi) + +Mr*(h(i-1) - l(i-1) - theta)/(H - theta - lambda)  - P(i))*dt;
   L(i) = L(i-1) - (+Mr*(h(i-1) - l(i-1) - theta)/(H - theta - lambda))*dt; 
end
    if AL(i) < 0
        AL(i) = 0;
    end 
    if AL(i) > ALmax
        AL(i) = ALmax;
    end
    
    if L(i) < 0
        L(i) = 0;
    end 
    if L(i) > Lmax
        L(i) = Lmax;
    end
    

    h(i) = get_h_MM(AL(i),ALmax,H);
    l(i) = get_l_MM(L(i),Lmax,H,theta,lambda);

    Pm(i) = Mp * (H-theta-lambda-l(i))/(H - theta - lambda);
    
    if P(i) < 0
        P(i) = 0;
    end 
    if P(i) > Pm(i)
        P(i) = Pm(i);
    end
    
    
end

%W = L + AL;
W = l;

end



