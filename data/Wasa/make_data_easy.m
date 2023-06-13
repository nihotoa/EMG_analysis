%% set file name and so on
monkeyname = 'Wa' ; 
real_name = 'Wasa';
xpdate = '181018'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
file_num = [8:9]; %Alpha Omega
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
ECoG_num = 64;
wk = 2; %1:plot obj2 start timing, 2:plot stim timng
ECoGs = {'CH01', 'CH02', 'CH03', 'CH04', 'CH05', 'CH06', 'CH07', 'CH08', 'CH09', 'CH10', ...
             'CH11', 'CH12', 'CH13', 'CH14', 'CH15', 'CH16', 'CH17', 'CH18', 'CH19', 'CH20', ...
             'CH21', 'CH22', 'CH23', 'CH24', 'CH25', 'CH26', 'CH27', 'CH28', 'CH29', 'CH30', ...
             'CH31', 'CH32', 'CH33', 'CH34', 'CH35', 'CH36', 'CH37', 'CH38', 'CH39', 'CH40', ...
             'CH41', 'CH42', 'CH43', 'CH44', 'CH45', 'CH46', 'CH47', 'CH48', 'CH49', 'CH50', ...
             'CH51', 'CH52', 'CH53', 'CH54', 'CH55', 'CH56', 'CH57', 'CH58', 'CH59', 'CH60', ...
             'CH61', 'CH62', 'CH63', 'CH64', }';

%% create All Data matrix (EMG)
get_first_data = 1;
%AllEMGData = zeros(Data_num, EMG_num);
for i = file_num(1,1):file_num(1,length(file_num));
    for j = 1:length(selEMGs)
        load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
        if get_first_data
            load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001_KHz');
            EMG_Hz = CEMG_001_KHz .* 1000;
            Data_num = length(CEMG_001);
            AllEMGData1 = zeros(Data_num, EMG_num);
            AllEMGData1(:,1) = CEMG_001';
            get_first_data = 0;
        else
            load([monkeyname xpdate '-' sprintf('%04d',i)],['CEMG_0' sprintf('%02d',j)]);
            eval(['AllEMGData1(:, j ) = CEMG_0' sprintf('%02d',j) ''';']);
        end
    end
    if i == 1
        AllEMGData = AllEMGData1;
    else
        AllEMGData = [AllEMGData; AllEMGData1];
        %cell2mat(AllEMGData);
    end
    get_first_data = 1;
end

%% save EMG data as .mat file for nmf
Data = zeros(1, length(AllEMGData(:,1)));
load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CEMG_001*');
mkdir([real_name xpdate '_EMG_for_nmf']);

for i = 1:EMG_num
    TimeRange = [CEMG_001_TimeBegin, CEMG_001_TimeEnd];
    Name = cell2mat(EMGs(i,1));
    Class = 'continuous channel';
    SampleRate = CEMG_001_KHz * 1000;
    Data = AllEMGData(:, i)';
    Unit = 'uV';
    save([ cell2mat(EMGs(i,1)) '(uV).mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
end

%% create All Data matrix (ECoG)
get_first_data = 1;
for i = 1:length(file_num)
    for j = 1:ECoG_num
        load([monkeyname xpdate '-' sprintf('%04d',i+1) '.mat'],['CRAW_0' sprintf('%02d',j)]);
        if get_first_data
            load([monkeyname xpdate '-' sprintf('%04d',i+1)],'CRAW_001_KHz');
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
%% save ECoG data as .mat file for nmf
Data = zeros(1, length(AllECoGData(:,1)));
load([monkeyname xpdate '-0002'],'CRAW_001*');
mkdir([real_name xpdate '_ECoG_for_nmf']);
for i = 1:ECoG_num
    TimeRange = [CRAW_001_TimeBegin, CRAW_001_TimeEnd];
    Name = cell2mat(ECoGs(i,1));
    Class = 'continuous channel';
    SampleRate = CRAW_001_KHz * 1000;
    Data = AllECoGData(:, i)';
    Unit = 'uV';
    save([ cell2mat(ECoGs(i,1)) '(uV).mat'], 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
end