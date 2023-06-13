function [Tar_hdr,Tar_dat]  = filtersta(Tar_hdr,Tar_dat,filter_type,filter_order,filter_opt,filter_direction)
% [Tar_hdr,Tar_dat]  = filtersta(Tar_hdr,Tar_dat,'FIR',100,[],'normal')
% [Tar_hdr,Tar_dat]  = filtersta(Tar_hdr,Tar_dat,'butter',2,{'stop',[55 65]},'normal')
% [Tar_hdr,Tar_dat]  = filtersta(Tar_hdr,Tar_dat,'cheby2',2,{'stop',[55 65],80},'normal')



switch lower(filter_type)
    case 'fir'
        B   = ones(1,filter_order)./filter_order;
        A   = 1;
        
        Tar_hdr.Name            = [Tar_hdr.Name,'[filter,FIR,',num2str(filter_order,'%g'),']'];

    case 'butter'
        Type    = filter_opt{1};
        W       = filter_opt{2};
        W        = (W .* 2) ./ Tar_hdr.SampleRate;
        
        [B,A]   = butter(filter_order,W,Type);
        
        Tar_hdr.Name            = [Tar_hdr.Name,'[filter,Butter,',num2str(filter_order,'%g'),',',Type,',',num2str(W,'%g'),']'];

    case 'cheby2'
        Type    = filter_opt{1};
        W       = filter_opt{2};
        R       = filter_opt{3};
        W        = (W .* 2) ./ Tar_hdr.SampleRate;
        
        [B,A]   = cheby2(filter_order,R,W,Type);
        
        
        Tar_hdr.Name            = [Tar_hdr.Name,'[filter,Butter,',num2str(filter_order,'%g'),',',Type,',',num2str(W,'%g'),',',num2str(R,'%g'),']'];
end
        
        
switch lower(filter_direction)
    case 'normal'
        Tar_hdr.YData   = filter(B,A,Tar_hdr.YData);
    case 'reverse'
        Tar_hdr.YData   = filter(B,A,Tar_hdr.YData(end:-1:1));
        Tar_hdr.YData   = Tar_hdr.YData(end:-1:1);
    case 'both'
        Tar_hdr.YData   = filtfilt(B,A,Tar_hdr.YData);
end


Tar_hdr.AnalysisType    = 'STA';
Tar_hdr.data_file       = ['._',Tar_hdr.Name];
Tar_hdr.Process.filter.Type     = filter_type;
Tar_hdr.Process.filter.Order    = filter_order;
Tar_hdr.Process.filter.Option   = filter_opt;
Tar_hdr.Process.filter.Direction= filter_direction;

fnames  = fieldnames(Tar_hdr);
fnames  = strfilt(fnames,'pse');
if(~isempty(fnames))
    nfnames = length(fnames);
    for ifnames=1:nfnames
        Tar_hdr = rmfield(Tar_hdr,fnames{ifnames});
    end
end
if(isfield(Tar_hdr,'TimeLabels'))
    Tar_hdr = rmfield(Tar_hdr,'TimeLabels');
end



nTrial  = size(Tar_dat.TrialData,1);

for iTrial=1:nTrial
    Data    = Tar_dat.TrialData(iTrial,:);
    switch lower(filter_direction)
    case 'normal'
        Data   = filter(B,A,Data);
    case 'reverse'
        Data   = filter(B,A,Data(end:-1:1));
        Data   = Data(end:-1:1);
    case 'both'
        Data   = filtfilt(B,A,Data);
    end

    Tar_dat.TrialData(iTrial,:) = Data;
end

Tar_dat.Name            = ['._',Tar_hdr.Name];
Tar_dat.hdr_file        = Tar_hdr.Name;


end
