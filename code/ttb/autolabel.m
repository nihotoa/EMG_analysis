function [y,prefix,suffix]  = autolabel(varargin)


if(nargin==1 && iscell(varargin{1}))
    x   = varargin{1};
else
    x   = cell(1,nargin);
    for ii=1:nargin
        x{ii}   = varargin{ii};
    end
end

    nn  = length(x);
    
prefixind   = 1;
X   = cell(1,nn);
while(prefixind)
    for ii =1:nn
        X{ii}    = x{ii}(1:prefixind);
    end
    if(all(strcmp(X,X{1})))
        prefixind   = prefixind + 1;        
    else
        prefixind   = prefixind - 1;
        break;
    end
end

suffixind   = 1;
X   = cell(1,nn);
while(suffixind)
    for ii =1:nn
        X{ii}    = x{ii}((end-suffixind+1):end);
    end
    if(all(strcmp(X,X{1})))
        suffixind   = suffixind + 1;        
    else
        suffixind   = suffixind - 1;
        break;
    end
end

y   = cell(size(x));

for ii=1:nn
    y{ii}   = x{ii}((prefixind+1):(end-suffixind));
end

prefix  = x{ii}(1:prefixind);
suffix  = x{ii}((end-suffixind+1):end);