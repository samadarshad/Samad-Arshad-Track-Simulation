%function to retrieve velocity from u-v input into the high_resolution mesh

function velo = get_wake(u,v,highreswake)

%velo = interp2(highreswake.u_mat,abs(highreswake.v_mat),highreswake.velo,u(:),v(:),'nearest');
velo = highreswake.gi(u,v);

end