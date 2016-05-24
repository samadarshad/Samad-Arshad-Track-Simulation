%function to get transformed mesh for lane
%output: two matricies - one for real coordinates u,v, other for
%'origonal' x,y

function lane_aero_mapping = find_lane_aero_mesh(lane, MeshSt) %assuming aero grid is the same as meshgrid
half_width = 2; %4 meters aero width
spacing_width = 2; %standard spacing 
spacing_length = spacing_width;
num_width = 2*half_width/spacing_width + 1;
% %real (rectangle) coordinates - define points which you will be querying
% %relative to the lane
% [u,v] = meshgrid(0:spacing_length:lane.tracklength,-half_width:spacing_width:half_width);
% 
% 
% %now query points and interpolate


%must go along lane, and set u AND x simultaenously - I cant just first
%create u then query x as I cant ensure compatibality of the lane position
%also it makes more sense, as the lane u's and v's should be as close as
%possible to the grid (i.e. doesnt have to be exactly 0, 0.5,... 250m) and
%then we can use the wake to interpolate to nearest point etc to the lane
%coordinate system.
u = zeros(lane.Length,num_width);
v = zeros(size(u));
x = zeros(size(u));
y = zeros(size(u));
x_floating = zeros(size(u));
y_floating = zeros(size(u));

%outward vectors
outward_dir_flat = zeros(lane.Length,2);

centre_idx = half_width/spacing_width + 1;
cumu_sum = 0;
for i = 1:lane.Length
    outward_dir_flat(i,:) = lane.vectors(i).sl(1:2); 
    outward_dir_flat(i,:) = outward_dir_flat(i,:)/norm(outward_dir_flat(i,:));
    %the values of u are determined by the distance along the lane by
    %cumulative sum
    u(i,:) = cumu_sum*ones(num_width,1);
    v(i,centre_idx) = 0;
    x_floating(i,centre_idx) = lane.X(i); %assuming this has already interpolated to the mesh
    y_floating(i,centre_idx) = lane.Y(i); %assuming this has already interpolated to the mesh
    %nope - this ISNT interpolated to the mesh - correct for this
    x(i,centre_idx) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.x_mat,x_floating(i,centre_idx),y_floating(i,centre_idx),'nearest');
    y(i,centre_idx) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.y_mat,x_floating(i,centre_idx),y_floating(i,centre_idx),'nearest');
      
    
    cumu_sum = cumu_sum+lane.dS(i);
end


    %not using nested for loop for speed
    
    %across width - use slope and spacing
    %accessing matricies by column rather than row for speed - therefore
    %set width position then query along lane, rather than other way round.
for j = [1:centre_idx-1,centre_idx+1:num_width] %skipping '0' as we already found this
   width_pos = -half_width + (j-1)*spacing_width;
    for i = 1:lane.Length
        %create x/y pos
         %[x(i,j), y(i,j)]
         x_y_floating = [x_floating(i,centre_idx),y_floating(i,centre_idx)] +width_pos.*outward_dir_flat(i,:); %'floating' to indicate its not been 'fixed' or interpolated to the mesh
       x_floating(i,j) = x_y_floating(1);
       y_floating(i,j) = x_y_floating(2);
         %v(i,j) = ((x_y_floating(1) -  x(i,centre_idx))^2 + (x_y_floating(2) -  y(i,centre_idx))^2)^0.5;
         %interpolate to mesh
        x(i,j) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.x_mat,x_y_floating(1),x_y_floating(2),'nearest');
        y(i,j) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.y_mat,x_y_floating(1),x_y_floating(2),'nearest');
        
        %recalculate v
        %
        v(i,j) = ((x(i,j) -  x(i,centre_idx))^2 + (y(i,j) -  y(i,centre_idx))^2)^0.5;
    end
end

lane_aero_mapping.x = x;
lane_aero_mapping.y = y;
lane_aero_mapping.u = u;
lane_aero_mapping.v = v;

end

