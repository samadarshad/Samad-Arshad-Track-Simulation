u_inf = 10;
test_velo = 14.5;
scale_factor = test_velo/u_inf;
figure
surf(highreswake.u_mat',highreswake.v_mat',scale_factor.*highreswake.velo)
axis square
axis equal
hold on
surf(highreswake.u_mat',-highreswake.v_mat',scale_factor.*highreswake.velo)



%equivalent CdA factors

m_wind = (test_velo^2 - scale_factor.*highreswake.velo.^2)/test_velo^2;


figure
surf(highreswake.u_mat',highreswake.v_mat',m_wind)
axis square
axis equal
hold on
surf(highreswake.u_mat',-highreswake.v_mat',m_wind)