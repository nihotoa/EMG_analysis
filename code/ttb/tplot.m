function tplot(flname)
tscale		= (-100:0.5:400-0.5);
a	=load(flname);
%figure;
plot(tscale,a(:,1),'k','LineWidth',1.5)

