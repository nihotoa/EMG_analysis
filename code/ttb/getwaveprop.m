function [filenames, y, Label, nDir, nTar]  = getwaveprop(BaseTW,TestTW,pseadjust_method)
% [filenames, y, Label, nDir, nTar]  = getwaveprop(BaseTW,TestTW)
% BaseTW,TestTW in sec
% When PSTH files are selected, unit will be converted into Hz.
%
% see also gettrialwaveprop


%   Label   = {'mean' 'sd' 'RMS' 'area' 'lareal' 'max'

if nargin<1
%     BaseTW  = [0 1];
%     TestTW  = [-inf inf];
error('noinput')
elseif nargin<3
    pseadjust_method    =[];
end

if(~isempty(pseadjust_method))
    psename = [];
end

Label   = {'basemean',...  %2
    'basesd',...    %3
    'mean',...      %4
    'sd',...        %5
    'RMS',...       %6
    'area',...      %7
    'lareal',...    %8
    'aread',...      %9
    'lareadl',...    %10
    'max',...       %11
    'maxtime',...   %12
    'min',...       %13
    'mintime',...   %14
    'p-p',...       %15
    'peakd',...     %16
    'meand',...     %17
    'PPI',...       %18
    'MPI'};         %19

nLabel  = length(Label);


ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end

ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');

if(ParentDir==0)
    disp('User pressed cancel.')
    filenames   = [];
    y   = [];
    Label   = [];
    nDir    = [];
    nTar    = [];
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end


InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'Select Experiments.');



InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(deext(Tarfiles)),1,'Select Target files');


nDir    = length(InputDirs);
nTar    = length(Tarfiles);

y       = cell(nDir*nTar,nLabel);
filenames   = cell(nDir*nTar,1);

for iDir=1:nDir
    InputDir    = InputDirs{iDir};
    for iTar=1:nTar
        S       = [];
        Tarfile = fullfile(ParentDir,InputDir,Tarfiles{iTar});
        ll      = nTar*(iDir-1)+iTar;
        filenames{ll,1} = Tarfile;

        try
            S   = load([Tarfile,'.mat']);

            if(isfield(S,'AnalysisType'))
                switch S.AnalysisType
                    case 'STA'
                        if(isempty(pseadjust_method))
                            YData    = S.YData;
                            XData    = S.XData;
                        else
                            if(isempty(psename))
                                psename = strfilt(fieldnames(S),'pse');
                                psename = uiselect(psename);
                                if(iscell(psename))
                                    psename = psename{1};
                                end
                            end
                            [YData,XData,BaseLine,BaseMean,BaseSD,YUnit]    = pseadjust(S,psename,pseadjust_method);
                            disp(['pseadjust_method: ',pseadjust_method])
                            
                        end
                    case 'AVESTA'
                        YData    = S.YData;
                        XData    = S.XData;
                    case 'PSTH'
                        
%                         YData    = S.YData;
                        YData   = S.YData./S.BinWidth./S.nTrials; %converted into frequency (Hz)
                        XData    = S.XData;
                end
            else    % recorded data
                YData   = S.Data;
                XData   = ([1:length(S.Data)]-1) / S.SampleRate;
            end

            dt  = XData(2)-XData(1);

            baseind = (XData >= BaseTW(1) & XData <= BaseTW(2));
            BYData  = YData(baseind);
            basemean    = mean(BYData);
%             BXData  = XData(baseind);

            ind = (XData >= TestTW(1) & XData <= TestTW(2));
            YData   = YData(ind);
            XData   = XData(ind);

%            'basemean',...  %2
%     'basesd',...    %3
%     'mean',...      %4
%     'sd',...        %5
%     'RMS',...       %6
%     'area',...      %7
%     'lareal',...    %8
%     'aread',...      %9
%     'lareadl',...    %10
%     'max',...       %11
%     'maxtime',...   %12
%     'min',...       %13
%     'mintime',...   %14
%     'p-p',...       %15
%     'peakd',...     %16
%     'meand',...     %17
%     'PPI',...       %18
%     'MPI'};         %19


            if(~all(YData==0))
                % basemean
                y{ll,1} = basemean;
                % basesd
                y{ll,2} = std(BYData,1);
                % mean
                y{ll,3} = mean(YData);
                % sd
                y{ll,4} = std(YData,1);
                % RMS
                y{ll,5} = rms(YData);
                % area
                y{ll,6} = sum(YData) .* dt;
                % lareal
                y{ll,7} = sum(abs(YData)) .* dt;
                
                % aread
                y{ll,8} = sum(YData - basemean) .* dt;
                % lareadl
                y{ll,9} = sum(abs(YData - basemean)) .* dt;
                

                %max, maxtime
                [y{ll,10},ind]   = max(YData);
                y{ll,11} = XData(ind);

                %min, mintime
                [y{ll,12},ind]   = min(YData);
                y{ll,13} = XData(ind);
                
                %p-p
                y{ll,14}    = y{ll,11}-y{ll,13};
                
                % peakd
                pd  = max(YData) - basemean;
                td  = min(YData) - basemean;

                if(abs(pd)>=abs(td))
                    y{ll,15} = pd;
                else
                    y{ll,15} = td;
                end
                
                % meand
                y{ll,16} = mean(YData) - basemean;
                
                % PPI
                y{ll,17} = y{ll,13} / basemean;
                
                % MPI
                y{ll,18} = y{ll,14} / basemean;
                
            else
                y(ll,2:end) = cell(1,nLabel-1);
            end

            indicator(ll,length(InputDirs)*length(Tarfiles))
            disp([' L-- (',num2str(ll),'/',num2str(length(InputDirs)*length(Tarfiles)),'):  ',fullfile(ParentDir,InputDir,Tarfiles{iTar})])
        catch
            y(ll,:) = cell(1,nLabel);

            indicator(ll,length(InputDirs)*length(Tarfiles))
            disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{iTar})])
            
        end
    end


end
%
% y   = [Label;y];
IndLabel    = Label;
for iLabel=1:nLabel
    IndLabel{iLabel}    = [num2str(iLabel),': ',Label{iLabel}];
end
disp(IndLabel')
indicator(0,0)