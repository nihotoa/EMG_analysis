n=1000000;
close all
figure
hold on
for ii=1:100
    disp(ii)
a=rand(1,n);b=rand(1,n);t=a+i*b;
% plot(t(abs(t)>1),'bo','Markersize',2);
% plot(t(abs(t)<=1),'ro','Markersize',2);axis square
p(ii)=  sum(abs(t)<=1)*4/n;
end
hold off
figure
hist(p)
disp(mean(p))
