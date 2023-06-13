function y  = cellmatch(x1,x2)

sizex   = size(x1);
if(~iscell(x1) || ~iscell(x2))
    error('input must be cell array')
elseif(numel(x1)~=numel(x2))
    error('input must have same size');
elseif(~all(size(x1)==size(x2)))
    error('input must have same size');
end

x1  = reshape(x1,numel(x1),1);
x2  = reshape(x2,numel(x2),1);

ncell   = length(x1);
y   = false(size(x1));

for icell=1:ncell
    try
        if(ischar(x1{icell}))
            y(icell)    = strcmp(x1{icell},x2{icell});
        else
            y(icell)    = x1{icell} == x2{icell};
        end
    catch
        y(icell)    = false;
    end
end

y   = reshape(y,sizex);


