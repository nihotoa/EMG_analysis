cd ../
%% name set

%file info
monkeyname = 'Wa' ; 
xpdate = '181019'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [2:3];
map = [9,23,24,26,2,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]; 
%EMG set
selECoGs=[1:32];
ECoG_num = 4;
CRAW = 1;
CLFP = 0;
trig = 3;
rangeF_ms = 750; %how long do you want to see former part of trigger[msec] 
rangeL_ms = 750; %how long do you want to see latter part of trigger[msec]

%trig to trig plot
trig_2 = [3 4]; %1:plot obj1 start timing, 
                %2:plot obj1 end timing, 
                %3:plot obj2 start timing, 
                %4:plot obj2 end timing, 
range_normalize = 500;%normalize range of task[msec] 
%% create All Data matrix (CRAW)

if CRAW == 1
    get_first_data = 1;
    for i = 1:length(file_num)
        for j = 1:ECoG_num
            load([monkeyname xpdate '-' sprintf('%04d',i+1) '.mat'],['CRAW_0' sprintf('%02d',map(j))]);
            if get_first_data
                load([monkeyname xpdate '-' sprintf('%04d',i+1)],'CRAW_001*');
                ECoG_Hz = CRAW_001_KHz .* 1000;
                Data_num = length(CRAW_001);
                AllECoGData1 = zeros(Data_num, ECoG_num);
                AllECoGData1(:,1) = CRAW_001';
                get_first_data = 0;
            else
                load([monkeyname xpdate '-' sprintf('%04d',i+1)],['CRAW_0' sprintf('%02d',j)]);
                eval(['AllECoGData1(:, j ) = CRAW_0' sprintf('%02d',j) ''';']);
            end
        end
        if i == 1
            AllECoGData = AllECoGData1;
        else
            AllECoGData = [AllECoGData; AllECoGData1];
            %cell2mat(AllECoGData);
        end
        get_first_data = 1;
    end
end

%% corr
AllECoGData_Corr = zeros(length(AllECoGData(1,:)),length(All_T(1,:)));
for i = 1:ECoG_num
    AllECoGData_Corr(i,:) = resample(AllECoGData(:,i),length(All_T(1,:)),length(AllECoGData(:,1)))';
end
CO = cell(length(All_T(:,1)),length(AllECoGData_Corr(:,1)));
for i=1:length(All_T(:,1))
    for j=1:length(AllECoGData_Corr(:,1))
        CO_ij = corrcoef([All_T(i,:)' AllECoGData_Corr(j,:)']);
        CO{i,j} = CO_ij(1,2);
    end
end
