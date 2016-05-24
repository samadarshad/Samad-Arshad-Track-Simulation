%find normal front and rear using eqn 17 and eqn 20 simultaenous


function [F_n_front, F_n_rear] = get_normals(a,b,P,roll)

A = [1 1; a b];
B = [P*cosd(roll); 0];

x = A^-1 * B;
F_n_front = x(1);
F_n_rear = x(2);

end