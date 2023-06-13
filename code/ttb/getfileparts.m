function y  = getfileparts(x,fieldname)
% path,file,extention

if(nargin<2)
    fieldname   = 'file';
end

[p,f,e] = fileparts(x);


switch lower(fieldname(1))
    case 'p'
        y   = p;
    case 'f'
        y   = f;
    case 'e'
        y   = e;
    otherwise
        y   =[];
end

