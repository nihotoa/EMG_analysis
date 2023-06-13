function stats   = regplot(x,y,linespec)


if isempty(linespec)
    linespec    = '-r'
end

nPts    = length(x);

[A,S]   = polyfit(x,y,1);
fy  = polyval(A,x);
[r,p]   = corr(x,y);
tau     = A(1)*1000/2/pi;   % constant delay of channel X from channels Y (ms) negative value indicate chanX precede chanY

string  = {[' n =',num2str(nPts),' points'];[' y =',num2str(A(1)),'x + ',num2str(A(2))];[' \itR\rm =',num2str(r),', \itp\rm =',num2str(p)];[' \tau =',num2str(tau),' (ms)']};


if nargout == 0
    isholdoff	= ~ishold;
    hold('on')
    
    h  = text(max(x),max(y),string);
    set(h,'BackgroundColor',[1.0000    1.0000    0.7686],...
        'EdgeColor',[0 0 0]);

    h    = plot([x(1) x(end)],[fy(1) fy(end)],linespec);
    
    if(isholdoff)
        hold('off')
    end
else
    stats.R = r;
    stats.p = p;
    stats.A = A;
    stats.tau   = tau; % if x is frequency (Hz) and y is angular [rad]
end