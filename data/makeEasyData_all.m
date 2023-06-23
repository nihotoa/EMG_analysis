%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by Naoki Uchida
% last modification : 2021.03.23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EMGs,ECoGs,Tp,Tp3] = makeEasyData_all(monkeyname, xpdate_num, file_num, save_fold)
%% set file information

make_EMG = 1; %0/1 means no/yes
%  save_EMG = 1; %0/1 means no/yes
make_ECoG = 0; %0/1 means no/yes
save_E = 1; %0/1 means no/yes
down_E = 1; %0/1 means no/yes(whether you want to do resampling)
%dawnsampling from 11kHz to 5000Hz
make_Timing = 1;%make
downdata_to = 5000; %(if down_E ==1)sampling rate of after resampling

save_mode = 'all_data';
global task;
switch monkeyname
    case 'Wa'
        real_name = 'Wasa';
    case 'Ya'
        real_name = 'Yachimun';
    case 'F'
        real_name = 'Nibali';
    case 'Ma'
        real_name = 'Matatabi';
    case 'Sa'
        real_name = 'Sakiika';
    case 'Su'
        real_name = 'Suruku';
        timing_photo = 1;
    case 'Se'
        %real_name = 'SesekiL';
        real_name = 'SesekiR';
        timing_photo = 1;
%         arm = 'L';
end

xpdate = sprintf('%d',xpdate_num);
cd(real_name)
cd(save_fold)
if not(exist([monkeyname xpdate '_' task]))
    mkdir([monkeyname xpdate '_' task]);
