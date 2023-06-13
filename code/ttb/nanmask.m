function y  = nanmask(x,mask)
% y  = nanmask(x,mask)
% maskはxと同じサイズのlogical(or1/0)行列（配列）
% maskが0の要素をNaNにおきかえる


warning('off')
mask    = double(mask) ./ double(mask);
y       = x .* mask;
warning('on')