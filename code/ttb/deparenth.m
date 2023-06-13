function y  = deparenth(x)

ind = strfind(x,'(');
x(ind)  = '_';

ind = strfind(x,')');
x(ind)  = '_';

y   =x;
