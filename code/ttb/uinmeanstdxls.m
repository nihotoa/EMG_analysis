function uinmeanstdxls

xlsload(-1,'Data');

[YN,nn] = size(Data);
Ymean   = mean(Data,1);
Ystd    = std(Data,0,1);

str     = [];

for ii=1:nn
    str     = [str,sprintf('%d\t%f\t%f\n',YN,Ymean(ii),Ystd(ii))];
end
clipboard('copy',str)
disp(str)


