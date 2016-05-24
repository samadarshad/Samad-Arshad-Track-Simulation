%function to draw points initially
function point_plot(point3, colours_in, handle)
if ~isempty(handle)
figure(handle)
end
if isempty(colours_in)
colours = ['ro'; 'bo'; 'go'; 'yo'];

else
    colours = colours_in;
end
col_dat = cellstr(colours);
for k = 1:size(point3,1)
 hPlot = plot3(NaN,NaN,NaN,col_dat{k});
 hold on
set(hPlot,'XData',point3(k,1),'YData',point3(k,2),'ZData',point3(k,3)); 
end

end
