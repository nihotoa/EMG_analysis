TimeRange   = [0 480];


% InputDirs   = {
%     'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00101'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00203'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00301'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00702'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00801'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00903'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01106'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01202'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01310'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01702'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT02402'
% };
% InputDirs   = {
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00203'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00301'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00903'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01106'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01202'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01702'
% 'N:\tkitom\Data\Aoba\Spinal Unit\AobaT02402'
% };
% OutputDir   = 'N:\tkitom\Data\Aoba\Spinal Unit\Aoba_combined';
InputDirs   = {
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00203'
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00301'
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT00903'
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01106'
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01202'
'N:\tkitom\Data\Aoba\Spinal Unit\AobaT01702'
};
OutputDir   = 'N:\tkitom\Data\Aoba\Spinal Unit\Aoba_combined3';


% InputDirs   = {
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00108'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00204'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00404'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00501'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00603'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00702'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00802'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT00902'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01001'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01202'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01305'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01402'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01503'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01601'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01701'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT01804'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT02101'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT02303'
% 'N:\tkitom\Data\Eito\Spinal Unit\EitoT02411'
% };
% OutputDir   = 'N:\tkitom\Data\Eito\Spinal Unit\combined';


filenames   = {
'FDI(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'ADP(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'AbPB(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'AbDM(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'FDS(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'FDPr(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'FDPu(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'FCR(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'FCU(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'ED23(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'EDC(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
'ECU(mean)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz-norm.mat'
};

% filenames   = {
% 'FDI(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'ADP(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'AbPB(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'AbDM(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'FDS(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'FDPr(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'FDPu(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'FCR(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'FCU(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'ED23(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'EDC(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% 'ECU(uV)-ds1000Hz-bss-hp50Hz-rect-lp20Hz-ls100ms-ds100Hz.mat'
% };



nDir    = length(InputDirs);
nfile   = length(filenames);

for ifile = 1:nfile
    for iDir = 1:nDir
        fullfilename    = fullfile(InputDirs{iDir},filenames{ifile});
        
        Tar   = load(fullfilename);

        XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
        ind     = (XData >= TimeRange(1) & XData < TimeRange(2));
        TotalTime=sum(ind)/Tar.SampleRate;
        TimeRange2  = [TimeRange(1)+Tar.TimeRange(1),TimeRange(1)+Tar.TimeRange(1)+TotalTime];
        
        if(iDir==1)
            Data = nan(sum(ind),nDir);
        end
        
                Data(:,iDir)    = normalize(Tar.Data(ind),'mean')';
%         Data(:,iDir)    = Tar.Data(ind)';
        
    end
    Tar.Data    = reshape(Data,numel(Data),1)';
    outputfilename  = fullfile(OutputDir,filenames{ifile});
    Tar.TimeRange   = [0 (length(Tar.Data)-1)./Tar.SampleRate];
    
    save(outputfilename,'-struct','Tar')
    disp(outputfilename)
    
    
end