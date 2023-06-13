
tarfold = 'Suruku';
figure;
subplot(4,1,1);
plot(CEMG_007,'k')
hold on
for i = 1:length(CTTL_001_Down)-10
t_off =Tp(i,3)*11/5;
t_on =Tp(i,2)*11/5;
t_s =Tp(i,4)*11/5;
ph_d = CTTL_001_Down(i)./4;
ph_u = CTTL_001_Up(i)./4;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-400 400])
xlim([1000000 1500000])
title('EDC')
% 
% cd ../../
% cd nmf_result/Su200110
load('FDS-hp50Hz-lp1000Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat')

subplot(4,1,2);
plot(Data,'k')
hold on
for i = 1:length(CTTL_001_Down)-10
t_off =Tp(i,3)*1/50;
t_on =Tp(i,2)*1/50;
t_s =Tp(i,4)*1/50;
ph_d = CTTL_001_Down(i)./440;
ph_u = CTTL_001_Up(i)./440;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-50 100])
xlim([1000000/110 1500000/110])
title('EDC filtered')

subplot(4,1,3);
plot(CEMG_008,'k')
hold on
for i = 1:length(CTTL_001_Down)-10
t_off =Tp(i,3)*11/5;
t_on =Tp(i,2)*11/5;
t_s =Tp(i,4)*11/5;
ph_d = CTTL_001_Down(i)./4;
ph_u = CTTL_001_Up(i)./4;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-400 400])
xlim([1000000 1500000])
title('ED23')

load('FDP-hp50Hz-lp1000Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat')

subplot(4,1,4);
plot(Data,'k')
hold on
for i = 1:length(CTTL_001_Down)-10
t_off =Tp(i,3)*1/50;
t_on =Tp(i,2)*1/50;
t_s =Tp(i,4)*1/50;
ph_d = CTTL_001_Down(i)./440;
ph_u = CTTL_001_Up(i)./440;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-50 100])
xlim([1000000/110 1500000/110])
title('ED23 filtered')