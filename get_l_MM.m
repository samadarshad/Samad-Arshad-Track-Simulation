%function to get l from MM model, see exercise book

function l = get_l_MM(L,Lmax,H,theta,lambda)

l = ((Lmax - L)/Lmax)*(H - theta - lambda);

end