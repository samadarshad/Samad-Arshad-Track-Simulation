%function to plot 1D vector and update for the height graphs 

%property is a 1D vector
%handle is the handle to the figure/subplot
function plot_rider_properties(property,handle)

% plot(handle,property);
% 
% subplot(test_h)
% test_h_pl1 = plot(height_vec(:,1));
% hold on
% test_h_pl2 = plot(height_vec(:,2));
% title('Height from base (meters)')
% set(test_h_pl1,'YData',height_vec(:,1));
% set(test_h_pl1,'YData',height_vec(:,1));
set(handle,'YData',property);



end