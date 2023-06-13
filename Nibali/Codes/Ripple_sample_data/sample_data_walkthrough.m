%{
Ripple Sample Data Walkthrough
This mfile uses the NeuroShare tool box to read in the sample data set
saved via Trellis. Using map file: map_example.map.

Recording Spikes on Micro+Stim in A-1: ch 1-32
Recording Stim on Nano2+Stim on B-1: ch 1
Recording LFP on Micro+Stim in A-1: ch 1-32
Analog 1: 2 Vpp @ 1 kHz
Analog 4: LFP from Micro+Stim in A-1: ch 1
SMA 2:  Spike trigger from A-1: ch 1
Parallel: Stim trigger for B-1: ch 1 on bit0

%}

% Load NEV file into memory
[ns_RESULT, hFile] = ns_OpenFile('sample_data_set.nev');
[ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);

numEnt = length(hFile.Entity);

fs_clock = 30000;

for ii = 1:numEnt
    
    etype = hFile.Entity(ii).EntityType;
    
    switch(etype)
        case 'Analog'
            
            % get entire waveform
            [nsres, wf_c, wf] = ns_GetAnalogData(hFile, ii, 1, 1e8);
            [ns_RESULT, nsAnalogInfo] = ns_GetAnalogInfo(hFile, ii);
            
            t_ = (0:(wf_c-1))/nsAnalogInfo.SampleRate;% + nsFileInfo.NIPTime/fs_clock;
            
            figure; plot(t_,wf); ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Label,'Interpreter','none');
            
        case 'Segment'
            
            t = (-14:37)/fs_clock; % time, with 0 being time of spike
            t = (0:51)/fs_clock; % time, with timestamp at start of waveform
            
            % get stim timestamps
            [res, nsInfo] = ns_GetEntityInfo(hFile, ii);

            figure; hold on;
            for jj=1:nsInfo.ItemCount
                [res, ts, seg_data, seg_dsize, unitid] = ...
                    ns_GetSegmentData(hFile, ii, jj);
                plot(t+ts,seg_data); % ssequential
                %plot(t,seg_data); % on top
            end
            hold off;
            ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Label,'Interpreter','none');

        case 'Event'
            
            [ns_RESULT, nsEventInfo] = ns_GetEventInfo(hFile, ii);
            N = hFile.Entity(ii).Count;
            ts = zeros(1,N); xs = ts;
            for jj = 1:N
                [ns_RESULT, TimeStamp, Data, DataSize] = ...
                    ns_GetEventData(hFile, ii, jj);
                ts(jj) = TimeStamp;
                xs(jj) = Data;
            end
            figure; stairs(ts,xs,'b.-');
            ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Reason,'Interpreter','none');
            
        otherwise
            disp(['not analog, segment, or event, skipping entity ',num2str(ii,'%d')]);
            break
    end
    
    
    
    
end
ns_CloseFile(hFile);