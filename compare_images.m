%wake calibration routine to minimise RMS error with literature CdA factors
function sum_of_abs_differences = compare_images(a,b)


u_inf = 10;
test_velo = 14.5;
scale_factor = test_velo/u_inf;

% figure
% surf(highreswake.u_mat',highreswake.v_mat',scale_factor.*highreswake.velo)
% axis square
% axis equal
% hold on
% surf(highreswake.u_mat',-highreswake.v_mat',scale_factor.*highreswake.velo)



%equivalent CdA factors

% m_wind = (test_velo^2 - scale_factor.*highreswake.velo.^2)/test_velo^2;

% 
% figure
% surf(highreswake.u_mat',highreswake.v_mat',m_wind)
% axis square
% axis equal
% hold on
% surf(highreswake.u_mat',-highreswake.v_mat',m_wind)


%1) get the reference CdA profile (at given 14.5m/s)
%use the 'aerocallibration3 script to generate the data below
[CFdraft,d_axial,d_lateral,x1g,x2g]  = create_CdA_map();
CdA_profile = CFdraft;
axial_cda=x1g;
lateral_cda=x2g;
d_axial;
d_lateral;

%for the axis of the CdA profile
ax_start = find(d_axial==0);
ax_lim = find(d_axial==2);
lat_start = find(d_lateral==-2);
lat_lim = find(d_lateral==2);
CdA_profile_trimmed = CdA_profile(ax_start:ax_lim,lat_start:lat_lim)';


%2) select the parameters to create the wake
% a = 1.14;%scaling of half width to distance
% b = 0.77; %scaling of peak velocity defciet with distance

%3) produce the wake (travelling at u-infinity)
test_wake = make_wake_calibration_adjusted(a,b);

%4) create the equivalent CdA wake (assuming travelling at given 14.5m/s)

m_wind = (test_velo^2 - scale_factor.*test_wake.velo.^2)/test_velo^2;

%5) only focus in on the same range as the empirical CdA map given in (1).
%lets assume this is 0-2 x, 0 to 2 y (as y symmetrical)
ax_start = find(test_wake.u==0);
ax_lim = find(test_wake.u==2);
lat_start = find(test_wake.v==0);
lat_lim = find(test_wake.v==2);
m_wind_trimmed = m_wind(ax_start:ax_lim,lat_start:lat_lim);
u_trimmed = test_wake.u_mat(lat_start:lat_lim,ax_start:ax_lim);
v_trimmed = test_wake.v_mat(lat_start:lat_lim,ax_start:ax_lim);
%figure
% surf(u_trimmed',v_trimmed', m_wind_trimmed)
% hold on


%5b) copy and reflect the wake
m_wind_trimmed_full = [flipud(m_wind_trimmed); m_wind_trimmed];
v_trimmed_full = [-v_trimmed'; v_trimmed'];
u_trimmed_full = [fliplr(u_trimmed)'; u_trimmed'];
figure
surf(u_trimmed_full,v_trimmed_full, m_wind_trimmed_full)
% caxis([0.8 1.06]) 
%6) now I need to create a new map, the same resolution as the CdAprofile

blank_cda_map = zeros(size(CdA_profile_trimmed));

%7) now convert the aero map to the same resolution as CdAprofile
converted_aero_map = imresize(m_wind_trimmed_full,size(CdA_profile_trimmed),'nearest');
converted_u = imresize(u_trimmed_full,size(CdA_profile_trimmed),'nearest');
converted_v = imresize(v_trimmed_full,size(CdA_profile_trimmed),'nearest');
% figure
% surf(converted_u,converted_v,converted_aero_map)

%8) now take the difference!!!

blank_cda_map = converted_aero_map- CdA_profile_trimmed;% - converted_aero_map;% - CdA_profile_trimmed;
% figure
% hold on
% surf(converted_u,converted_v,blank_cda_map)

%9) return the sum of the absolute differences
sum_of_abs_differences = sum(sum(abs(blank_cda_map.^2)));