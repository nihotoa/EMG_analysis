%% set file name and so on
monkeyname = 'F' ; 
xpdate = '180928'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2:4];
selECoGs = [1:64];
a = cummax(selECoGs,'reverse');
ECoG_num = a(1,1);

%% create All Data matrix
get_first_data = 1;
for i = 1:length(file_num)
    for j = 1:length(selECoGs)
        load([monkeyname xpdate '-' sprintf('%04d',i+1) '.mat'],['CRAW_0' sprintf('%02d',j)]);
        if get_first_data
            load([monkeyname xpdate '-' sprintf('%04d',i+1)],'CRAW_001_KHz');
            ECoG_Hz = CRAW_001_KHz .* 1000;
            Data_num = length(CRAW_001);
            AllData1 = zeros(Data_num, ECoG_num);
            AllData1(:,1) = CRAW_001';
            get_first_data = 0;
        else
            load([monkeyname xpdate '-' sprintf('%04d',i+1)],['CRAW_0' sprintf('%02d',j)]);
            eval(['AllData1(:, j ) = CRAW_0' sprintf('%02d',j) ''';']);
        end
    end
    if i == 1
        AllData = AllData1;
    else
        AllData = [AllData; AllData1];
        %cell2mat(AllData);
    end
    get_first_data = 1;
end

%plot(AllData(:,10)');

%%
%plot
load([monkeyname xpdate '-0002.mat'], 'CInPort_001*');
load([monkeyname xpdate '-0002.mat'],'CRAW_001_KHz');
load([monkeyname xpdate '-0002.mat'],'CRAW_001_TimeBegin');
Timing = CInPort_001(1,find(CInPort_001(2,:)==1104))-CRAW_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!
Timing = floor(Timing/(CInPort_001_KHz/CRAW_001_KHz));
load([monkeyname xpdate '-0003.mat'], 'CInPort_001*');


pullData = zeros(22001,length(Timing));
x =  11001;
y = -0.25:0.01:0.25;

for j = 1:16
    for i=1:length(Timing)
        pullData(:,i) = AllData(Timing(1,i)-11000:Timing(1,i)+11000,j);
    end

    ave = zeros(length(pullData(:,1)),1);
    
    for i=1:length(Timing)
        subplot(4,4,j); plot(pullData(:,i),'Color',[0,0,0]);
        hold on;
        ave = (ave .* (i-1)) + pullData(:,i);
    end
end
%plot(ave,'r');