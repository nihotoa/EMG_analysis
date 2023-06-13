function displaydata_lite

pathname    = getconfig(mfilename,'pathname');
if(isempty(pathname))
    pathname    = pwd;
end

[filenames, pathname] = uigetfile(fullfile(pathname,'*.mat'),'MultiSelect','on');
if(isequal(filenames,0)||isequal(pathname,0))
    disp('User Pressed Cancel')
    return;
else
    setconfig(mfilename,'pathname',pathname);
end

if(~iscell(filenames))
    filenames   = {filenames};
end
nfiles  = length(filenames);

fig     = figure;
hAx     = zeros(nfiles,1);

for ifile=1:nfiles
    filename    = filenames{ifile};
    hAx(ifile)  = subplot(nfiles,1,ifile,'Parent',fig);
    S           = load(fullfile(pathname,filename));
       
    switch  S.Class
        case 'continuous channel'               %% continuous
            
            XData   = ((1:length(S.Data)) - 1) / S.SampleRate;
                      
            plot(hAx(ifile),XData,S.Data,'Color',[0 0 0.5])
            
            if(isfield(S,'Unit'))
                ylabel(hAx(ifile),S.Unit);
            end
            title(hAx(ifile),{filename,[num2str(S.SampleRate),' Hz']});
            
            
        case 'timestamp channel'                %% timestamp
            XData   = S.Data;
            XData   = XData/S.SampleRate;
            
            if(~isempty(XData))
                plot(hAx(ifile),repmat(XData',1,2),[0 1],'Color',[0.5 0 0])
            end
            set(hAx(ifile),'YLim',[0 1],...
                'YTick',[],...
                'YTickMode','manual',...
                'YTickLabel',[],...
                'YTickLabelMode','manual')
            
            title(hAx(ifile),{filename;['n=',num2str(length(S.Data))]});
            
            
        case 'interval channel'                 %% interval
            XData   = S.Data;
            nRect   = size(XData,2);
            
            if(nRect~=0)
                for jj=1:nRect
                    rectangle('Position',[XData(1,jj) 0 (XData(2,jj)-XData(1,jj)) 1],'FaceColor',[0 0.5 0],'Parent',hAx(ifile));
                    set(hAx(ifile),'Nextplot','add');
                end
            end
            
            set(hAx(ifile),'YLim',[0 1],...
                'YTick',[],...
                'YTickMode','manual',...
                'YTickLabel',[],...
                'YTickLabelMode','manual')
            
            title(hAx(ifile),{filename;['n=',num2str(size(S.Data,2))]});
           
    end
    
end

linkaxes(hAx,'x');

end

%-----------------------------------
function Y  = getconfig(mfile,name)

try
    %     warning('off','MATLAB:load:variableNotFound')
    configfile  = fullfile(matlabroot,'work','ttbconfig.mat');
    Y   = load(configfile);
    if(nargin==1)
        Y   = Y.(mfile);
    elseif(nargin==2)
        Y   = Y.(mfile).(name);
    end
    %     warning('on','MATLAB:load:variableNotFound')
catch
    Y   = [];
end

end

%-----------------------------------
function setconfig(mfile,name,value)
% setconfig(mfile,name,value)
%
% setconfig(mfilename,'lastdir',y)

try
    workpath    = fullfile(matlabroot,'work');
    configfile  = fullfile(matlabroot,'work','ttbconfig.mat');
    if(exist(workpath,'dir'))
        if(exist(configfile,'file'))
            S   = load(configfile);
            S.(mfile).(name)    = value;
            save(configfile,'-struct','S')
        else
            S   = [];
            S.(mfile).(name)    = value;
            save(configfile,'-struct','S')
        end
    else
        mkdir(workpath);
        S   = [];
        S.(mfile).(name)    = value;
        save(configfile,'-struct','S')
    end
catch
    error('config is not saved.')
    
end

end
