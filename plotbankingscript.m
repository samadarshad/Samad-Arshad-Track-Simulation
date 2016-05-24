%script to plot velocities and heights to show effect of banking when
%swooping
figure
time_end = 200;
plotyy(time_var(1:time_end),[riders(1).v_w(1:time_end); riders(2).v_w(1:time_end); riders(3).v_w(1:time_end)],time_var(1:time_end),[riders(1).height(1:time_end); riders(2).height(1:time_end); riders(3).height(1:time_end)])