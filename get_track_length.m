%get track length
%input column vectors of each x y z dimension
%output scalar of total track length (by linear differences)

function [length_track, diff_vec_norm] = get_track_length(Sx, Sy, Sz)



shifted_vec.X = circshift(Sx,[1,0]);
shifted_vec.Y = circshift(Sy,[1,0]);
shifted_vec.Z = circshift(Sz,[1,0]);

diff_vec = [Sx - shifted_vec.X Sy - shifted_vec.Y Sz - shifted_vec.Z];
diff_vec_norm = sqrt(sum(abs(diff_vec).^2,2));
length_track = sum((diff_vec(:,1).^2+diff_vec(:,2).^2 +diff_vec(:,3).^2).^0.5);
end
