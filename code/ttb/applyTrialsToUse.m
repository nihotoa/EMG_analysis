function [S,S_dat]  = applyTrialsToUse(S,S_dat)

if(nargin<2)
    S_dat   = [];
end

if(~isfield(S,'TrialsToUse'))
    return;
end

if(isfield(S,'AnalysisType'))
    switch S.AnalysisType
        case 'STA'
          Addflag   = ismember(1:S.nTrials,S.TrialsToUse);
          
          
          S_dat.TrialData   = S_dat.TrialData(Addflag,:);
          if(isfield(S_dat,'ISATrialData'))
              S_dat.ISATrialData   = S_dat.ISATrialData(Addflag,:);
          end
          
          S.TimeStamps  = S.TimeStamps(Addflag);
          S.nTrials     = sum(Addflag);
          S.YData       = mean(S_dat.TrialData,1);
          if(isfield(S,'ISAData')) 
              S.ISAData = mean(S_dat.ISATrialData,1);
              S.nISA    = length(S.ISATimeWindow)*S.nTrials;
          end
          S = rmfield(S,'TrialsToUse');
    end
else
    switch S.Class
        case 'timestamp channel'
            Addflag   = ismember(1:size(S.Data,2),S.TrialsToUse);
            
            S.Data  	= S.Data(Addflag);
            if(isfield(S,'accessory_data'))
                nAD = length(S.accessory_data);
                for iAD=1:nAD
                    S.accessory_data(iAD).Data  = S.accessory_data(iAD).Data(Addflag);
                end
            end
            S = rmfield(S,'TrialsToUse');
        case 'interval channel'
    end
end