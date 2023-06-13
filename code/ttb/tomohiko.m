for ii=1:971
[y,i]=nearest(data2,data1(ii));
d(ii)=data1(ii)-y;
end