function vel = get_velo(i,velocity)
for k = 1:length(velocity)
    
vel{k} = velocity{k}(:,i);
end

end
