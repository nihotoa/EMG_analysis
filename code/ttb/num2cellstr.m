function y  = num2cellstr(x)

sizex   = size(x);
nx      = numel(x);
x   = reshape(x,1,nx);
y   = cell(1,nx);

for ii  =1:nx
    y{ii}   = num2str(x(ii));
end

y   = reshape(y,sizex);