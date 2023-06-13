clear all
cd C:\Data\Wasa

load('Wa181001-0004');

% % % NEW
% % % event_ID(event_ID==1296)=10;   % start pulling lever 1 --> for Wasa this is home pad push
% % % event_ID(event_ID==80)=11;   % end pulling lever 1 --> for Wasa this is home pad release
% % % event_ID(event_ID==1104)=12;   % start pulling lever 2
% % % event_ID(event_ID==336)=13;   % end pulling lever 2
% % % event_ID(event_ID==1284)=18;   % start reward
% % % event_ID(event_ID==68)=19;   % end reward

% % % OLD (until 4th June 2018)
% % % % task events
% % % event_ID(event_ID==49664)=10;   % start pulling lever 1
% % % event_ID(event_ID==2560)=11;   % end pulling lever 1
% % % event_ID(event_ID==35328)=12;   % start pulling lever 2
% % % event_ID(event_ID==18944)=13;   % end pulling lever 2



Timing = CInPort_001(1,find(CInPort_001(2,:)==1104))-CRAW_001_TimeBegin*CInPort_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! ==80 for new filesa !!!!!!!!!!!!


%FOR STIMULATION
% Timing = CStimMarker_001(1,find(CStimMarker_001(2,:)==10010))-CRAW_001_TimeBegin*CStimMarker_001_KHz*1000; % 2560 (end pulling lever 1) for older files!!! 


Timing = Timing/(CInPort_001_KHz/CLFP_001_KHz);

%FOR STIMULATION
% Timing = Timing/(CStimMarker_001_KHz/CLFP_001_KHz);



if Timing(1) < 2750;
    Timing(1) = [];
end



align_M1 = [];

for j = 1:32
    
    eval(['RAW_LFP_0', num2str(j, '%0.2d'), '= double(CRAW_0', num2str(j,'%0.2d'), ')*CRAW_001_BitResolution / CRAW_001_Gain;']);
    
        if Timing(length(Timing)) > length(RAW_LFP_001)+2750 %!!!!!!!!!!!! LFP_001
            Timing(length(Timing)) = [];
        end
        
    for i=1:length(Timing)-2
        eval(['align_M1(j, 1:6750,i) = RAW_LFP_0',num2str(j,'%0.2d'), '(Timing(i)-1350:Timing(i)+1350*4-1);']);
    end
end


% % from 14th August, 2018 (new connector, no channels have to be removed)
for j=1:32
    for i=1:length(Timing)-2
    aligned_M1(j,:,i) = align_M1(j,:,i)-mean(align_M1(1:32,:,i),1); %bad channels removed  1:14,18:32
    end
end

% % USE FOR STIMULATION, ARTIFACT WOULD BE AVERAGED OVER ALL CHANNELS
for j=1:32
    for i=1:length(Timing)-2
    align_M1(j,:,i)-mean(align_M1([11,15],:,i),1); %bad channels removed  1:14,18:32                                 % (until 13th August, 2018)
    end
end



% align_S1 = [];
% 
% for j = 33:64
%     
%     eval(['real_LFP_0', num2str(j, '%0.2d'), '= double(CLFP_0', num2str(j,'%0.2d'), ')*CLFP_001_BitResolution / CLFP_001_Gain;']);
%     
%         if Timing(length(Timing)) > length(real_LFP_033)+2750 %!!!!!!!!!!!! LFP_001 for M1
%             Timing(length(Timing)) = [];
%         end
%         
%     for i=1:length(Timing)-2
%         eval(['align_S1(j, 1:6750,i) = real_LFP_0',num2str(j,'%0.2d'), '(Timing(i)-1350:Timing(i)+1350*4-1);']);
%     end
% end
% 
% for j=33:64 %1:32
%     for i=1:length(Timing)-2
%     aligned_S1(j,:,i) = align_S1(j,:,i)-mean(align_S1([33:64],:,i),1); %bad channels removed  1:14,18:32
%     end
% end



save Wasa_Wa181004_STIMonset_M1
% save Wasa_Wa180823_StimGlobel_M1