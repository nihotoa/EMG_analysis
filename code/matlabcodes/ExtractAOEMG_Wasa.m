function ExtractAOEMG_Wasa(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, selEMGs, snippet)
%

%%
EMGs=cell(14,3) ;
EMGs{1,1}= 'Delt';
EMGs{2,1}= 'Biceps';
EMGs{3,1}= 'Triceps';
EMGs{4,1}= 'BRD';
EMGs{5,1}= 'cuff';
EMGs{6,1}= 'ED23';
EMGs{7,1}= 'ED45';
EMGs{8,1}= 'ECR';
EMGs{9,1}= 'ECU';
EMGs{10,1}= 'EDC';
EMGs{11,1}= 'FDS';
EMGs{12,1}= 'FDP';
EMGs{13,1}= 'FCU';
EMGs{14,1}= 'FCR';
% % EMGs{15,1}= 'FDS';
% % EMGs{16,1}= 'FCR';
% % EMGs{17,1}= 'FDP-U';
% % EMGs{18,1}= 'FDP-R';
% % EMGs{19,1}= 'AbDM';
% % EMGs{20,1}= '4DI' ;
% % EMGs{21,1}= 'AbPB_2';
% % EMGs{22,1}= '2DI_2' ;
% % EMGs{23,1}= 'FDI_2' ;
% % EMGs{24,1}= 'ADP_2' ;

a=zeros(14,1) ;
a(selEMGs)=1 ;
for i=1:length(EMGs)
    t=['EMG_0' sprintf('%02d',i)] ;
    eval([t '=[];']);
    EMGs{i,3}=a(i) ;
end
gen_info=0 ;
emglist=[1:14] ;
%%
for i=1:length(whichfiles)
    f=whichfiles(i) ;
    filename= ['Wa' year month day '-' sprintf('%04d',f)];
    %     disp(['importing EMG data of ' filename])
    load(filename, 'CEMG*', 'SF_FILTER');
    allfiles(i,:)=filename ;

    if i==1
        EMG_Filter_HP=SF_FILTER(4,SF_FILTER(2,:)==10288) ;
        EMG_Filter_LP=SF_FILTER(3,SF_FILTER(2,:)==10288) ;
    end
    
    for ii=selEMGs
        t=['CEMG_0' sprintf('%02d',emglist(ii))] ;
        tt=['EMG_0' sprintf('%02d',ii)] ;
        if exist(t)
            eval([tt '=[' tt  ' ' t '];']) ;
            EMGs{ii,2}= tt ;
            
            if gen_info==0
                % general information
                eval(['EMG_SampleRate=' t '_KHz*1000 ;']) ;
                eval(['EMG_gain=' t '_Gain ;']) ;
                eval(['EMG_BitResolution=' t '_BitResolution ;']) ;
                eval(['EMG_TimeBegin=' t '_TimeBegin ;']) ;
                gen_info=1 ;
            end
            clear t tt
        end
    end
    
    clear CEMG*
end
%% if specified, only keep a snippet of time

if ~isempty(snippet)
    
    for ii=1:length(EMGs)
        if exist(EMGs{ii,2}, 'var')
            eval(['tt='  EMGs{ii,2} ';' ]) ;
            
            if ~isempty(tt)
                if snippet(1)==0
                    snip(1)=1;
                else
                    snip(1)=round(snippet(1)*EMG_SampleRate) ;
                end
                if isinf(snippet(2))
                    snip(2)=length(tt);
                else
                    snip(2)=round(snippet(2)*EMG_SampleRate) ;
                end
                tt=tt(snip(1):snip(2)) ;
                eval([EMGs{ii,2} '=tt;' ]) ;
                clear tt
            end
        end
    end
    
    EMG_TimeBegin=EMG_TimeBegin+snippet(1) ;
end

EMGs(cellfun('isempty',EMGs(:,2)),3)={0} ;

%%
helpfile={'EMG_00X' 'EMG signal, filtered by AO. separate variables for memory reasons' ; ...
    'EMGs' 'name of muscle is in first collumn, name of corresponding variable in second collumn, imported or not in 3rd collumn' ; 'EMG_SampleRate' 'Recording sample rate in Hz' ; 'EMG_TimeBegin' ...
    'timing of the first data point (in second)' ; 'EMG_gain' 'recording gain' ; 'EMG_BitResolution' 'factor to convert analog data in microvolts'...
    ; 'EMG_Filter_HP' 'high-pass filter of the harware filtering' ; 'EMG_Filter_LP' 'low-pass filter of the harware filtering' ; ...
    'selEMGs' 'which EMGs channels are imported'} ;

save(fullfile(savepath,[monkeyname year month day '_EMG_' sessionnumber]),'EMG*', 'helpfile', 'snippet', 'selEMGs', 'allfiles') ;
