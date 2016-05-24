%wrapper function for interpolation
% http://uk.mathworks.com/matlabcentral/newsreader/view_thread/82006 
function Z = interp2_custom(varargin)

Z = interp2(varargin{:});
%Z = qinterp2(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},0);

end