% concatonate s

[~,m] = size(s);

j = 1; %contour
i = 1; %s index


    new_s(j).v = s(i).v;
    new_s(j).x = [s(i).x]
    new_s(j).y = [s(i).y]
    
    while i < m
        i=i+1;
    if s(i).v == new_s(j).v
        new_s(j).x = [new_s(j).x s(i).x]
        new_s(j).y = [new_s(j).y s(i).y]
    else
        j = j+1;
        new_s(j).v = s(i).v;
    new_s(j).x = [s(i).x]
    new_s(j).y = [s(i).y]
    end
end