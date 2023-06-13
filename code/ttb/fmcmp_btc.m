function fmcmp_btc(varargin)
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
gnames  = varargin;
% ncond   = inputdlg({'#conditions'},'比較する条件数を入力して下さい。',1,{'4'});
% ncond   = str2double(ncond{1});

ncond   = length(gnames);

OutFileName = 'FMCMP(';
for icond =1:ncond
    OutFileName = [OutFileName,gnames{icond},','];
end
OutFileName(end)    = ')';

FileName    = cell(ncond,1);
FieldName   = cell(ncond,1);
iField      = cell(ncond,1);

ParentDir   = uigetdir(fullfile(datapath,'PSTH'),'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};

for icond   =1:ncond

    FileName{icond} = dirmat(fullfile(ParentDir,InputDir));
    FileName{icond} = strfilt(FileName{icond},'~._');
    FileName{icond} = uiselect(FileName{icond},1,['条件(',num2str(icond),') : ',gnames{icond}]);
    FileName{icond} = FileName{icond}{1};
    
    S   = load(fullfile(ParentDir,InputDir,FileName{icond}));
    if(isfield(S,'TW'))
        FieldName{icond}    = 'TW';
    else

        FieldName{icond}    = fieldnames(S);
        FieldName{icond}    = uiselect(FieldName{icond},1,['条件(',num2str(icond),') : ',gnames{icond}]);
        FieldName{icond}    = FieldName{icond}{1};
    end
    
    nField  = length(S.(FieldName{icond}));
    
%     if(nField>1)
        tField  = cell(nField,1);
        for iTemp=1:nField
            tField{iTemp}   = mat2str([S.(FieldName{icond})(iTemp).onset, S.(FieldName{icond})(iTemp).offset]);
        end
        sField  = uiselect(tField,1,['条件(',num2str(icond),') : ',gnames{icond}]);
        sField  = sField{1};
        
        iField{icond}  = strmatch(sField,tField,'exact');
%     else
%         iField{icond}  = 1;
%     end
end

message = cell(ncond,1);
for icond=1:ncond 
    message{icond} = ['条件(',num2str(icond),'):  ',FileName{icond},';  ',FieldName{icond},';  ',num2str(iField{icond})];
end
yn  = questdlg(message,'確認');
if(strcmpi(yn,'no') || strcmpi(yn,'cancel'))
    error('cancelします。')
end

nDir    = length(InputDirs);

for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        S   = [];
        TW  = cell(ncond,1);
        for icond=1:ncond
            S           = load(fullfile(ParentDir,InputDir,FileName{icond}));
            TW{icond}   = S.(FieldName{icond})(iField{icond});
        end
        
        FMCMP   = fmcmp(TW,gnames);
        
        OutFullFileName = fullfile(ParentDir,InputDir,OutFileName);
        
        save(OutFullFileName,'-struct','FMCMP');
        
        clear('FMCMP')
        
        mpack
        disp([' L-- ',num2str(iDir),'/',num2str(nDir),':  ',OutFullFileName])
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    
    
end

warning('on');