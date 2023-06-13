function	[err,rcor,yy,zz] = mean_sq_error(y,z,mode)
% Mean squared error and correlation coefficient (component-wise)
% [err,rcor,yy,zz] = mean_sq_error(y,z)
%  
%  err = mean((y-z).^2, 2)
% rcor = mean((y - <y>).*(z - <z>), 2)
%  yy  = mean((y-<y>).^2, 2)
%  zz  = mean((z-<z>).^2, 2)
%
% GoF  = 1 - err./yy

if nargin < 3, mode = 0; end;

[N,T,Ntr] = size(y);

if T*Ntr == 1,
	y = y';
	z = z';
else
	y = reshape(y,[N,T*Ntr]);
	z = reshape(z,[N,T*Ntr]);
end

err  = mean((y-z).^2,2);

switch	mode
case	0
	y  = repadd(y , - mean(y,2));
	z  = repadd(z , - mean(z,2));
	
	yy = mean(y.^2,2);
	zz = mean(z.^2,2);
	
	rcor = mean(y.*z,2);
case	1
	yy = mean(y.^2,2);
	zz = mean(z.^2,2);
	
	rcor = mean(y.*z,2);
end
