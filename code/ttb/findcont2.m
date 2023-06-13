function y  = findcont2(x,kk,nn)
[x,nshift]  = shiftdim(x);

% x   = [1 1 1 0 0 1 1 1 1 0];
% k   = 3;
% n   = 5;


nx      = length(x);


% ortho
tempy   = false(nx,nx-nn+1);
for ii  =1:nx-nn+1
    sind    = [ii:ii+nn-1];
    sx      = x(sind);
    stempy  = tempy(sind,:);
%     if(sum(double(sx))>=kk && (sx(1) || any(stempy(1,:))) && sx(end))
            if(sum(double(sx))>=kk && (sx(1) || any(stempy(1,:))))
        tempy(sind,ii) = 1;
            end
    indicator(ii,nx-nn+1)
end
y1  = any(tempy,2);


% anti
x   = x(end:-1:1);
tempy   = false(nx,nx-nn+1);
for ii  =1:nx-nn+1
    sind    = [ii:ii+nn-1];
    sx      = x(sind);
    stempy  = tempy(sind,:);
%     if(sum(double(sx))>=kk && (sx(1) || any(stempy(1,:))) && sx(end)) %#ok<AND2>
            if(sum(double(sx))>=kk && (sx(1) || any(stempy(1,:)))) %#ok<AND2>
        tempy(sind,ii) = 1;
            end
        indicator(ii,nx-nn+1)
end
y2  = any(tempy,2);
y2  = y2(end:-1:1);




% ÅŒã‚Éortho‚Æanti‚ğ‚Ü‚Æ‚ß‚é
y   = (y1 & y2);

y   =shiftdim(y,-nshift);

        