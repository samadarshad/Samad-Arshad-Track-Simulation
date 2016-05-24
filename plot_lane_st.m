%function to plot lane from lane structure

function plot_lane_st(lane,handle)

figure(handle)
plot3(lane.X,lane.Y,lane.Z,'Color',lane.color);




end