function [Ei,thetai]=CurvatureEstimation(list,fn,bn)
% This function calculates the curvature of a 2D line. 
% Reference£ºS. Hermann and R. Klette. Multigrid analysis of curvature estimators. Proc.
%            Image Vision Computing New Zealand, 108¨C112, 2003.
% by Jianfei Pang
%  k = CurvatureEstimation(list,b,f)
% 
% inputs,
%   list : A M x 2 list of line points.
%   fn:    The number of forward points that were chosen to calcute.
%   bn:    The number of backward points that were chosen to calcute. 
%
% outputs,
%   Ei : M x 1 Curvature values
%   thetai:M x 1 angle values
% Example
% [Ei,ti]=CurvatureEstimation(test,4,4);

if(nargin<2)
  fn=5;bn=5;  
end
if fn<1
    fn=5;
end
if bn<1
    bn=5;
end

num=length(list);
Ei=zeros(num,1);
for k=2:num-1
    % get the right fn or bn at the first or last few points
    if k<fn+bn       
     fnd=floor(k/2);bnd=k-fnd;        
    else
        if k+fn>num
             fnd=num-k;bnd=bn; 
        else
         fnd=fn;bnd=bn;
        end
    end         
     % calculate
            lb=sqrt((list(k,1)-list(k-bnd,1)).^2+(list(k,2)-list(k-bnd,2)).^2);
            lf=sqrt((list(k,1)-list(k+fnd,1)).^2+(list(k,2)-list(k+fnd,2)).^2);
            if (list(k,2)-list(k-bnd,2))~=0
                thetab=atan(abs(list(k,1)-list(k-bnd,1))/abs(list(k,2)-list(k-bnd,2)));                
            else
                 thetab=acot(abs(list(k,1)-list(k-bnd,1))/abs(list(k,2)-list(k-bnd,2)));
            end
            if (list(k,2)-list(k+fnd,2))~=0
            thetaf=atan(abs(list(k,1)-list(k+fnd,1))/abs(list(k,2)-list(k+fnd,2)));
            else
                thetaf=acot(abs(list(k,1)-list(k+fnd,1))/abs(list(k,2)-list(k+fnd,2)));
            end
            thetai(k)=(thetab+thetaf)/2;
            detlaf=abs(thetaf-thetai(k));
            detlab=abs(thetai(k)-thetab);
            Ei(k)=detlaf/lf/2+detlab/lb/2;           
   
end
    Ei(1)=Ei(2);Ei(num)=Ei(num-1);
    thetai(1)=thetai(2);thetai(num)=thetai(num-1);
    
    % show
%     figure;
%     subplot(131)
%     plot(list(:,1),list(:,2))
%     
%     subplot(132)
%     plot(thetai)
%     subplot(133)
%     plot(Ei)