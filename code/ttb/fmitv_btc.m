function fmitv_btc
% fm_btc(BaseWindow, SearchTW, nsd, kknn, alpha)
% fm_btc([-1.0 -0.5], [0 0.3;0.7 1.2], 2 , [0.1 0.16], 0.05)
%
% BaseWindow  = [-1.0 -0.5];
% SearchTW    = [0 0.3;0.7 1.2];
% nsd         = 2;
% nn          = 0.160; %(sec) これよりdurationが長いものだけpeakとみなす
% kk          = 0.100;
% alpha       = 0.05;

% if(nargin~=1)
%     error('構文が違います。pse_btc(BaseWindow)')
% end



warning('off');


ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Reffiles    = dirmat(fullfile(ParentDir,InputDir));
Reffiles    = strfilt(Reffiles,'~._');
Tarfiles    = uiselect(Reffiles,1,'対象とするfile(timestamp)を選択してください（複数選択可）');

Reffiles    = uiselect(Reffiles,1,'区間を決めるinterval fileを選択してください(複数選択可)');

nDir        = length(InputDirs);
nTar        = length(Tarfiles);
nRef        = length(Reffiles);

OutputDir   = uigetdir(fullfile(datapath,'fmitv'),'出力フォルダを選択してください。');


for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        for iTar=1:length(Tarfiles)

            Tarfile = Tarfiles{iTar};
            Tar     = load(fullfile(ParentDir,InputDir,Tarfile));
            
            for iRef=1:nRef;
                Reffile = Reffiles{iRef};
                Ref     = load(fullfile(ParentDir,InputDir,Reffile));

                [FM_hdr,FM_dat]   = fmitv(Tar,Ref);

                Name            = FM_hdr.Name;
                OutputFile_hdr  = fullfile(OutputDir,InputDir,[Name,'.mat']);
                OutputFile_dat  = fullfile(OutputDir,InputDir,['._',Name,'.mat']);

                if(~exist(fullfile(OutputDir,InputDir),'dir'))
                    mkdir(fullfile(OutputDir,InputDir));
                end
                save(OutputFile_hdr,'-struct','FM_hdr')
                save(OutputFile_dat,'-struct','FM_dat')

                clear('Ref','FM_hdr','FM_dat')

                disp([' L-- ',num2str(iTar),'/',num2str(nTar),':  ',OutputFile_hdr])
            end

        end
    catch
        keyboard
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

warning('on');