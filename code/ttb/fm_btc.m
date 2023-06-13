function fm_btc(BaseWindow, SearchTW, nsd, kknn, alpha)
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


kk  = kknn(1);
nn  = kknn(2);


warning('off');


ParentDir   = uigetdir(fullfile(datapath,'PSTH'),'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(Tarfiles,1,'対象とするfileを選択してください');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(Tarfiles)
                try
                    Tarfile = Tarfiles{ii};
                    Tar_hdr = load(fullfile(ParentDir,InputDir,Tarfile));
                    Tar_dat = load(fullfile(ParentDir,InputDir,['._',Tarfile]),'psth_TrialData_sps');
                    FM_hdr  = fm(Tar_hdr,Tar_dat,BaseWindow,SearchTW,nsd,nn,kk,alpha);
                    OutputFile_hdr  = fullfile(ParentDir,InputDir,Tarfile);
%                     OutputFile_dat  = fullfile(ParentDir,InputDir,['._',Tarfile]);
                    
                    
                    save(OutputFile_hdr,'-struct','FM_hdr')
%                     save(OutputFile_dat,'-struct','FM_dat')
                    
                    clear('Tar_hdr','Tar_dat','FM_hdr','FM_dat')
                    mpack

                    disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile_hdr])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
%                 indicator(ii,length(Tarfiles))
            end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');