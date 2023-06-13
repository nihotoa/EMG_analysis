YData   = [];
XData   = [];
maxii   = length(ticktimes);



nn  = 0;
for(ii=2:maxii)
    
    
    if(data(3,ii-1)<4 & data(3,ii)>4)
        nn  = nn + 1; 
        YData(nn,:) = data(2,ii-200:ii+400);
        XData       = ticktimes(ii-200:ii+400)-ticktimes(ii);
        disp(nn)
        indicator(nn,108)
    end
end
    