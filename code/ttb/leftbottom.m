function y  = leftbottom(n)


y   = zeros(n);
for xx  = 1:n
    for yy  = 1:n
        if(xx > yy)
            y(xx,yy) =1;
        end
    end
end