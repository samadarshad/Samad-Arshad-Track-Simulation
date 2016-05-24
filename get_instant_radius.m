%function to get instant radius of curvature using lane lookup table


function R = get_instant_radius(lanes_struct,lane,lane_idx)

R = lanes_struct(lane).radius_curvatures(lane_idx);

end