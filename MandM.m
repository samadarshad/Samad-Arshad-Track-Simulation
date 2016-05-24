%Dahmen's model

function [AWC,E_profile,AL,L,E_profile2] = MandM(CP,MaxP,SRM,dt)

AWC = 100000;
Mo = CP;
Ml = 1.1*CP;
Mr = CP/8;
lambda = 0.1;
phi = 0.05;
theta = 0.76;
ALratio = 0.32;
Lratio = 0.68;
H = 1;

% limit = 0;
% next = 0;
% while next < 1;
    
    E_profile = zeros(length(SRM(:,1)),1);
    L = zeros(length(SRM(:,1)),1);
    AL = zeros(length(SRM(:,1)),1);
    ALmax = ALratio*AWC;
    Lmax = Lratio*AWC;

    for i = 1:length(SRM(:,1))
        if i == 1
            AL(i,1) = ALmax/2;%*(1-0.3488);
            L(i,1) = Lmax*5/6;
            
        else
            if h(i-1) > (l(i-1) + theta)   %Deplete L
                AL(i,1) = AL(i-1,1) + ((Mo*(h(i-1,1)/(H-phi))) + (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda))) - SRM(i,1))*dt ; 
                L(i,1) = L(i-1) - (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
                if AL(i,1) < 0;
                    AL(i,1) = 0;
                end
                if L(i,1) < 0;
                    L(i,1) = 0;
                end
                if AL(i,1) > ALmax
                    AL(i,1) = ALmax;
                end
                
                
                if L(i,1) > Lmax
                    L(i,1) = Lmax;
                end
                
                
                
            else                            %Replete L (amended for +Mr)
                if (l(i-1)==0) %i.e. L tank is full
                AL(i,1) = AL(i-1,1) + (Mo*(h(i-1,1)/(H-phi)) - SRM(i,1))*dt; 
                L(i,1) = L(i-1); %this should be the same as Lmax    
                else
                AL(i,1) = AL(i-1,1) + (Mo*(h(i-1,1)/(H-phi)) + +Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)) - SRM(i,1))*dt ; 
                L(i,1) = L(i-1) - (+Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
                end
                
                
                if AL(i,1) < 0;
                    AL(i,1) = 0;
                end
                if L(i,1) < 0;
                    L(i,1) = 0;
                end
                
                 if AL(i,1) > ALmax
                    AL(i,1) = ALmax;
                end
                
                
                if L(i,1) > Lmax
                    L(i,1) = Lmax;
                end
            end
        end
        l(i,1) = (1-(L(i,1)/Lmax))*(H-theta-lambda);
        h(i,1) = (1-(AL(i,1)/ALmax))*(H);
        E_profile(i,1) = AL(i,1) + L(i,1);
    end
     E_profile_diff = diff(E_profile);
     E_profile2 = E_profile_diff;
    
    
    
    
    
    
%     
%     for i = 1:length(L(:,1))
%         if i < 40
%         else
%             a = L(i,1)/Lmax;
%             b = (SRM(i,1)-CP)/(MaxP-CP);
%             if a < b
%                 limit = 1;
%             end
%         end
%     end
% 
%     if (min(L) <= 0) || (min(AL) <= 0) || (limit == 1)
%         next = 1;
%         AWC = AWC + 1000;
%     else
%         AWC = AWC - 1000;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% limit = 0;
% next = 0;
% while next < 1;
%     
%     E_profile = zeros(length(SRM(:,1)),1);
%     L = zeros(length(SRM(:,1)),1);
%     AL = zeros(length(SRM(:,1)),1);
%     ALmax = ALratio*AWC;
%     Lmax = Lratio*AWC;
% 
%     for i = 1:length(SRM(:,1))
%         if i == 1
%             AL(i,1) = ALmax;
%             L(i,1) = Lmax;
%         else
%             if h(i-1) > (l(i-1) + theta)   
%                 AL(i,1) = AL(i-1,1) + ((Mo*(h(i-1,1)/(H-phi))) + (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda))) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             else
%                 AL(i,1) = AL(i-1,1) + (Mo*(h(i-1,1)/(H-phi)) - Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (-Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             end
%         end
%         l(i,1) = (1-(L(i,1)/Lmax))*(H-theta-lambda);
%         h(i,1) = (1-(AL(i,1)/ALmax))*(H-phi);
%         E_profile(i,1) = AL(i,1) + L(i,1);
%     end
%     
%     for i = 1:length(L(:,1))
%         if i < 40
%         else
%             a = L(i,1)/Lmax;
%             b = (SRM(i,1)-CP)/(MaxP-CP);
%             if a < b
%                 limit = 1;
%             end
%         end
%     end
% 
%     if (min(L) <= 0) || (min(AL) <= 0) || (limit == 1)
%         next = 1;
%         AWC = AWC + 100;
%     else
%         AWC = AWC - 100;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% limit = 0;
% next = 0;
% while next < 1;
%     
%     E_profile = zeros(length(SRM(:,1)),1);
%     L = zeros(length(SRM(:,1)),1);
%     AL = zeros(length(SRM(:,1)),1);
%     ALmax = ALratio*AWC;
%     Lmax = Lratio*AWC;
% 
%     for i = 1:length(SRM(:,1))
%         if i == 1
%             AL(i,1) = ALmax;
%             L(i,1) = Lmax;
%         else
%             if h(i-1) > (l(i-1) + theta)   
%                 AL(i,1) = AL(i-1,1) + ((Mo*(h(i-1,1)/(H-phi))) + (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda))) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             else
%                 AL(i,1) = AL(i-1,1) + (Mo*(h(i-1,1)/(H-phi)) - Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (-Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             end
%         end
%         l(i,1) = (1-(L(i,1)/Lmax))*(H-theta-lambda);
%         h(i,1) = (1-(AL(i,1)/ALmax))*(H-phi);
%         E_profile(i,1) = AL(i,1) + L(i,1);
%     end
%     
%     for i = 1:length(L(:,1))
%         if i < 40
%         else
%             a = L(i,1)/Lmax;
%             b = (SRM(i,1)-CP)/(MaxP-CP);
%             if a < b
%                 limit = 1;
%             end
%         end
%     end
% 
%     if (min(L) <= 0) || (min(AL) <= 0) || (limit == 1)
%         next = 1;
%         AWC = AWC + 10;
%     else
%         AWC = AWC - 10;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% limit = 0;
% next = 0;
% while next < 1;
%     
%     E_profile = zeros(length(SRM(:,1)),1);
%     L = zeros(length(SRM(:,1)),1);
%     AL = zeros(length(SRM(:,1)),1);
%     ALmax = ALratio*AWC;
%     Lmax = Lratio*AWC;
% 
%     for i = 1:length(SRM(:,1))
%         if i == 1
%             AL(i,1) = ALmax;
%             L(i,1) = Lmax;
%         else
%             if h(i-1) > (l(i-1) + theta)   
%                 AL(i,1) = AL(i-1,1) + ((Mo*(h(i-1,1)/(H-phi))) + (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda))) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (Ml*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             else
%                 AL(i,1) = AL(i-1,1) + (Mo*(h(i-1,1)/(H-phi)) - Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)) - SRM(i,1))*dt ; 
%                 L(i,1) = L(i-1) - (-Mr*((h(i-1,1)-l(i-1)-theta)/(H-theta-lambda)))*dt; 
%                 if AL(i,1) < 0;
%                     AL(i,1) = 0;
%                 end
%                 if L(i,1) < 0;
%                     L(i,1) = 0;
%                 end
%             end
%         end
%         l(i,1) = (1-(L(i,1)/Lmax))*(H-theta-lambda);
%         h(i,1) = (1-(AL(i,1)/ALmax))*(H-phi);
%         E_profile(i,1) = AL(i,1) + L(i,1);
%     end
%     
%     for i = 1:length(L(:,1))
%         if i < 40
%         else
%             a = L(i,1)/Lmax;
%             b = (SRM(i,1)-CP)/(MaxP-CP);
%             if a < b
%                 limit = 1;
%             end
%         end
%     end
% 
%     if (min(L) <= 0) || (min(AL) <= 0) || (limit == 1)
%         next = 1;
%         AWC = AWC + 1;
%     else
%         AWC = AWC - 1;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
