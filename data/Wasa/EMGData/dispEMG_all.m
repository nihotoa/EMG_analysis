
monkeyname = 'Wa';

%EMG sec
selEMGs=[1:14];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
EMGs=cell(14,1) ;
EMGs{1,1}= 'Delt';
EMGs{2,1}= 'Biceps';
EMGs{3,1}= 'Triceps';
EMGs{4,1}= 'BRD';
EMGs{5,1}= 'cuff';
EMGs{6,1}= 'ED23';
EMGs{7,1}= 'ED45';
EMGs{8,1}= 'ECR';
EMGs{9,1}= 'ECU';
EMGs{10,1}= 'EDC';
EMGs{11,1}= 'FDS';
EMGs{12,1}= 'FDP';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FCR';
a = cummax(selEMGs,'reverse');
EMG_num = a(1,1);

data_fold = 'new_nmf_result';

range_n = 201;

days = [...
        180925; ...
        180926; ...
        180927; ...
        180928; ...
        181001; ...
        181002; ...
        181003; ...
        181004; ...
        181010; ...
        181019; ...
        181022; ...
        181025; ...
        181030; ...
        181031; ...
        181101; ...
        181108; ...
        181109; ...
        181112; ...
        181114; ...
        181115; ...
        181116; ...
        181121; ...
        181122; ...
        181126; ...
        181127; ...
        181130; ...
        181207; ...
        181210; ...
        181220; ...
        181225; ...
        181227];
Ld = length(days);

f = figure('Position',[300,0,1300,900]);
p = uipanel('Parent',f,'BorderType','none');
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';
p.Title = ['Wa EMG' sprintf('%d',days(1)) 'to' sprintf('%d',days(end))];
co = jet(Ld);
x = linspace(-1000,1000,range_n);
for ii=1:Ld
    cd([monkeyname sprintf('%d',days(ii))])
%     load([monkeyname sprintf('%d',days(ii)) '1to4p1500.mat'],'All_ave')
        load([monkeyname sprintf('%d',days(ii)) '_trig_3.mat'],'All_ave')
    cd ../
    for j=1:EMG_num
        subplot(4,4,j,'Parent',p);
        plot(x,All_ave(:,j),'Color',co(ii,:),'LineWidth',1.1);
%         plot(All_ave(:,j),'Color',[ii/Ld 0.3 1-ii/Ld],'LineWidth',1.1);
        hold on;
        plot([0 0],[0 100],'Color','k','Linewidth',1.3);
        xlim([-1000 1000]);
        ylim([0 100]);
        xlabel('obj1 start to obj end [%]');
        title(EMGs{j,1});
    end
end
% 
% T = cell(Ld,1);
% 
% cd ../
% cd(data_fold);
% for ii=1:Ld
%     cd([monkeyname sprintf('%d',days(ii))])
%     load([monkeyname sprintf('%d',days(ii)) '_SUC_Timing.mat'],SUC_Tim_per);
%     T{ii,1} = SUC_Tim_per;
%     cd ../
% end
% cd ../
% cd EMGData
% TA = cell2mat(T);