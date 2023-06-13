function [FileNames, y, Label, nDir, nTar]  = getprop(varargin)
%   [FileNames, y, Label, nDir, nTar]  = getprop('PropName1','PropName2',...)
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


% fid = fopen('prop.xls','w');
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
InputDirs   = uiselect(InputDirs,1,'Select Experiments.',default_answer);

    

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
% Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(deext(Tarfiles)),1,'Select Target files',default_answer);


% ll  = 0;
nDir    = length(InputDirs);
nTar    = length(Tarfiles);

y       = cell(nDir*nTar,nargin);
FileNames   = cell(nDir*nTar,1);

for iDir=1:nDir
    InputDir    = InputDirs{iDir};
    for iTar=1:nTar
        S       = [];
        Tarfile = fullfile(ParentDir,InputDir,[Tarfiles{iTar},'.mat']);
        ll      = nTar*(iDir-1)+iTar;
%         y{ll,1}     = Tarfile;
        FileNames{ll,1} = Tarfile;
        
        try
            S   = load(Tarfile);

            for kk  = 1:nnargin
                propname    = varargin{kk};
                try
                    eval(['y{ll,kk}  = ',propname,';']);
                catch
                    y{ll,kk}  = [];
                end
            end
            indicator(ll,length(InputDirs)*length(Tarfiles))
            disp([' L-- (',num2str(ll),'/',num2str(length(InputDirs)*length(Tarfiles)),'):  ',fullfile(ParentDir,InputDir,Tarfiles{iTar})])
        catch
            for kk  = 1:nargin
                y{ll,kk}  = [];
            end
            FileNames{ll,1} = fullfile(ParentDir,InputDir,Tarfiles{iTar});
            indicator(ll,length(InputDirs)*length(Tarfiles))
            disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{iTar})])
        end
    end

    
end

% fclose(fid);
indicator(0,0)