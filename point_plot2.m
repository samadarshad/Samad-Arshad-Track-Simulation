%initial point plot
function hPlot = point_plot2(position, color, fig_handle)
if ~isempty(fig_handle)
figure(fig_handle)
end

hPlot = plot3(NaN,NaN,NaN,color);
set(hPlot,'MarkerFaceColor',color(1));
set(hPlot,'XData',position(1),'YData',position(2),'ZData',position(3))

end
