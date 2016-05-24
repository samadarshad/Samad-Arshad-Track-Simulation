%function to return vector of seconds relative to a starting time '
%vectorised_time(1,:) '
%(optional)

function vectorised_seconds = make_seconds(time,varargin)

if ~isempty(varargin)
start_time = datenum(datevec(cellstr(varargin{1}(15:23))));
end

timecropped = time;
for i = 1:size(time)
    timecropped(i) =  cellstr(time{i}(15:23));
end

vectorised_time = datevec(timecropped);
 vectorised_seconds = zeros(size(time));
 
 if isempty(varargin)
for i = 1:size(time)
    vectorised_seconds(i) = (datenum(vectorised_time(i,:)) - datenum(vectorised_time(1,:)))*60*60*24/60;
end
 else 
    for i = 1:size(time)
    vectorised_seconds(i) = (datenum(vectorised_time(i,:)) - start_time)*60*60*24/60;
    end
 end
 



end
