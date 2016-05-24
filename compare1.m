% comparing simulation with data

plotyy(time_var,[riders(1).v_w' wheel_speed_ms(3295:race_length+3295-1)],time_var,riders(1).power_input)


%absolute wind speeds
figure;
plot(time_var(1:end-1),(riders(1).v_cg - riders(1).v_air(1:end-1))',time_var(1:end-1),smooth_wind(3295:race_length+3295-2))
%relative wind speeds
figure;
plot(time_var(1:end-1),-riders(1).v_air(1:end-1),time_var(1:end-1),smoothed_rel_wind(3295:race_length+3295-2))




figure;

plotyy(time_var,[riders(1).AWC' riders(1).AL' riders(1).L'] ,time_var,[riders(1).constrained_Pmax' riders(1).power_input])