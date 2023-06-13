function [FileNames,y,Label]  = getAnalogWithinInterval(varargin)

nnargin = nargin;
if nnargin<1
    error('No input augument');
elseif(ischar(varargin))
    varargin={varargin};
end

for iargin=1:nnargin
    default_answer  = varargin{iargin};
    if(iscell(default_answer))
        varargin(iargin)    = [];
        nnargin              = nnargin -1;
        break;
    else
        default_answer  = cell(1);
    end
end

Label   = varargin;


ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end

ParentDir   = uigetdir(ParentDir);
setconfig(mfilename,'ParentDir',ParentDir);

InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'Select Experiments.');

    
InputDir    = InputDirs{1};
Tarfiles     = dirmat(fullfile(ParentDir,InputDir));
Tarfiles     = strfilt(Tarfiles,'~._');
Reffiles     = uiselect(sortxls(deext(Tarfiles)),1,'Select Interval files.');
if(isempty(Reffiles))
    disp('User pressed cancel.')
    return;
end

Tarfiles     = uiselect(sortxls(deext(Tarfiles)),1,'Select Target files.');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end


% ll  = 0;
nDir    = length(InputDirs);
nRef    = length(Reffiles);
nTar    = length(Tarfiles);

y       = cell(nDir,1);
FileNames   = cell(nDir,1);

for iDir=1:nDir
    InputDir    = InputDirs{iDir};
    for iTar=1:nTar
        
        Tarfile = fullfile(ParentDir,InputDir,[Tarfiles{iTar},'.mat']);
        Reffile = fullfile(ParentDir,InputDir,[Reffiles{iTar},'.mat']);
        ll      = nTar*(iDir-1)+iTar;
        
        FileNames{ll,1} = Tarfile;
        
        try
            Tar     = load(Tarfile);
            Ref     = load(Reffile);
            XData   = ((1:length(Tar.Data))-1)/1000;
            nTrial  = size(Ref.Data,2);
            YY      = nan(nTrial,nnargin);
                        
            for iTrial=1:nTrial
                ind = XData>=Ref.Data(1,iTrial) & XData<=Ref.Data(2,iTrial);
                X   = Tar.Data(ind);
                
                for kk  = 1:nnargin
                    propname    = varargin{kk};
                    try
                        eval(['YY(iTrial,kk)  = ',propname,';']);
                    catch
                        YY(iTrial,kk)  = [];
                    end
                end
            end
            
            y{iDir,1}   = YY;
            FileNames{iDir,1}   = Tarfile; 
            
            indicator(iDir,nDir)
            disp([' L-- (',num2str(iDir),'/',num2str(nDir),'):  ',Tarfile])
        catch
            for kk  = 1:nargin
                y{iDir,1}  = [];
            end
            FileNames{iDir,1} = fullfile(ParentDir,InputDir,Tarfiles{iTar});
            indicator(iDir,nDir)
            disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{iTar})])
        end
    end

    
end