clear('allr2','r2slope','r2')

allr2=1;
a=0.2;
% b=0.09;

for ii=1:12
    r2slope(ii)=allr2*a;
    allr2=1-sum(r2slope);
end
 r2=cumsum(r2slope)