function [y,x]  = strind(x)

% y  = strind(x)
% xが文字列のセル配列であるとき、複数存在する要素にインデックスをつけて、差別化を図ります。
% xが文字列のセル配列でない場合、strindは何もせずにy=xを返します。
%
% (例)
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
