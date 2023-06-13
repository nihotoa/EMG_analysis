


sig = normpdf(-40:1/5:60,15,1.5);
sig = sig/max(sig);                 % ‚P‚É³‹K‰»

noise   = randn(10000,length(sig))*5;

xdata   = -40:1/5:60;

trialdata    = repmat(sig,10000,1) + noise;

ydata       = mean(trialdata,1);


for ii=50:50:10000;
    
    repdata(ii/50,:)    = mean(trialdata(1:ii,:),1);
    indicator(ii/50,10000/50)
end
% repdata(1,:)     = mean(trialdata(1:10,:),1);
% repdata(2,:)     = mean(trialdata(1:100,:),1);
% repdata(3,:)     = mean(trialdata(1:1000,:),1);
% repdata(4,:)     = mean(trialdata(1:10000,:),1);


indicator(0,0)