end
cd ../
disp(['START TO MAKE & SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
%EMG set
switch monkeyname
    case 'Wa'%Wasa
        selEMGs=1:14;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
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
    case 'Ya'%Yachimun
        selEMGs=1:12;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'FDP';
        EMGs{2,1}= 'FDSprox';
        EMGs{3,1}= 'FDSdist';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'FCR';
        EMGs{7,1}= 'BRD';
        EMGs{8,1}= 'ECR';
        EMGs{9,1}= 'EDCprox';
        EMGs{10,1}= 'EDCdist';
        EMGs{11,1}= 'ED23';
        EMGs{12,1}= 'ECU';
        a = cummax(selEMGs,'reverse');
        EMG_num = a(1,1);
        make_ECoG = 0;
    case 'F'%Nibali
        selEMGs=1:3;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(3,3) ;
        EMGs{1,1}= 'FDS';
        EMGs{2,1}= 'PL';
        EMGs{3,1}= 'EPL';
        a = cummax(selEMGs,'reverse');
        EMG_num = a(1,1);
        make_ECoG = 0;
    case 'Su'%Suruku
        selEMGs=1:12;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'FDS';
        EMGs{2,1}= 'FDP';
        EMGs{3,1}= 'FCR';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'BRD';
        EMGs{7,1}= 'EDC';
        EMGs{8,1}= 'ED23';
        EMGs{9,1}= 'ED45';
        EMGs{10,1}= 'ECU';
        EMGs{11,1}= 'ECR';
        EMGs{12,1}= 'Deltoid';
        a = cummax(selEMGs,'reverse');
        EMG_num = a(1,1);
        make_ECoG = 0;
   case 'Se'%Seseki
        selEMGs=1:12;%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,3) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
        a = cummax(selEMGs,'reverse');
        EMG_num = a(1,1);
        make_ECoG = 0;
        arm = 'R';
        if exist('arm')
           for m = 1:12
              EMGs{m}=[EMGs{m} '_' arm];
           end
        end
    case 'Ma'
        Mn = 8;
        selEMGs=1:Mn;
        EMGs=cell(Mn,1) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ECR';
        EMGs{3,1}= 'BRD_1';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'FCR';
        EMGs{6,1}= 'BRD_2';
        if Mn == 8
           EMGs{7,1}= 'FDPr';
           EMGs{8,1}= 'FDPu';
        end
        a = cummax(selEMGs,'reverse');
        EMG_num = a(1,1);
        make_ECoG = 0;
end

%ECoG set (Wasa,Sakiika)
Mo = strcmp(monkeyname, 'Wa') + strcmp(monkeyname, 'Sa');
if Mo
    selECoGs=(1:64);
    ECoGs = {'CLFP_001';'CLFP_002';'CLFP_003';'CLFP_004';'CLFP_005';'CLFP_006';'CLFP_007';'CLFP_008';'CLFP_009';'CLFP_010';...
             'CLFP_011';'CLFP_012';'CLFP_013';'CLFP_014';'CLFP_015';'CLFP_016';'CLFP_017';'CLFP_018';'CLFP_019';'CLFP_020';...
             'CLFP_021';'CLFP_022';'CLFP_023';'CLFP_024';'CLFP_025';'CLFP_026';'CLFP_027';'CLFP_028';'CLFP_029';'CLFP_030';...
             'CLFP_031';'CLFP_032';'CLFP_033';'CLFP_034';'CLFP_035';'CLFP_036';'CLFP_037';'CLFP_038';'CLFP_039';'CLFP_040';...
             'CLFP_041';'CLFP_042';'CLFP_043';'CLFP_044';'CLFP_045';'CLFP_046';'CLFP_047';'CLFP_048';'CLFP_049';'CLFP_050';...
             'CLFP_051';'CLFP_052';'CLFP_053';'CLFP_054';'CLFP_055';'CLFP_056';'CLFP_057';'CLFP_058';'CLFP_059';'CLFP_060';...
             'CLFP_061';'CLFP_062';'CLFP_063';'CLFP_064'};
    ECoG_num = length(ECoGs);
else
    ECoGs = cell(0);
end

%% create EMG All Data matrix
if make_EMG == 1
    [AllData_EMG, TimeRange_EMG, EMG_Hz] = makeEasyEMG(monkeyname,xpdate,file_num, selEMGs);
end
%% down data
if down_E == 1
   AllData_EMG = resample(AllData_EMG,downdata_to,EMG_Hz);
end
%% create ECoG All Data matrix
if make_ECoG ==1
    [AllData_ECoG, TimeRange_ECoG, ECoG_Hz] = makeEasyECoG(monkeyname, xpdate, file_num, selECoGs);
end

%% cut  data on task timing

if make_Timing == 1
   switch monkeyname
      case {'Su','Se'}
         [AllInPort,Timing,Tp,Tp3,TTLd,TTLu] = makeEasyTiming(monkeyname,xpdate,file_num,downdata_to,TimeRange_EMG);
         [Ahoge,Timing_L,Tp_L,Tp3_L,TTLd_L,TTLu_L] = makeEasyTiming(monkeyname,xpdate,file_num,1375,TimeRange_EMG);
         % change tiing from lever2 to photocell
         % 上に書いてあるように,lever2のオン、オフをphotocellのオンオフタイミングに変更する
         if timing_photo == 1 %SesekiRを選んだならこの変数は1になっている
             errorlist = '';
             emp_d = 0;
             emp_u = 0;
             ph_d = zeros(length(Tp),1); % photo down clock = Photo On
             ph_u = zeros(length(Tp),1); % photo up clock = Photo Off
             for i = 1:length(Tp)
                if isempty(max(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,5))))))
                    emp_d = 1;
                else
                    ph_d(i) = min(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,5)))));
                end
                if isempty(max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,5))))))
                    emp_u = 1;
                else
                    ph_u(i) = max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,5)))));
                end
                if ph_d(i)>ph_u(i) || emp_d == 1 || emp_u ==1
                    errorlist = [errorlist ' ' sprintf('%d',i)];
                    emp_d = 0;
                    emp_u = 0;
                end
                Tp(i,4) = ph_d(i);
                Tp(i,5) = ph_u(i); %タイミング4と5をフォトオンとフォトオフのタイミングに変更する
             end
             if isempty(errorlist)
             else ER = str2num(errorlist);
                 for ii = flip(ER)
                     Tp(ii,:) = [];
                 end
             end
         end
       case 'F'
           
       otherwise %if reference monkey is not SesekiR or Wasa、（if you don't have to chage to fotocell）
         [AllInPort,Timing,Tp,Tp3] = makeEasyTiming(monkeyname,xpdate,file_num,downdata_to,TimeRange_EMG);
         % ↓downdata_to parameter is changed 1375
         [Ahoge,Timing_L,Tp_L,Tp3_L] = makeEasyTiming(monkeyname,xpdate,file_num,1375,TimeRange_EMG);
   end
