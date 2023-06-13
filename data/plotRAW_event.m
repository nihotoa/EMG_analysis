
% first please load target RAW AO file ex)load('Su200108-0002.mat')
% %%%%%%%%%%%% Suruku %%%%%%%%%%%%%%
% tarfold = 'Suruku';
% monkeyname = 'Su';
% xpdate = '200120';
% EMGs = {'FDS','FDP','FCR','FCU','PL','BRD','EDC','ED23','ED45','ECU','ECR','Deltoid'};
% % EMGs = {'EDC','ED23','ED45'};
%%%%%%%%%%%% Seseki %%%%%%%%%%%%%%
tarfold = 'SesekiL';
task = 'standard';
monkeyname = 'Se';
xpdate = '200120';
EMGs = {'EDC','ED23','ED45','ECU','ECR','Deltoid','FDS','FDP','FCR','FCU','PL','BRD'};

cd(tarfold)
load([monkeyname xpdate '-0005.mat'])
cd(['easyData/' monkeyname xpdate '_' task])
load([monkeyname xpdate '_easyData.mat'],'Tp','TTLd','TTLu')
cd ../../nmf_result
cd([monkeyname xpdate '_' task])
black = 'k';

% % TTL_lag = (CTTL_001_TimeBegin - CEMG_001_TimeBegin)*11000;

TTL_num =0; %initial value

for m = 1:length(EMGs)
f = figure;
subplot(3,1,1);
eval(['plot(CEMG_' sprintf('%03d',m) ',black)']);
hold on
for i = 1:length(CTTL_001_Down)-14
t_off =Tp(i,3)*11/5;
t_on =Tp(i,2)*11/5;
t_s =Tp(i,4)*11/5;

% % ph_d = CTTL_001_Down(i)./4 + TTL_lag;
% % ph_u = CTTL_001_Up(i)./4 + TTL_lag;
% ph_d = TTLd(i)/50;
% ph_u = TTLu(i)/50;
ph_d = min(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,6)))))*11/5;
ph_u = max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,6)))))*11/5;
if ~isempty(ph_d)
   if ~isempty(ph_u)
      TTL_num = TTL_num+1;
      plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
      plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
   end
end
   
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)

% plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
% plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-400 400])
xlim([1000000 1100000])
title(EMGs{m})


load([ EMGs{m} '-medC-hp50Hz-lp1000Hz.mat'])

subplot(3,1,2);
plot(Data,'k')
hold on
for i = 1:length(CTTL_001_Down)-14
t_off =Tp(i,3);
t_on =Tp(i,2);
t_s =Tp(i,4);
% ph_d = CTTL_001_Down(i)./440  + TTL_lag/110;
% ph_u = CTTL_001_Up(i)./440 + TTL_lag/110;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
% ph_d = TTLd(i)/50;
% ph_u = TTLu(i)/50;
ph_d = min(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,6)))));
ph_u = max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,6)))));
if ~isempty(ph_d)
   if ~isempty(ph_u)
      TTL_num = TTL_num+1;
      plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
      plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
   end
end
% plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
% plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-50 200])
xlim([(1000000/110)*50 (1100000/110)*50])
title([EMGs{m} ' filtered'])

load([ EMGs{m} '-hp50Hz-rect-lp20Hz-ds100Hz.mat'])

subplot(3,1,3);
plot(Data,'k')
hold on
for i = 1:length(CTTL_001_Down)-14
t_off =Tp(i,3)*1/50;
t_on =Tp(i,2)*1/50;
t_s =Tp(i,4)*1/50;
% ph_d = CTTL_001_Down(i)./440  + TTL_lag/110;
% ph_u = CTTL_001_Up(i)./440 + TTL_lag/110;
plot([t_off t_off],[-1000 1000],'r','LineWidth',1.1)
plot([t_on t_on],[-1000 1000],'b','LineWidth',1.1)
plot([t_s t_s],[-1000 1000],'g','LineWidth',1.1)
% ph_d = TTLd(i)/50;
% ph_u = TTLu(i)/50;
ph_d = min(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,6)))))/50;
ph_u = max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,6)))))/50;
if ~isempty(ph_d)
   if ~isempty(ph_u)
      TTL_num = TTL_num+1;
      plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
      plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
   end
end
% plot([ph_d ph_d],[-1000 1000],'m','LineWidth',1.1)
% plot([ph_u ph_u],[-1000 1000],'c','LineWidth',1.1)
end
ylim([-50 200])
xlim([1000000/110 1100000/110])
title([EMGs{m} ' filtered'])
% saveas(f,[EMGs{m} '.fig'])
end
