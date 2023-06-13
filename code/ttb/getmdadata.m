function [Data,accessory_Data,hdr,IDs,currExp] = getmdadata(TimeRange)

if(nargin<1)
    TimeRange   = [0 Inf];
end

currExp = gcme;
if isempty(currExp)
    error('**** No experiment is selected.')
end
ChanNames       = getchanname('Select Continuous or Timestamp Channels');
ExperimentName  = get(currExp,'Name');


% get and save data
if(~isempty(ChanNames))
    IDs = experiment(currExp, 'findchannelobjs', ChanNames);
else
    IDs = [];
end


if(~isempty(IDs))
    if any(isnull(IDs))
        error('**** Could not find some channels');
    else
        nID =length(IDs);
    end

    for iID = 1:nID
        hdr(iID)    = get(IDs(iID));
        temp        = getdata(currExp, ChanNames{iID}, TimeRange, {{}});
        temp        = temp{:};
        keyboard
        switch hdr(iID).Class
            case 'continuous channel'
                Data{iID}    = temp;
                accessory_data{iID}.Name  = [];
                    accessory_data{iID}.Data  = [];
            case 'timestamp channel'

                if(size(temp,1)>1)
                    Children = get(IDs(iID),'Children');
                    nChild  = length(Children);
                    accessory_flag  = false(1,nChild);
                    for iChild  = 1:nChild
                        accessory_flag(iChild)  = strcmp(get(Children(iChild),'Class'),'accessory data');
                    end
                    Children    = Children(accessory_flag);
                    nChild      = length(Children);
                    for iChild  = 1:nChild
                        accessory_Data{iID}(iChild).Name = get(Children(iChild),'Name');
                        accessory_Data{iID}(iChild).Data = temp(iChild+1,:);
                    end
                    Data{iID}   = temp(1,:) - TimeRange(1) * hdr(iID).SampleRate;
                else
                    Data{iID}    = temp(1,:) - TimeRange(1) * hdr(iID).SampleRate;
                    accessory_data{iID}.Name  = [];
                    accessory_data{iID}.Data  = [];

                end
            case 'interval channel'
                error('interval channelは今のところサポートしてません。というか、MDAのインターバルチャンネルはわかりづらくて嫌いです。代わりに、Start/Stopに使用するtimestampチャンネルをexportして、後でmakeOriginalChannelsを走らせてください。');
        end



    end     % ii=1:length(IDs)
end