%function to get transformed mesh for lane
%UPDATE: with variable lenght_spacing (for finer mesh)
%UPDATE: faster with less for loops

%output: two matricies - one for real coordinates u,v, other for
%'origonal' x,y

function lane_aero_mapping = find_lane_aero_mesh_finer_fast(lane, MeshSt) %assuming aero grid is the same as meshgrid
half_width = 2; %4 meters aero width
spacing_width = 0.05; %standard spacing 
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
u = zeros(lane.Length/spacing_length,num_width);
v = zeros(size(u));
x = zeros(size(u));
y = zeros(size(u));
x_floating = zeros(size(u));
y_floating = zeros(size(u));

%outward vectors
outward_dir_flat = zeros(lane.Length,2);

centre_idx = half_width/spacing_width + 1;
cumu_sum = 0;
lane_cumsum = cumsum(lane.dS);

i = 1:lane.Length/spacing_length;
  
    %the values of u are determined by the distance along the lane by
    %cumulative sum
    lane_cumsum = interp(lane.cumS,1/spacing_length);
    u(i,:) = lane_cumsum*ones(1,num_width);
    v(i,centre_idx) = 0;
    cumu_sum = cumu_sum+spacing_length;
   


    %need to find x/y position this lane_position corresponds to
    pos = dsearchn(lane.cumS,u(:,centre_idx));
    
    
    
    x_floating(:,centre_idx) = lane.X(pos); %assuming this has already interpolated to the mesh
    y_floating(:,centre_idx) = lane.Y(pos); %assuming this has already interpolated to the mesh
    %nope - this ISNT interpolated to the mesh - correct for this
    x(:,centre_idx) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.x_mat,x_floating(:,centre_idx),y_floating(:,centre_idx),'nearest');
    y(:,centre_idx) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.y_mat,x_floating(:,centre_idx),y_floating(:,centre_idx),'nearest');
    
    
    i = 1:lane.Length/spacing_length;
    outward_dir_flat(i,:) = lane.vectors.sl(pos(i),1:2); 
   % outward_dir_flat(i,:) = outward_dir_flat(i,:)/norm(outward_dir_flat(i,:));
    
    outward_dir_flat(i,:) = bsxfun(@rdivide, outward_dir_flat(i,:),sqrt(sum(abs(outward_dir_flat(i,:)).^2,2)));



    %not using nested for loop for speed
    
    %across width - use slope and spacing
    %accessing matricies by column rather than row for speed - therefore
    %set width position then query along lane, rather than other way round.
for j = [1:centre_idx-1,centre_idx+1:num_width] %skipping '0' as we already found this
   width_pos = -half_width + (j-1)*spacing_width;
   
   
   x_y_floating = [x_floating(:,centre_idx),y_floating(:,centre_idx)] +width_pos.*outward_dir_flat; %'floating' to indicate its not been 'fixed' or interpolated to the mesh
   
   
        %create x/y pos
         %[x(i,j), y(i,j)]
         
       x_floating(:,j) = x_y_floating(:,1);
       y_floating(:,j) = x_y_floating(:,2);
         %v(i,j) = ((x_y_floating(1) -  x(i,centre_idx))^2 + (x_y_floating(2) -  y(i,centre_idx))^2)^0.5;
         %interpolate to mesh
        x(:,j) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.x_mat,x_y_floating(:,1),x_y_floating(:,2),'nearest');
        y(:,j) = interp2(MeshSt.x_vec,MeshSt.y_vec,MeshSt.y_mat,x_y_floating(:,1),x_y_floating(:,2),'nearest');
        
        %recalculate v
        %
        v(:,j) = ((x(:,j) -  x(:,centre_idx)).^2 + (y(:,j) -  y(:,centre_idx)).^2).^0.5;
    
end
%% THE V's havent been mapped properly
%% 

lane_aero_mapping.x = x;
lane_aero_mapping.y = y;
lane_aero_mapping.u = u;
lane_aero_mapping.v = v;

newtestlane = handle_duplicates(lane_aero_mapping);
lane_aero_mapping = newtestlane;
end

