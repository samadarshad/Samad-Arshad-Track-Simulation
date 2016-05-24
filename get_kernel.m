%function to produce kernel for 2d convolution from bluff
%using
%http://uk.mathworks.com/help/images/performing-general-2-d-spatial-transformations.html
%for geometric translations

function kernel = get_kernel(AeroGrid, Bluff, position, contour_direction)

%rotation_angle=acosd(dot(Bluff.direction(1:2),contour_direction(1:2))/(norm(Bluff.direction(1:2))*norm(contour_direction(1:2))));
% ^ this one is not distinguisihing angles greater than 180degrees

%assuming cyclist travels in diretion of contour

% http://au.mathworks.com/matlabcentral/answers/180131-how-can-i-find-the-angle-between-two-vectors-including-directional-information
%modified to be clockwise rather than counterclockwise by the -ive sign
rotation_angle = -atan2d(Bluff.direction(1)*contour_direction(2)-Bluff.direction(2)*contour_direction(1),Bluff.direction(1)*contour_direction(1)+Bluff.direction(2)*contour_direction(2));

kernel = ones(size(AeroGrid.Coeffs));

%can have a function to interpolate the bluff body so it doesnt have any
%sparse points: %function to fill in gaps in the kernel i.e. just incase of over-scaling
%and the points becoming sparse




%get the bluff geometry
bluff_x = Bluff.x(:);
bluff_y = Bluff.y(:);
bluff_z = ones(size(bluff_x,1),1);
bluff_pos = [bluff_x bluff_y bluff_z]';


%translate its position and direction - could also scale the bluff if
%needed - scaling up may not work as points become more disperse, but
%scaling down can work as interpolation will just stack close points
x_trans = position(1) - Bluff.centre(1);
y_trans = position(2) - Bluff.centre(2);

t_matrix = [1 0 0; 0 1 0; x_trans y_trans 1];
r_matrix = [cosd(rotation_angle) -sind(rotation_angle) 0; 
            sind(rotation_angle) cosd(rotation_angle) 0;
            0 0 1];
        

%% rotation matrix
%first do rotation about bluff centre (conjugation)
%conjugation - first translate to centre of bluff 
t_matrix_centre = [1 0 0; 0 1 0; -Bluff.centre(1) -Bluff.centre(2) 1];
bluff_pos = t_matrix_centre' * bluff_pos;
%then rotate
bluff_pos = r_matrix'* bluff_pos; %rotation needs to occur about centre of bluff
%then un-translate the centre movement
t_matrix_centre = [1 0 0; 0 1 0; Bluff.centre(1) Bluff.centre(2) 1];
bluff_pos = t_matrix_centre' * bluff_pos;

%% then do translation to rider position
bluff_pos = t_matrix' * bluff_pos;


projected_x = bluff_pos(1,:);
projected_y = bluff_pos(2,:);
%now these are the positions on the aerogrid - I just need to interpolate
%then apply my values

%interpolate to aerogrid indexes
idx_x = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_x,projected_x,projected_y,'nearest');
idx_y = interp2(AeroGrid.x_vec,AeroGrid.y_vec,AeroGrid.index_y,projected_x,projected_y,'nearest');
%There may be nans here - if there are, just delete them





%use index to change the kernel by the value
bluff_values = Bluff.values(:);

%% deleting nans
%assuming nans in idx x are same as nans in idx y
nan_idx = find(isnan(idx_x));
bluff_values(nan_idx) = [];
idx_x(nan_idx) = [];
idx_y(nan_idx)= [];

idxs = [idx_y;idx_x]';
% index_cells = num2cell(idxs);
% kernel(index_cells{:}) 
%check size of values = of B
if size(idxs, 1) ~= size(bluff_values,1)
    disp('size error, probs interpolation congulation')
end


B = mat2cell(idxs, size(idxs, 1), ones(1, size(idxs, 2)));
kernel_indicies = sub2ind(size(kernel), B{:});
if any(isnan(kernel_indicies))
    disp('nan in ind')
end
kernel(kernel_indicies) = bluff_values;






end