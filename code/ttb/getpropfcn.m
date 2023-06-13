function Y  = getpropfcn(S,opt)


% [maxd,maxind]   = max(abs(S.YData-S.pseSD1.base.mean));
[maxd,maxind]   = max(S.YData);


if(opt==1)
    
    Y   = S.YData(maxind);
else
    Y   = S.XData(maxind)*1000;
end
