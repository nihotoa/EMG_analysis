function [filenames, y, Label, nTrials]  = gettrialwaveprop(BaseTW,TestTW)
% [filenames, y, Label, nTrials]  = gettrialwaveprop(BaseTW,TestTW)
% BaseTW,TestTW in sec
% see also getwaveprop

%   Label   = {'mean' 'sd' 'RMS' 'area' 'lareal' 'max'

if nargin<1
    error('noinput')
end

Label   = {'basemean',...  %1
    'basesd',...    %2
    'mean',...      %3
    'sd',...        %4
    'RMS',...       %5
    'area',...      %6
    'lareal',...    %7
    'aread',...      %8
    'lareadl',...    %9
    'max',...       %10
    'maxtime',...   %11
    'min',...       %12
    'mintime',...   %13
    'p-p',...       %14
    'peakd',...     %15
    'meand',...     %16
    'PPI',...       %17
    'MPI'};         %18
nLabel  = length(Label);


% [S,filename]    = topen;
filenames       = matexplorer;
filenames       = shiftdim(filenames);

if(isempty(filenames))
    disp('No file was selected.')
    return;
end
nfile           = length(filenames);
y       = cell(nfile,1);
nTrials = nan(nfile,1);

for ifile =1:nfile
    filename    = filenames{ifile};
    S   = load(filename);
    
    if(isfield(S,'AnalysisType'))
        [pathname,filename] = fileparts(filename);
        filename        = fullfile(pathname,['._',filename,'.mat']);
        S_dat   = load(filename);
        
        switch S.AnalysisType
            case 'STA'
                TrialData   = S_dat.TrialData;
                XData       = S.XData;
                %         case 'AVESTA'
                %             YData    = S.YData;
                %             XData    = S.XData;
                %         case 'PSTH'
                %             YData    = S.YData_sps;
                %             XData    = S.BinData;
        end
        
        nTrials(ifile)  = size(TrialData,1);
        dt  = XData(2)-XData(1);
        
        y{ifile}    = nan(nTrials(ifile),nLabel);
        
        for iTrial=1:nTrials(ifile)
            YData   = TrialData(iTrial,:);
            
            
            
            baseind = (XData >= BaseTW(1) & XData <= BaseTW(2));
            BYData  = double(YData(baseind));
            basemean    = mean(BYData);
            
            
            ind = (XData >= TestTW(1) & XData <= TestTW(2));
            TYData   = double(YData(ind));
            TXData   = XData(ind);
            
            if(~all(TYData==0))
                % basemean
                y{ifile}(iTrial,1) = basemean;
                % basesd
                y{ifile}(iTrial,2) = std(BYData,1);
                % mean
                y{ifile}(iTrial,3) = mean(TYData);
                % sd
                y{ifile}(iTrial,4) = std(TYData,1);
                % RMS
                y{ifile}(iTrial,5) = rms(TYData);
                % area
                y{ifile}(iTrial,6) = sum(TYData) .* dt;
                % lareal
                y{ifile}(iTrial,7) = sum(abs(TYData)) .* dt;
                
                % aread
                y{ifile}(iTrial,8) = sum(TYData - basemean) .* dt;
                % lareadl
                y{ifile}(iTrial,9) = sum(abs(TYData - basemean)) .* dt;
                
                
                %max, maxtime
                [y{ifile}(iTrial,10),ind]   = max(TYData);
                y{ifile}(iTrial,11) = TXData(ind);
                
                %min, mintime
                [y{ifile}(iTrial,12),ind]   = min(TYData);
                y{ifile}(iTrial,13) = TXData(ind);
                
                %p-p
                y{ifile}(iTrial,14)    = y{ifile}(iTrial,10)-y{ifile}(iTrial,12);
                
                % peakd
                pd  = max(TYData) - basemean;
                td  = min(TYData) - basemean;
                
                if(abs(pd)>=abs(td))
                    y{ifile}(iTrial,15) = pd;
                else
                    y{ifile}(iTrial,15) = td;
                end
                
                % meand
                y{ifile}(iTrial,16) = mean(TYData) - basemean;
                
                % PPI
                y{ifile}(iTrial,17) = y{ifile}(iTrial,13) / basemean;
                
                % MPI
                y{ifile}(iTrial,18) = y{ifile}(iTrial,14) / basemean;
                
            else
                y{ifile}(iTrial,:) = nan(1,nLabel);
            end
            
        end
    else
        disp([filename,' is not Analysis file.'])
        y{ifile}    = nan(1,nLabel);
    end
    
end
