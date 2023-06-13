jj=0
for ii=[1,2,3,6,4,5]
    jj=jj+1;
    tdata   = a(ii).data;
    subplot(6,1,jj)
    plot(lags(and(lags>=15,lags<=40)),tdata(and(lags>=15,lags<=40)),'k','Linewidth',1)
    title(a(ii).ChanNames)
end