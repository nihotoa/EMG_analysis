monkeyname = 'Se';

days = [...%pre-surgery
%         200117;...
%         200119;...
%         200120;...
        200210;...%post surgery
        200212;...
        200213;...
        200214;...
        200217;...
        200218;...
        200219;...
        200220;...
        200221;...
        200226;...
        200303;...
        200304;...
        200305;...
        200306;...
        200309;...
        200310;...
        200316;...
        200317;...
        200318;...
        200319;...
        200323;...
        200324;...
        200325;...
        200326;...
        200330;...
        ];

% days = [170703 170707 170711 170714 170720 170802 170824 170830 170907 170914 170925];
%   days = [170517 170524 170526 170529];
 group_num = 1;
 EMGgroups = ones(1,length(days)).* group_num;
 EMG_num = 9;
% days = [180928 181019];
% EMGgroups = [1,1];
% EMG_num = 12;
alg = 'r2';
c = jet(length(days));
VAFt =  cell(1,length(days));
VAFs =  cell(1,length(days));
th =  cell(1,length(days));

for i=1:length(days)
    [VAFt{i},VAFs{i},th{i}] = VAFdata([monkeyname mat2str(days(i))],EMGgroups(i),alg);
end
%% mean errorbar
figure;
x = 1:1:EMG_num;
errt = std(cell2mat(VAFt),1,2);
errs = std(cell2mat(VAFs),1,2);
VAFtm = mean(cell2mat(VAFt),2);
VAFsm = mean(cell2mat(VAFs),2);

e1 =errorbar(x,VAFtm,errt);
e1.Marker = 'o';
hold on;
e2 = errorbar(x,VAFsm,errs);
e2.Marker = 'o';
plot([0 EMG_num+1],[0.8 0.8],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.85 0.85],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.9 0.9],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.95 0.95],'Color',[0 0 0]);
plot([0 EMG_num+1],[1 1],'Color',[0 0 0]);
ylim([0 1.1])
title([monkeyname mat2str(days) '  VAFt  VAFs']);

%% each day plot

f1 = figure;
x = 1:1:EMG_num;
VAFte = cell2mat(VAFt);
VAFse = cell2mat(VAFs);
hold on;
for i=1:length(days)
    plot(VAFte(:,i),'-o','Color',c(i,:));
    plot(VAFse(:,i),'-o','Color',c(i,:));
end
xlim([1 EMG_num])
plot([0 EMG_num+1],[0.8 0.8],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.85 0.85],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.9 0.9],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.95 0.95],'Color',[0 0 0]);
plot([0 EMG_num+1],[1 1],'Color',[0 0 0]);
ylim([0 1.1])

title([monkeyname mat2str(days) '  VAFt  VAFs']);

%% plot each synergy
c1 = jet(EMG_num);
figure;
hold on;
for ii = 1:EMG_num
    plot(VAFte(ii,:),'-o','Color',c1(ii,:));
end
xlabel([sprintf('%d',length(days)) 'days(Post tendon transfer)']);
ylabel('VAF');