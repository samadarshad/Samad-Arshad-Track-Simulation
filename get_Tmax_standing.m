%function to get Tmax at a standing start: rearranged equation 64 in billy
%Fittons report.

function Tmax = get_Tmax_standing(Pin,wc,wc_max)



Tmax = Pin / ((1- wc/wc_max)*wc);


end