%script to begin aero calibration
%this function gives the CdA map from the input variables - using Billy
%fittons equations (first year report phd) with adjustments to limit the d-axial and d-lateral to
%appropriate
function [CFdraft,d_axial,d_lateral,x1g,x2g]  = create_CdA_map()
CF_draft_i_max = 0.583; %maximum possible CF for being in a sequence of cyclists
reso = 0.01;
d_ref = 1.4;%m
d_axial = -2:reso:2; %m
d_max = 1.5;%m
d_lateral = -2:reso:2;
d_lat_min = 0.5;


CF_axial_drafter = ones(length(d_axial),length(d_lateral));
CF_axial_drafted = ones(length(d_axial),length(d_lateral));
CF_lateral_drafter = ones(length(d_axial),length(d_lateral));
CF_lateral_drafted = ones(length(d_axial),length(d_lateral));

for j = 1:length(d_lateral)
    
for i = 1:length(d_axial)

    if abs(d_lateral(j)) < 0.5 && d_axial(i) >=0
CF_axial_drafter(i,j) = CF_draft_i_max - 0.0104*d_axial(i) + 0.4052*d_axial(i)^2;
    end
%max factor of 1
if CF_axial_drafter(i,j) > 1
    CF_axial_drafter(i,j) =1;
end

if d_axial(i) < d_max && abs(d_lateral(j)) < 0.5   && d_axial(i) >=0
CF_axial_drafted(i,j) = 1 - 0.05*(d_ref - d_axial(i))/d_ref;
else
    CF_axial_drafted(i,j) = 1;
end

if abs(d_lateral(j)) < d_max && abs(d_axial(i)) < d_max && abs(d_lateral(j)) > d_lat_min
CF_lateral_drafter(i,j) = 1 + 0.06*(d_max - abs(d_lateral(j)));
CF_lateral_drafter(i,j) =CF_lateral_drafter(i,j) + -0.02*(abs(d_axial(i)))/1;
else
    CF_lateral_drafter(i,j) = 1;
end

CF_lateral_drafted(i,j) = CF_lateral_drafter(i,j); 
if CF_lateral_drafted(i,j) < 1
    CF_lateral_drafted(i,j) =1;
end

if d_axial(i) < 0
    CF_lateral_drafter(i,j) =1;
    CF_lateral_drafted(i,j) =1;
end

end

end

[x1g,x2g]=meshgrid(d_axial,d_lateral);
CFdraft = CF_lateral_drafter.*CF_axial_drafter;%.*CF_axial_drafted;%.*CF_lateral;


CF_drafted = CF_axial_drafted.*CF_lateral_drafted;

% surf(x1g',x2g',CF_drafted,'EdgeColor','none','LineStyle','none');%'FaceLighting','phong');
% hold on
% scatter3(0,0,1)
% caxis([CF_draft_i_max 1.06]) 
% figure
% 
% surf(x1g',x2g',CFdraft,'EdgeColor','none','LineStyle','none');%'FaceLighting','phong');
% hold on
% scatter3(0,0,1)
% 
% caxis([CF_draft_i_max 1.06]) 
