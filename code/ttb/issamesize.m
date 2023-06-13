function y = issamesize(varargin)

if nargin<2
    error('“ü—Í•Ï”‚Í2‚ÂˆÈã•K—v‚Å‚·B')
end

for ii =1:nargin
    d(ii)   = ndims(varargin{ii});
end

if length(unique(d))~=1
    y   = logical(0);
    return
end

for ii =1:nargin
    s(ii,:)   = size(varargin{ii});
end

if size(unique(s,'rows'),1)==1
    y   = logical(1);
else
    y   = logical(0);    
end