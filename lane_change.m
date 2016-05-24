%function for changing lanes - scaetrix

function [lane, lane_idx, position] = lane_change(new_lane, lanes, position, MeshSt)
lane = new_lane;
lane_number = new_lane;
lane_idx =  dsearchn([lanes(lane_number).X lanes(lane_number).Y],position(1:2));
position = [lanes(lane_number).X(lane_idx) ...
                      lanes(lane_number).Y(lane_idx) ...
                      lanes(lane_number).Z(lane_idx) ];
%rider_st.vectors = get_vects(MeshSt,rider_st.position);



end