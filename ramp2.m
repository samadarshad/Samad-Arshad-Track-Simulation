% function [ y ] = ramp(x)
%     y=zeros(size(x));
%     y(x>=0)=linspace(0,x(end),length(x(x>=0)));
% end