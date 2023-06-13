monkeyname = 'Wa';
 days = [180925 180926 180927 180928 181002 181019 181022 181025 181101 181108 181109 181112 181114 181121 181122 181126 181127];
 group_num = 5;
 EMGgroups = ones(1,length(days)).* group_num;
 EMG_num = 11;
% days = [180928 181019];
% EMGgroups = [1,1];
% EMG_num = 12;
alg = 'r2';

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

figure;
x = 1:1:EMG_num;
VAFte = cell2mat(VAFt);
VAFse = cell2mat(VAFs);
hold on;
for i=1:length(days)
    plot(VAFte(:,i),'-o');
    plot(VAFse(:,i),'-o');
end
plot([0 EMG_num+1],[0.8 0.8],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.85 0.85],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.9 0.9],'Color',[0 0 0]);
plot([0 EMG_num+1],[0.95 0.95],'Color',[0 0 0]);
plot([0 EMG_num+1],[1 1],'Color',[0 0 0]);
ylim([0 1.1])
title([monkeyname mat2str(days) '  VAFt  VAFs']);