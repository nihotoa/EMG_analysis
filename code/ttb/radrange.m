function y  = radrange(x,m)
%�@�p�xrad��m�𒆐S�Ƃ����͈͂ɕύX
%

xsize   = size(x);

x   = reshape(x,prod(xsize),1);
x   = [repmat(m,length(x),1),x];

y   = unwrap(x,[],2);
y(:,1)  = [];

y   = reshape(y,xsize);

