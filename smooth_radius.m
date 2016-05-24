%script to test curvature estimation and smoothening
function radius_of_c = smooth_radius(lane_x, lane_y)
%% the forward and backward selection for the curvature - testing shows
%choosing 20 elements produces reasonable results (tested using lanes(1))
fd_bk = 40;

%ensure column vectors
lane_x = lane_x(:);
lane_y = lane_y(:);

vect = [lane_x lane_y];
vect_3 = [vect; vect; vect]; 


%% TEST try circle fitting
xc=zeros(length(vect_3),1);
yc=zeros(length(vect_3),1);
R=zeros(length(vect_3),1);
a=zeros(length(vect_3),1);
for i = length(vect)+1:2*length(vect)
 [xc(i),yc(i),R(i)] = circfit(vect_3(i-fd_bk:i+fd_bk,1),vect_3(i-fd_bk:i+fd_bk,2));
 
end
radius_of_c = R( length(vect)+1:2*length(vect));


% 
% %% curvature estimation
% 
% [Ei,ti]=CurvatureEstimation(vect_3,fd_bk,fd_bk);
% m = length(vect);
% cs_vec = Ei(m+1:2*m);
% 
% % figure(1)
% % hold on
% % plot3(vect(:,1), vect(:,2), cs_vec,'DisplayName',[num2str(fd_bk)]);
% % legend(gca,'show')
% 
% 
% %% smoothen curvature, using default 40-size gaussian window
% sm_cs = smooth_lane_1D(cs_vec);
% % plot3(vect(:,1), vect(:,2), sm_cs,'DisplayName',[num2str(fd_bk)]);
% 
% %% get radius of curvature (smooth)
% radius_of_c = 1./sm_cs;
% 
% % figure(2)
% % plot3(vect(:,1), vect(:,2), radius_of_c,'DisplayName',[num2str(fd_bk)]);
% % legend(gca,'show')
% % set(gca,'zscale','log');

end