function fmitvcmp_btc(varargin)
% fm_btc(BaseWindow, SearchTW, nsd, kknn, alpha)
% fm_btc([-1.0 -0.5], [0 0.3;0.7 1.2], 2 , [0.1 0.16], 0.05)
%
% BaseWindow  = [-1.0 -0.5];
% SearchTW    = [0 0.3;0.7 1.2];
% nsd         = 2;
% nn          = 0.160; %(sec) ������duration���������̂���peak�Ƃ݂Ȃ�
% kk          = 0.100;
% alpha       = 0.05;

% if(nargin~=1)
%     error('�\�����Ⴂ�܂��Bpse_btc(BaseWindow)')
% end

warning('off');
gnames  = varargin;
ncond   = length(gnames);

OutFileName = 'FMCMP(';
for icond =1:ncond
    OutFileName = [OutFileName,gnames{icond},','];
end
OutFileName(end)    = ')';


ParentDir   = uigetdir(fullfile(datapath,'FMITV'),'�e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = strfilt(dirmat(fullfile(ParentDir,InputDir)),'~._');

titlestr    = [];
for icond=1:ncond
    titlestr    = [titlestr,num2str(icond),':',gnames{icond}];
end
Tarfiles    = uiselect(Tarfiles,1,titlestr);

Tarfiles    = Tarfiles(1:ncond);



nDir    = length(InputDirs);

for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        TW  = cell(ncond,1);
        for icond=1:ncond
            
            TW{icond}   = load(fullfile(ParentDir,InputDir,['._',Tarfiles{icond}]));

        end
        
        FMCMP   = fmitvcmp(TW,gnames);
        
        OutFullFileName = fullfile(ParentDir,InputDir,OutFileName);
        save(OutFullFileName,'-struct','FMCMP');
        
        clear('FMCMP')
        
        disp([' L-- ',num2str(iDir),'/',num2str(nDir),':  ',OutFullFileName])
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    
    
end

warning('on');