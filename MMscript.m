%script to test the M-M model

ALmax = 7000;
Lmax = 15000;
Mo = 450;
Mp = 1100;

Ml = 500;
Mr = 50;

lambda = 0.1;
phi = 0.05;
theta = 0.76;
H=1;

dt = 1;
tmax = 20;


AL = zeros(tmax,1);
L = zeros(tmax,1);
h = zeros(tmax,1);
l = zeros(tmax,1);
Pm = zeros(tmax,1);



P = 0*ones(tmax,1);

i=1;
AL(i) = ALmax;
L(i) = Lmax;
h(i) = 0;
l(i) = 0;
Pm(i) = Mp;

for i = 2:dt:tmax
    
if h(i-1) >= l(i-1) + theta    
   AL(i) = AL(i-1) + ( Mo*h(i-1)/(H-phi) + Ml*(h(i-1) - l(i-1) - theta)/(H - theta - lambda) - P(i))*dt;
   L(i) = L(i-1) - (Ml*(h(i-1) - l(i-1) - theta)/(H - theta - lambda))*dt;
else
   AL(i) = AL(i-1) + ( Mo*h(i-1)/(H-phi) + -Mr*(h(i-1) - l(i-1) - theta)/(H - theta - lambda) - P(i))*dt;
   L(i) = L(i-1) - (-Mr*(h(i-1) - l(i-1) - theta)/(H - theta - lambda))*dt; 
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
    if P(i) < 0
        P(i) = 0;
    end 
    if P(i) > Pm
        P(i) = Pm;
    end

    h(i) = get_h_MM(AL(i),ALmax,H);
    l(i) = get_l_MM(L(i),Lmax,H,theta,lambda);

    Pm(i) = Mp * (H-theta-lambda-l(i))/(H - theta - lambda);
end

hold on
plot(Pm)
plot(h)
plot(l)
plot(AL)
plot(L)


%do the same test as billy finton in his report