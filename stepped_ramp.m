%function to get power-velocity curves

%creating a stepped ramp
function s_ramp = stepped_ramp(ramp_start,ramp_end,step_height,slope)
tmp = [];
if ramp_start > ramp_end
    tmp = ramp_end;
    ramp_end = ramp_start;
    ramp_start = tmp;
end
num_intervals = (ramp_end-ramp_start)/step_height;
ramp1 = ramp_start:slope:ramp_end;

ramp1_10 = num_intervals*(ramp1-ramp_start)./(ramp_end-ramp_start);

f_r_1_10 = floor(ramp1_10);

f_r_1 = f_r_1_10.*step_height;
s_ramp = ramp_start + f_r_1;


if ~isempty(tmp)
    s_ramp = fliplr(s_ramp);
end
end



