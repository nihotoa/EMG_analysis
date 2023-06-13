t=[0.25:0.5:11.75]*pi/6;
a=[220 150 80 50 0 0 0 0 0 0 0 0 0 0 0 0 80 120 190 270 260 240 295 250];
A=[];
for ii=1:24
    A=[A,ones(1,a(ii))*t(ii)];
end

figure
h   = rose(A,24);


x=mean(cos(A));
y=mean(sin(A));
cmean   = x+i*y;

meanA   = angle(cmean)+2*pi;
hold on
compass(cmean/abs(cmean)*300,'r');


