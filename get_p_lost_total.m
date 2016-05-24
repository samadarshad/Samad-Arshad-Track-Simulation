
%function to get total lost power by adding up

function p_lost = get_p_lost_total(F_inc, v_cg, F_d, v_d, F_r, v_w, F_br, r_b, w_w)



p_lost = get_p_incline(F_inc,v_cg) + get_p_drag(F_d,v_d) + get_p_roll(F_r,v_w) + get_p_bearing(F_br,r_b,w_w);

end