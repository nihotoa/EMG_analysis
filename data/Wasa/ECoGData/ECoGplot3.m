%file info
monkeyname = 'Wa' ; 
xpdate = '181122'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
area = 'M1';
save_fold = 'ECoGData';
tim_fold = 'new_nmf_result';
save_fig = 0;
downdata_to = 100;


cd([monkeyname xpdate])
get_first = 1;
switch area
    case 'M1'
        for i = 1:32;
            load(['CRAW_' sprintf('%03d',i) '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat'])
            if get_first == 1
                DataA = zeros(32,length(Data));
                DataA(1,:) = Data;
                SampleRate_ECoG = SampleRate;
                get_first = 0;
            else
                DataA(i,:) = Data;
            end
        end
    case 'S1'
        for i = 33:64;
            load(['CRAW_' sprintf('%03d',i) '-hp50Hz-rect-lp20Hz-lnsmth100-ds100Hz.mat'])
            if get_first == 1
                DataA = zeros(32,length(Data));
                DataA(1,:) = Data;
                get_first = 0;
            else
                DataA(i,:) = Data;
            end
        end
end
cd ../

cd ../
cd(tim_fold)
cd([monkeyname xpdate])
load([monkeyname xpdate '_SUC_Timing.mat'])

SUC_Timing_A = floor(SUC_Timing_A./(SampleRate/downdata_to));
SampleRate = SampleRate_ECoG;

%which data do you use?
filtData = DataA';

for j = 1:32
    filtData(:,j) = filtData(:,j) - mean(filtData(:,j));
end
