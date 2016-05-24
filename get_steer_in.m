%bool function to see if steering inward or outward

function steer_in = get_steer_in(vel)

steer_in = zeros(length(vel),1);

for k = 1:length(vel)
    steer_in(k) = vel{k}(2)<=0;
end



end