end

%% get data for Cross-Talk check (getCTcheck)
Si = size(Tp);
CTcheck.data0 = cell(1,Si(1));
% CTcheck.data1 = cell(1,Si(1));
% CTcheck.data2 = cell(1,Si(1));
CTcheck.data3 = cell(1,Si(1));
for n = 1:Si(1)
    [crossData,dt1,dt2,dt3] = getCTcheck(AllData_EMG,Tp,selEMGs,EMG_Hz,n);
    CTcheck.data0{n} = crossData;
%     CTcheck.data1{n} = dt1;
%     CTcheck.data2{n} = dt2;
    CTcheck.data3{n} = dt3; %DATA0は未処理のデータData1は1回処理・・・
end
%% save data
if save_E == 1
   switch save_mode
       case 'all_data'
            cd(save_fold)
            cd([monkeyname xpdate '_' task]) 
   %                  Name = cell2mat(EMGs(i,1));
   %                  Class = 'continuous channel';
                    Unit = 'uV';
                    SampleRate = downdata_to;
                    switch monkeyname
                        case 'Wa'
                            save([monkeyname xpdate '_EasyData.mat'], 'monkeyname', 'xpdate', 'file_num','EMGs', ...
                                                                    'AllData_EMG', 'AllData_ECoG', ...
                                                                    'TimeRange_EMG', 'TimeRange_ECoG', ...
                                                                    'EMG_Hz', 'ECoG_Hz', ...'Name', 'Class',...
                                                                    'Unit','SampleRate',...'AllInPort',
                                                                    'Timing','Tp','Tp3',...
                                                                    'Timing_L','Tp_L','Tp3_L');
                            save([monkeyname xpdate '_CTcheckData.mat'],'CTcheck');
                        case {'Ya','Ma','F'}
                            save([monkeyname xpdate '_EasyData.mat'], 'monkeyname', 'xpdate', 'file_num', 'EMGs',...
                                                                    'AllData_EMG', ...'AllData_ECoG', ...
                                                                    'TimeRange_EMG',...% 'TimeRange_ECoG', ...
                                                                    'EMG_Hz',... 'ECoG_Hz', ...'Name', 'Class',...
                                                                    'Unit','SampleRate',...'AllInPort',
                                                                    'Timing','Tp','Tp3');
                            save([monkeyname xpdate '_CTcheckData.mat'],'CTcheck');
                       case {'Su','Se'}
                            save([monkeyname xpdate '_EasyData.mat'], 'monkeyname', 'xpdate', 'file_num', 'EMGs',...
                                                                    'AllData_EMG', ...'AllData_ECoG', ...
                                                                    'TimeRange_EMG',...% 'TimeRange_ECoG', ...
                                                                    'EMG_Hz',... 'ECoG_Hz', ...'Name', 'Class',...
                                                                    'Unit','SampleRate',...'AllInPort',
                                                                    'Timing','Tp','Tp3','TTLd','TTLu');
                            save([monkeyname xpdate '_CTcheckData.mat'],'CTcheck');
                    end
            cd ../../../
         disp(['FINISH TO MAKE & SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
      otherwise
         disp(['FINISH TO MAKE BUT NOT SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
   end
else
   cd(save_fold)
   cd([monkeyname xpdate '_' task]) 
   cd ../../../
   disp(['NOT SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
end
end
%-------------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------
function [AllData_EMG, TimeRange, EMG_Hz] = makeEasyEMG(monkeyname, xpdate, file_num, selEMGs)
Ld = length(file_num);
a = cummax(selEMGs,'reverse');
EMG_num = a(1,1);
AllData_EMG_sel = cell(Ld,1);

try
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CEMG_001_TimeBegin');
    TimeRange = zeros(1,2);
    TimeRange(1,1) = CEMG_001_TimeBegin;
    EMG_prefix = 'CEMG';
catch
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CRAW_001_TimeBegin');
    TimeRange = zeros(1,2);
    TimeRange(1,1) = CRAW_001_TimeBegin;
    EMG_prefix = 'CRAW';
end
get_first_data = 1;
for i = file_num(1,1):file_num(1,Ld)
    for j = 1:length(selEMGs)
%         S = load([monkeyname xpdate '-' sprintf('%04d',i) '.mat'],['CEMG_0' sprintf('%02d',j)]);
        if get_first_data
            S1 = load([monkeyname xpdate '-' sprintf('%04d',i)],[EMG_prefix '_001*']);
            EMG_Hz = eval(['S1.' EMG_prefix '_001_KHz .* 1000;']);
            Data_num_EMG = eval(['length(S1.' EMG_prefix '_001);']);
            AllData1_EMG = zeros(Data_num_EMG, EMG_num);
            AllData1_EMG(:,1) = eval(['S1.' EMG_prefix '_001;']);
            get_first_data = 0;
        else
            S = load([monkeyname xpdate '-' sprintf('%04d',i)],[EMG_prefix '_0' sprintf('%02d',j)]);
            eval(['AllData1_EMG(:, j ) = S.' EMG_prefix '_0' sprintf('%02d',j) ''';']);
        end
    end
    AllData_EMG_sel{1+i-file_num(1,1),1} = AllData1_EMG;
    Se = load([monkeyname xpdate '-' sprintf('%04d',i)],[EMG_prefix '_001_TimeEnd']);
    TimeRange(1,2) = eval(['Se.' EMG_prefix '_001_TimeEnd;']);
    get_first_data = 1;
end
AllData_EMG = cell2mat(AllData_EMG_sel);
end
%-------------------------------------------------------------------------------------------------
function [AllData_ECoG, TimeRange, ECoG_Hz] = makeEasyECoG(monkeyname, xpdate, file_num, selECoGs)
Ld = length(file_num);
a = cummax(selECoGs,'reverse');
ECoG_num = a(1,1);
AllData_ECoG_sel = cell(Ld,1);
    load([monkeyname xpdate '-' sprintf('%04d',file_num(1,1))],'CLFP_001_TimeBegin');
    TimeRange = zeros(1,2);
    TimeRange(1,1) = CLFP_001_TimeBegin;
    get_first_data = 1;
    %↓ここが違う
    for i = file_num(1,1):file_num(1,Ld)
        for j = 1:length(selECoGs)
            if get_first_data
                S1 = load([monkeyname xpdate '-' sprintf('%04d',i)],'CLFP_001*');
                ECoG_Hz = S1.CLFP_001_KHz .* 1000;
                Data_num_ECoG = length(S1.CLFP_001);
                AllData1_ECoG = zeros(Data_num_ECoG, ECoG_num);
                AllData1_ECoG(:,1) = S1.CLFP_001';
                get_first_data = 0;
            else
                S = load([monkeyname xpdate '-' sprintf('%04d',i)],['CLFP_0' sprintf('%02d',j)]);
                eval(['AllData1_ECoG(:, j ) = S.CLFP_0' sprintf('%02d',j) ''';']);
            end
        end
        AllData_ECoG_sel{1+i-file_num(1,1),1} = AllData1_ECoG;
        Se = load([monkeyname xpdate '-' sprintf('%04d',i)],'CEMG_001_TimeEnd');
        TimeRange(1,2) = Se.CEMG_001_TimeEnd;
        get_first_data = 1;
     end
     AllData_ECoG = cell2mat(AllData_ECoG_sel);
end
%         if i == file_num(1,1)
%             AllData_ECoG_sel{1,1} = AllData1_ECoG;
%         else
%             AllData_ECoG_sel{1+i-file_num(1,1),1} = AllData1_ECoG;
%         end
%         Se = load([monkeyname xpdate '-' sprintf('%04d',i)],'CLFP_001_TimeEnd');
%         TimeRange(1,2) = Se.CLFP_001_TimeEnd;
%         get_first_data = 1;
%      end
%      AllData_ECoG = cell2mat(AllData_ECoG_sel);
% end
%-------------------------------------------------------------------------------------------------
function [AllInPort,Timing,Tp,Tp3,varargout] = makeEasyTiming(monkeyname, xpdate, file_num, SampleRate, TimeRange_EMG)
Ld = file_num(end)-file_num(1)+1;
%number of file
AllInPort_sel = cell(1,Ld);
get_first_portin = 1;
for i = file_num(1,1):file_num(1,end)
    if get_first_portin
        S1 = load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort*');
        CInPort = S1.CInPort_001;
    else
        
        S = load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort_001');
        if ~isempty(struct2cell(S))
           CInPort = S.CInPort_001;
        end
    end
    AllInPort_sel{1,1+i-file_num(1,1)} = CInPort;
    get_first_portin = 0;
end
AllInPort = cell2mat(AllInPort_sel);

%%%%%% attributes codes easier to read to the main events of the task%%%%%
switch monkeyname
    case {'Wa','Su','Se'}
        event_ID=AllInPort(2,:); % ID of the codes
        event_t=AllInPort(1,:) ; % timing of the codes

        % trial outcome codes: last code of a trial
        event_ID(event_ID==1345)=38;   % WRONG_TRIAL_ORDER
        event_ID(event_ID==1024)=0;    % success !
        event_ID(event_ID==256)=1;    % failed: trial never started
        event_ID(event_ID==1280)=2;    % failed: release lever 1 early
        event_ID(event_ID==64)=3;     % failed: release lever 2 early
        event_ID(event_ID==1088)=4;    % failed: took too long to pull lever 2
        event_ID(event_ID==1089)=36;   % failed: release lever 3 early
        event_ID(event_ID==321)=37;   % failed: took too long to pull lever 3

        % task events
        event_ID(event_ID==1296)=10;   % start pulling lever 1
        event_ID(event_ID==80)=11;   % end pulling lever 1
        event_ID(event_ID==1104)=12;   % start pulling lever 2
        event_ID(event_ID==336)=13;   % end pulling lever 2
        event_ID(event_ID==1360)=14;   % start release GO signal 1
        event_ID(event_ID==4)=15;    % end release GO signal 1
        event_ID(event_ID==1028)=16;   % start release GO signal 2
        event_ID(event_ID==260)=17;   % end release GO signal 2
        event_ID(event_ID==1284)=18;   % start reward
        event_ID(event_ID==68)=19;   % end reward
        event_ID(event_ID==1092)=20;   % trial start

        % event_ID(event_ID==63488)=30;   % end hold item
        % event_ID(event_ID==1024)=31;   % end hold item
        event_ID(event_ID==1025)=32;   % PULL_LEVER_3
        event_ID(event_ID==257)=33;   % RELEASE_LEVER_3
        event_ID(event_ID==1281)=34;   % BEGIN_GO_3
        event_ID(event_ID==65)=35;   % END_GO_3


        % event_ID(event_ID==0)=38;   % WRONG_TRIAL_ORDER

        % % event_ID(event_ID==24576)=5;    % failed: RT too long
        % % event_ID(event_ID==57344)=6;    % failed: MT too long
        % % event_ID(event_ID==4096)=7;     % failed: delay between touching and pulling item too long
        % % event_ID(event_ID==36864)=8;    % failed: too long to take lever to final position
        % % event_ID(event_ID==20480)=9;    % failed: EMG too high during human's turn
        % 
        % % % add code 20 from manipulandum, meaning "press HP a beginning of trial"
        % % event_ID(event_ID==1024)=21;    % start delay 1
        % % event_ID(event_ID==10240)=22;   % item visible (panel ON)
        % % event_ID(event_ID==43008)=23;   % leave HP before GO (timing corrected afterwards)
        % % event_ID(event_ID==26624)=24;   % start GO signal
        % % event_ID(event_ID==59392)=25;   % end GO signal
        % % event_ID(event_ID==63488)=26;   % leave HP (for RT) (timing corrected afterwards)
        % % event_ID(event_ID==6144)=27;    % start touching item (timing corrected afterwards)
        % % event_ID(event_ID==38912)=28;   % start pulling item
        % % event_ID(event_ID==22528)=29;   % start hold period of item
        % % event_ID(event_ID==55296)=30;   % end hold item
        % % % add code 31 from manipulandum meaning "end touch item"
        % % event_ID(event_ID==17408)=32;   % start release GO signal
        % % event_ID(event_ID==50176)=33;   % end release GO signal
        % % %event_ID(event_ID==14336);   % unused
        % % event_ID(event_ID==47104)=34;   % start reward
        % % event_ID(event_ID==30720)=35;   % end reward

        event_ID2 = event_ID ;
        event_t2  = event_t ;
        
        if monkeyname == 'Wa'
           else   %Su,Se
              varargout= cell(nargout-4,1);
              AllTTLd_sel = cell(1,Ld);
              AllTTLu_sel = cell(1,Ld);
%               varargout. = cell(1,nargout-1);
              count = 1;
              for t = file_num(1):file_num(end)
                 TTLdata = load([monkeyname xpdate '-' sprintf('%04d', t) '.mat'], 'CTTL_001*');
                 if isfield(TTLdata,'CTTL_001_TimeBegin')
                    TTL_lag = (TTLdata.CTTL_001_TimeBegin - TimeRange_EMG(1))*TTLdata.CTTL_001_KHz*1000;
                    AllTTLd_sel{count} = TTLdata.CTTL_001_Down+TTL_lag;
                    AllTTLu_sel{count} = TTLdata.CTTL_001_Up+TTL_lag;
                    count = count+1;
                 end
              end
              if isfield(TTLdata,'CTTL_001_KHz')
                 AllTTLd = cell2mat(AllTTLd_sel).*SampleRate./(TTLdata.CTTL_001_KHz*1000);
                 AllTTLu = cell2mat(AllTTLu_sel).*SampleRate./(TTLdata.CTTL_001_KHz*1000);
                 for n = 1:floor((nargout-4)/2)
                    varargout{n} = AllTTLd;
                    varargout{n*2} = AllTTLu;
                 end
              end
        end
        TS = 1092; %trial start
        SPL1 = 1296; %start pulling lever 1
        EPL1 = 80; %end pulling lever 1
        SPL2 = 1104; %start pulling lever 2
        EPL2 = 336; %end pulling lever 2
        ST = 1024; %success trial
        
        TS_2 = 1092; %trial start
        SPL1_2 = 1424; %start pulling lever 1
        EPL1_2 = 80; %end pulling lever 1
        SPL2_2 = 1104; %start pulling lever 2
        EPL2_2 = 464; %end pulling lever 2
        ST_2 = 1024; %success trial
        
    case {'Ya','Ma','F'}
        event_ID=AllInPort(2,:); % ID of the codes
        event_t=AllInPort(1,:) ; % timing of the codes

        % trial outcome codes: last code of a trial

        event_ID(event_ID==0)=38;   % WRONG_TRIAL_ORDER
        event_ID(event_ID==32768)=0;    % success !
        event_ID(event_ID==16384)=1;    % failed: trial never started
        event_ID(event_ID==49152)=2;    % failed: release lever 1 early
        event_ID(event_ID==2048)=3;     % failed: release lever 2 early
        event_ID(event_ID==34816)=4;    % failed: took too long to pull lever 2
        event_ID(event_ID==34848)=36;   % failed: release lever 3 early
        event_ID(event_ID==18464)=37;   % failed: took too long to pull lever 3

        % task events
        event_ID(event_ID==49664)=10;   % start pulling lever 1
        event_ID(event_ID==2560)=11;   % end pulling lever 1
        event_ID(event_ID==35328)=12;   % start pulling lever 2
        event_ID(event_ID==18944)=13;   % end pulling lever 2
        event_ID(event_ID==51712)=14;   % start release GO signal 1
        event_ID(event_ID==128)=15;    % end release GO signal 1
        event_ID(event_ID==32896)=16;   % start release GO signal 2
        event_ID(event_ID==16512)=17;   % end release GO signal 2
        event_ID(event_ID==49280)=18;   % start reward
        event_ID(event_ID==2176)=19;   % end reward
        event_ID(event_ID==34944)=20;   % trial start

        % event_ID(event_ID==63488)=30;   % end hold item
        % event_ID(event_ID==1024)=31;   % end hold item
        event_ID(event_ID==32800)=32;   % PULL_LEVER_3
        event_ID(event_ID==16416)=33;   % RELEASE_LEVER_3
        event_ID(event_ID==49184)=34;   % BEGIN_GO_3
        event_ID(event_ID==2080)=35;   % END_GO_3

        event_ID2 = event_ID ;
        event_t2  = event_t ;
        
        TS = 34944; %trial start
        SPL1 = 49664; %start pulling lever 1
        EPL1 = 2560; %end pulling lever 1
        SPL2 = 35328; %start pulling lever 2
        EPL2 = 18944; %end pulling lever 2
        ST = 32768; %success trial
        
        TS_2 = 34944; %trial start
        SPL1_2 = 49664; %start pulling lever 1
        EPL1_2 = 2560; %end pulling lever 1
        SPL2_2 = 35328; %start pulling lever 2
        EPL2_2 = 18944; %end pulling lever 2
        ST_2 = 32768; %success trial
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


perfect_task = [TS, SPL1, EPL1, SPL2, EPL2, ST];
perfect_task_2 = [TS_2, SPL1_2, EPL1_2, SPL2_2, EPL2_2, ST_2];
Lp = length(perfect_task);

Timing_sel = cell(1,Lp);
for ii = 1:Lp
    Timing_alt = AllInPort(:,find((AllInPort(2,:)==perfect_task(ii))+(AllInPort(2,:)==perfect_task_2(ii))));
    Timing_alt(1,:) = Timing_alt(1,:) - TimeRange_EMG(1)*S1.CInPort_001_KHz*1000; 
    Timing_alt(1,:) = floor(Timing_alt(1,:)/(S1.CInPort_001_KHz/(SampleRate/1000)));
    Timing_sel{ii} = Timing_alt;
end

Timing = cell2mat(Timing_sel);

[B,I] = sort(Timing(1,:));
Timing = Timing(:,I); 

suc = find(Timing(2,:)==perfect_task(end));
suc_num = length(suc);
perfect_suc = suc;
perfect3_task = [perfect_task perfect_task perfect_task];
% perfect3_task_2 = [perfect_task_2 perfect_task_2 perfect_task_2];

Tp_sub = zeros(suc_num-1,Lp);
for s = 3:suc_num
    if (Timing(2, suc(s)-Lp+1) == perfect_task(1) && Timing(2, suc(s)-Lp+2) == perfect_task(2) && ...
       Timing(2, suc(s)-Lp+3) == perfect_task(3) && Timing(2, suc(s)-Lp+4) == perfect_task(4) && ...
       Timing(2, suc(s)-Lp+5) == perfect_task(5) && Timing(2, suc(s)-Lp+6) == perfect_task(6))||...
       (Timing(2, suc(s)-Lp+1) == perfect_task_2(1) && Timing(2, suc(s)-Lp+2) == perfect_task_2(2) && ...
       Timing(2, suc(s)-Lp+3) == perfect_task_2(3) && Timing(2, suc(s)-Lp+4) == perfect_task_2(4) && ...
       Timing(2, suc(s)-Lp+5) == perfect_task_2(5) && Timing(2, suc(s)-Lp+6) == perfect_task_2(6))
        Tp_sub(s-1,:) = Timing(1, suc(s)-Lp+1:suc(s));
    end
end
Tp = Tp_sub(find(Tp_sub(:,1) ~= 0),:);

Tp3_sub = zeros(suc_num-1,length(perfect3_task));

for s = 4:suc_num
    state = 0;
    for n = 1:3
        if (Timing(2, suc(s)-Lp*n+1) == perfect_task(1) && Timing(2, suc(s)-Lp*n+2) == perfect_task(2) && ...
           Timing(2, suc(s)-Lp*n+3) == perfect_task(3) && Timing(2, suc(s)-Lp*n+4) == perfect_task(4) && ...
           Timing(2, suc(s)-Lp*n+5) == perfect_task(5) && Timing(2, suc(s)-Lp*n+6) == perfect_task(6))||...
           (Timing(2, suc(s)-Lp*n+1) == perfect_task_2(1) && Timing(2, suc(s)-Lp*n+2) == perfect_task_2(2) && ...
           Timing(2, suc(s)-Lp*n+3) == perfect_task_2(3) && Timing(2, suc(s)-Lp*n+4) == perfect_task_2(4) && ...
           Timing(2, suc(s)-Lp*n+5) == perfect_task_2(5) && Timing(2, suc(s)-Lp*n+6) == perfect_task_2(6))
            state = state +1;
        end
    end
    if state == 3
        Tp3_sub(s-3,:) = Timing(1, suc(s)-Lp*3+1:suc(s));
    end
end
Tp3 = Tp3_sub(find(Tp3_sub(:,1) ~= 0),:);

%-----
% for s = 4:suc_num
%     state = 0;
%     for ii = 1:Lp
%         if Timing(2,suc(s)-8+ii) == perfect3_task(ii)
%             state = state +1;
%         end
%     end
%     if state ~= 7 || Timing(1,suc(s))-Timing(1,suc(s)-7)>SampleRate*4
%         perfect_suc(s) = 0; 
%     end
% end
% perfect_SUC = perfect_suc(find(perfect_suc(1:end) ~= 0));
% perfect_SUC = perfect_SUC(2:end);
% perfect_timing = zeros(length(perfect_SUC),length(perfect3_task));
% 
% for pp = 1:length(perfect_SUC)
%      perfect_timing(pp,:) = Timing(1,perfect_SUC(pp)-7:perfect_SUC(pp));
% end
% perfect_time = perfect_timing;
% for T = 1:length(perfect3_task)
%     perfect_time(:,T) = abs(perfect_timing(:,T) - perfect_timing(:,2));
% end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pullData,dt1,dt2,dt3] = getCTcheck(AllData_EMG,TP,selEMGs,EMG_Hz,trialN)
L = length(selEMGs);
pullData = zeros(L,TP(trialN,end)-TP(trialN,1)+1);
    for i = 1:L
        pullData(i,:) = AllData_EMG(TP(trialN,1):TP(trialN,end),i)';
    end
Sp = size(pullData); %Sp(1) means EMG_num
dt1s = cell(Sp(1),1);
dt2s = cell(Sp(1),1);
dt3s = cell(Sp(1),1);
    for j = 1:L
        h = 1/5000;%/EMG_Hz;       % step size
        f = pullData(j,:);
        Ds = diff(f)/h;   % first derivative diffは要素間の差分を返す
        dt1s{j} = downsample(Ds,10);%DSの1,11,21,…の要素を代入していく
        Ds = diff(Ds)/h;   % second derivative（前のDsをさらにDsする）
        dt2s{j} = downsample(Ds,10);
        Ds = diff(Ds)/h;
        dt3s{j} = downsample(Ds,10);
    end
    dt1 = cell2mat(dt1s);
    dt2 = cell2mat(dt2s);
    dt3 = cell2mat(dt3s);
end

