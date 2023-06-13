function XX = hist_btc(x,vector)

X	= histc(x,vector);

Y   = repmat([250:500:5500]',1,size(x,2));
keyboard
sumX    = repmat(sum(X,2),1,size(x,2));
pctX    = X./sumX*100;
figure
subplot(2,1,1)
bar(Y,X,'stack');
subplot(2,1,2)
bar(Y,pctX,'stack')


if nargout>0
    XX  =X;
end