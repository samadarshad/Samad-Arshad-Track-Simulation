%script to apply high_res uv to mesh xy

function kernel = wake_to_kernel(AeroGrid,wakeprofile,lane)

%take lane 1, with player at default origion of u-v that corresponds to
%their position in x-y (later will need to shift the u based on where they
%are - wont need to shift v as each lane has its own v - however if the
%number of lanes become large, then its probably faster to implement a
%shifting v)


%wakeprofile = get_wake(lanes(1).aero_mapping.u,lanes(1).aero_mapping.v,highreswake);
% [X,Y]=meshgrid(unique(lanes(1).aero_mapping.x),unique(lanes(1).aero_mapping.y));


% scatter3(lanes(1).aero_mapping.x,lanes(1).aero_mapping.y,velos); 

%now need to append this to the existing aerogrid
%do interpolation to find x/y as indexes of aerogrid


idx_x = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,lane.aero_mapping.x,lane.aero_mapping.y,'nearest');
idx_y = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,lane.aero_mapping.x,lane.aero_mapping.y,'nearest');

%now fill in AeroCoeffs/velocity.mag using the idxs and velos
kernel = zeros(size(AeroGrid.Coeffs));

idxs = [idx_y idx_x];
indexCell = num2cell(idxs,1);
linearIndexMatrix = sub2ind(size(kernel),indexCell{:});

%removing nans in the matrix indexes (i.e. for lane 5) 
non_nan_idxs=find(~isnan(linearIndexMatrix));



kernel(linearIndexMatrix(non_nan_idxs)) = wakeprofile(non_nan_idxs);

end
