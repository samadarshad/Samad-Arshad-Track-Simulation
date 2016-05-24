%script to begin aero calibration

CF_draft_i_max = 0.8; %maximum possible CF for being in a sequence of cyclists
d_ref = 1.4;%m
d_axial = 0:0.1:2; %m
d_max = 1.5;%m
d_lateral = 0.5;

for i = 1:length(d_axial)
CF_axial_drafter(i) = CF_draft_i_max - 0.0104*d_axial(i) + 0.4052*d_axial(i)^2;

if d_axial(i) < d_max
CF_axial_drafted(i) = 1 - 0.05*(d_ref - d_axial(i))/d_ref;
else
    CF_axial_drafted(i) = 1;
end

if d_lateral < d_max
CF_lateral(i) = 1 + 0.06*(d_ref - d_axial(i))/d_ref;
else
    CF_lateral(i) = 1;
end


end
hold on
scatter(d_axial,CF_axial_drafter)
scatter(d_axial,CF_axial_drafted)
scatter(d_axial,CF_lateral)

CFdraft = CF_axial_drafter.*CF_axial_drafted.*CF_lateral.*CF_lateral;
scatter(d_axial,CFdraft)
