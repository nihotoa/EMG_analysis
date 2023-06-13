function ExtractAORAW_fast(monkeyname, year, month, day, whichfiles, outnumber, savepath, snippet)
% % 
% clear all
% 
% whichfiles=2:9 ;
% year='14' ;
% month='03' ;
% day='11' ;
% monkeyname='Ha' ;
% outnumber=1 ;
% parentdirectory='C:\Users\joachim\Documents\MATLAB\test setup\data\' ;
% savepath= [parentdirectory monkeyname year month day '_' int2str(outnumber) '\'];
%%

RAWs=cell(17,2) ;
for i=1:length(RAWs)
    RAWs{i,1}=['V-probe position ' int2str(i)] ;
    t=['RAW_0' sprintf('%02d',i)] ;
    eval([t '=[];']);
end
    
RAWs{17,1}='single electrode' ;

for i=1:length(whichfiles)
    f=whichfiles(i) ;
    filename= ['Wa' year month day '-' sprintf('%04d',f)];
    load(filename, 'CRAW*', 'SF_FILTER');
    allfiles(i,:)=filename ;

    if i==1
        RAW_SampleRate=CRAW_001_KHz*1000 ;
        RAW_TimeBegin=CRAW_001_TimeBegin ;
        RAW_gain=CRAW_001_Gain ;
        RAW_BitResolution=CRAW_001_BitResolution ;
        
        RAW_Filter_HP=SF_FILTER(4,SF_FILTER(2,:)==10384) ;
        RAW_Filter_LP=SF_FILTER(3,SF_FILTER(2,:)==10384) ;
    end

    for ii=1:length(RAWs)
        t=['CRAW_0' sprintf('%02d',ii)] ;
        tt=['RAW_0' sprintf('%02d',ii)] ;
        if exist(t)
            eval([tt '=[' tt  ' ' t '];']) ;
            RAWs{ii,2}= tt ;
            clear t tt
        end
    end
    
    clear CRAW* SF_FILTER
end

%% if specified, only keep a snippet of time

if ~isempty(snippet)
    
    for ii=1:length(RAWs)
        if exist(RAWs{ii,2}, 'var')
            eval(['tt='  RAWs{ii,2} ';' ]) ;
            
            if ~isempty(tt)
                if snippet(1)==0
                    snip(1)=1;
                else
                    snip(1)=round(snippet(1)*RAW_SampleRate) ;
                end
                if isinf(snippet(2))
                    snip(2)=length(tt);
                else
                    snip(2)=round(snippet(2)*RAW_SampleRate) ;
                end
                tt=tt(snip(1):snip(2)) ;
                eval([RAWs{ii,2} '=tt;' ]) ;
                clear tt
            end
        end
    end
    
    RAW_TimeBegin=RAW_TimeBegin+snippet(1) ;
end

%%
helpfile={'RAW_00X' 'RAW neuronal signal, unfiltered. separate variables for memory reasons' ; ... 
    'RAWs' 'list of variable names for the different channels. number of electrode is in first collumn' ; ...
    'RAW_SampleRate' 'Recording sample rate in Hz' ; 'RAW_TimeBegin' ...
    'timing of the first data point (in second)' ; 'RAW_gain' 'recording gain' ; 'RAW_BitResolution' 'factor to convert analog data in microvolts'...
    ; 'RAW_Filter_HP' 'high-pass filter of the harware filtering' ; 'RAW_Filter_LP' 'low-pass filter of the harware filtering'} ;

save(fullfile(savepath,[monkeyname year month day '_RAW_' int2str(outnumber)]),'RAW*', 'helpfile', 'snippet','allfiles') ;

