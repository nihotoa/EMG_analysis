function [avezcohe,freq]  = cohmontecarlo(L,N)
% L   =[344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344, 344];


for jj=1:N
for ii=1:length(L)
    
randn('state',sum(100*clock))
simdata1    = randn(256, L(ii));
simdata2    = randn(256, L(ii));

[f,cl]      = ftsp2_fnb(simdata1 ,simdata2, 250, L(ii), 256, 1, 0, 1);
zcohe(:,ii) = zcoh(f(:,4),L(ii));

% keyboard
end


sumzcohe        = sum(zcohe,2);
avezcohe(:,jj)  = sumzcohe / sqrt(size(zcohe,2));
indicator(jj,N)
end



freq        = f(:,1);
% figure
% hold on
% plot(freq,zcohe,'b-')
% plot(freq,avezcohe,'k-')
