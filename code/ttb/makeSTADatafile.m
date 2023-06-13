function [hdr,data] = makeSTADatafile(hdr,data,rmSmoothing_flag)

data.Name       = ['._',hdr.Name];
data.hdr_file   = [hdr.Name,'.mat'];
hdr.data_file   = [data.Name,'.mat'];

if(isfield(data,'hdrfile'))
    data    = rmfield(data,'hdrfile');
end
if(isfield(hdr,'datafile'))
    hdr    = rmfield(hdr,'datafile');
end

if(isfield(hdr,'TrialData'))
    if(~islogical(hdr.TrialData))       % もし、makeSTADatafileが実行されているならば、もうやらない。
        if(isempty(hdr.TrialData))
            if(hdr.nTrials == 0)      %　Trialが０であるためにTrialDataがエンプティならば、TrialDataはあるものとして扱う
                data.TrialData  = hdr.TrialData;
                hdr.TrialData     = true;
            else
                hdr.TrialData     = [];
            end
        else
            data.TrialData  = hdr.TrialData;
            hdr.TrialData     = true;
        end
    end
end
if(isfield(hdr,'ISATrialData'))
    if(~islogical(hdr.ISATrialData))
        data.ISATrialData  = hdr.ISATrialData;
        hdr.ISATrialData     = true;
    end
end
if(isfield(hdr,'adjTrialData'))
    if(~islogical(hdr.adjTrialData))
        data.adjTrialData  = hdr.adjTrialData;
        hdr.adjTrialData     = true;
    end
end

if(rmSmoothing_flag==1)
    if(isfield(hdr,'smYData'))
        hdr.YData = hdr.smYData;
        hdr       = rmfield(hdr,'smYData');
    end

    if(isfield(hdr,'smISAData'))
        hdr.ISAData = hdr.smISAData;
        hdr       = rmfield(hdr,'smISAData');
    end
elseif(rmSmoothing_flag==2)
    if(isfield(hdr,'smYData'))
        hdr       = rmfield(hdr,'smYData');
    end

    if(isfield(hdr,'smISAData'))
        hdr       = rmfield(hdr,'smISAData');
    end

end