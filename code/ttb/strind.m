function [y,x]  = strind(x)

% y  = strind(x)
% x��������̃Z���z��ł���Ƃ��A�������݂���v�f�ɃC���f�b�N�X�����āA���ʉ���}��܂��B
% x��������̃Z���z��łȂ��ꍇ�Astrind�͉���������y=x��Ԃ��܂��B
%
% (��)
% x   = {'max','min','max'};
% y   = strind(x)

% parse x
if(~iscell(x))
    y   = x;
    return;
else
    nx  = length(x);
    add_flag    = false(size(x));
    for ix=1:nx
        add_flag(ix)    = ischar(x{ix});
    end
    if(~all(add_flag))
        y   = x;
        return;
    end
end

nx  = length(x);
y   = cell(size(x));

for ix=1:nx
    me      = x{ix};
    others  = x;others(ix)  = [];
    if(any(ismember(me,others)))
        y{ix}   = [x{ix},'(',num2str(ix),')'];
    else
        y{ix}   = x{ix};
    end
end
end
