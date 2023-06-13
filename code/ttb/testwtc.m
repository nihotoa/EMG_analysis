for jj=10:10:80
    [y,x]=sinf(256,250,jj);
    for ii=1:10
        disp(ii)
        t1=y+rand(1,256)*0.5;
        t2=y+rand(1,256)*0.5;
        [Rsq(:,:,ii),period,scale]=wtc(t1,t2,'j1',floor(250./2));
    end
    freq    = 250./period;
    figure
    pcolor([1:256],freq,mean(Rsq,3))
    title(num2str(jj))
end