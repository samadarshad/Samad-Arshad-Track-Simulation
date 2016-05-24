%function to get h from MM model, see exercise book

function h = get_h_MM(AL,ALmax,H)

h = H - (AL/ALmax)*H;
end