options = optimoptions('fminunc','Algorithm','quasi-newton');

options.Display = 'iter';


fun = @(x) compare_images(x(1),x(2));
x0 = [1.14; 0.77];
score1 = fun(x0);
stored_x = x0;
[x, fval, exitflag, output] = fminunc(fun,x0,options);


%random search

for i = 1:50000
x_test = [rand*5,rand*5];

score2 = fun(x_test);

if score2 < score1
    stored_x = x_test;
    score1 = score2;
end

end
