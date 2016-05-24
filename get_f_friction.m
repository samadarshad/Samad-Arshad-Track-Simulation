%function to get friction resistance 
%assuming both front and rear wheel the same

function f_friction = get_f_friction(F_n,Crr)
%eqn 35,36,37

f_friction = F_n * Crr;

end