%function to reverse-decay the aero-grid
%for simplicity, doing a linear recovery
%assumed this function is called every time step

function new_coeffs = recover_aerogrid(coeffs, base_coeffs)

% %gaussian blur (for wake - arbitrary blur)
% new_coeffs = imgaussfilt(coeffs,2);
% 
% %arbitrary recovery function
% new_coeffs = new_coeffs + (base_coeffs - new_coeffs)*0.2; %i.e. doub

%arbitrary recovery function
new_coeffs = coeffs + (base_coeffs - coeffs)*0.2; %i.e. doubling current value

%gaussian blur (for wake - arbitrary blur)
new_coeffs = imgaussfilt(new_coeffs,2);



end
