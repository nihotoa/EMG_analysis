function y  = deext(x)
% ファイル名から拡張子を消去する

if(ischar(x))
    X   = {x};
else
    X   = x;
end

nx  =length(X);
y   = cell(1,nx);

for ix=1:nx
    [a,b,c] = fileparts(X{ix});
    y{ix}   = fullfile(a,b);
end

if(ischar(x))
    y   = y{1};
end
end

