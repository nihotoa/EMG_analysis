function ExtractAOevents_Wasa(monkeyname, year, month, day, whichfiles, outnumber, savepath, snippet)

% % clear all
% % whichfiles=6:8 ;
% % year='14' ;
% month='03' ;
% % day='20' ;
% % monkeyname='Mo' ;
% % outnumber=1 ;

%% concatenate events from different files

DI_codes=[];
item1_on=[];
item1_off=[];
item2_on=[];
item2_off=[] ;
item3_on=[];
item3_off=[] ;

warning('OFF','MATLAB:load:variablePatternNotFound');

for i=1:length(whichfiles)
    f=whichfiles(i) ;
    filename= ['F' xpdate '-' sprintf('%04d',f)];
    load(filename,'CTTL*', 'CIn*') ;
    
    if i==1
        TTL_SampleRate=CInPort_001_KHz*1000 ;
    end
    
    if exist('CInPort_001')
        DI_codes=[DI_codes CInPort_001] ;
    end
    
    allfiles(i,:)=filename ;
    
    clear CInP* event_ID
end

%% attributes codes easier to read to the main events of the task

event_ID=DI_codes(2,:); % ID of the codes
event_t=DI_codes(1,:) ; % timing of the codes

clear DI_codes ;

% trial outcome codes: last code of a trial

event_ID(event_ID==1345)=38;   % WRONG_TRIAL_ORDER
event_ID(event_ID==1024)=0;    % success !
event_ID(event_ID==256)=1;    % failed: trial never started
event_ID(event_ID==1280)=2;    % failed: release lever 1 early
event_ID(event_ID==64)=3;     % failed: release lever 2 early
event_ID(event_ID==1088)=4;    % failed: took too long to pull lever 2
event_ID(event_ID==1089)=36;   % failed: release lever 3 early
event_ID(event_ID==321)=37;   % failed: took too long to pull lever 3

% task events
event_ID(event_ID==1296)=10;   % start pulling lever 1
event_ID(event_ID==80)=11;   % end pulling lever 1
event_ID(event_ID==1104)=12;   % start pulling lever 2
event_ID(event_ID==336)=13;   % end pulling lever 2
event_ID(event_ID==1360)=14;   % start release GO signal 1
event_ID(event_ID==4)=15;    % end release GO signal 1
event_ID(event_ID==1028)=16;   % start release GO signal 2
event_ID(event_ID==260)=17;   % end release GO signal 2
event_ID(event_ID==1284)=18;   % start reward
event_ID(event_ID==68)=19;   % end reward
event_ID(event_ID==1092)=20;   % trial start

% event_ID(event_ID==63488)=30;   % end hold item
% event_ID(event_ID==1024)=31;   % end hold item
event_ID(event_ID==1025)=32;   % PULL_LEVER_3
event_ID(event_ID==257)=33;   % RELEASE_LEVER_3
event_ID(event_ID==1281)=34;   % BEGIN_GO_3
event_ID(event_ID==65)=35;   % END_GO_3


% event_ID(event_ID==0)=38;   % WRONG_TRIAL_ORDER

% % event_ID(event_ID==24576)=5;    % failed: RT too long
% % event_ID(event_ID==57344)=6;    % failed: MT too long
% % event_ID(event_ID==4096)=7;     % failed: delay between touching and pulling item too long
% % event_ID(event_ID==36864)=8;    % failed: too long to take lever to final position
% % event_ID(event_ID==20480)=9;    % failed: EMG too high during human's turn
% 
% % % add code 20 from manipulandum, meaning "press HP a beginning of trial"
% % event_ID(event_ID==1024)=21;    % start delay 1
% % event_ID(event_ID==10240)=22;   % item visible (panel ON)
% % event_ID(event_ID==43008)=23;   % leave HP before GO (timing corrected afterwards)
% % event_ID(event_ID==26624)=24;   % start GO signal
% % event_ID(event_ID==59392)=25;   % end GO signal
% % event_ID(event_ID==63488)=26;   % leave HP (for RT) (timing corrected afterwards)
% % event_ID(event_ID==6144)=27;    % start touching item (timing corrected afterwards)
% % event_ID(event_ID==38912)=28;   % start pulling item
% % event_ID(event_ID==22528)=29;   % start hold period of item
% % event_ID(event_ID==55296)=30;   % end hold item
% % % add code 31 from manipulandum meaning "end touch item"
% % event_ID(event_ID==17408)=32;   % start release GO signal
% % event_ID(event_ID==50176)=33;   % end release GO signal
% % %event_ID(event_ID==14336);   % unused
% % event_ID(event_ID==47104)=34;   % start reward
% % event_ID(event_ID==30720)=35;   % end reward

% make a cell to remember the meaning of each code
codelegend={0 'end of trial: success' 'EOD success'; 1 'end of trial: trial never started' 'EOD no start'; 2 'end of trial: release lever 1 early' 'EOD lever 1 early'...
    ; 3 'end of trial: release lever 2 early' 'EOD lever 2 early'; 4 'end of trial: too long to pull lever 2' 'EOD lever 2 timeout'...
    ; 10 'start pulling lever 1' 'lever 1 start' ...
    ; 11 'releasing lever 1' 'lever 1 end'...
    ; 12 'start pulling lever 2' 'lever 2 start'; 13 'releasing lever 2' 'lever 2 end'...
    ; 14 'start release signal 1' 'GO 1 start'...
    ; 15 'end release signal 1' 'GO 1 end'; 16 'start release signal 2' 'GO 2 start '; 17 'end release signal 2' 'GO 2 end' ...
    ; 18 'start reward beep' 'start reward'; 19 'end reward beep' 'end reward'; 20 'start trial' 'start trial' ...
    ; 32 'start pulling lever 3' 'lever 3 start' ...
    ; 33 'releasing lever 3' 'lever 3 end'} ;

% timestamps coming from the manipulandum (not Tempo), but theoretically
% not relevant for the task
% 127 % touching item (correspond to event 27)
% 131 % releasing item (correspond to event 31)
% 120 % start pressing HP (correspond to event 20)
% 126 % leave HP (correspond to event 26)

%  plot(event_t, event_ID, '-<')
%  grid on
%  ylim([-1 21])

event_ID2 = event_ID ;
event_t2  = event_t ;
%% integrates the TTL codes from the manipulandum with the codes of the 16 bit port

% integrates the codes of the 16 bit port with the TTLs single bit channels

% change the timing of the onset of the pulling of item 1 (code 10),
% and replace it with the TTL "item1_on"

if ~isempty(item1_on)
    a=find(event_ID==10) ;
    b=knnsearch(item1_on',event_t(a)','K',2) ;
    bb=[item1_on(b(:,1))' item1_on(b(:,2))'] - repmat(event_t(a)',1,2);
    bb(bb>0)=9999999999999;
    [abi, bi]=min(abs(bb), [],2) ;
    bi(abi>500)=[] ;
    a(abi>500)=[];
    b(abi>500,:)=[];
    
    for i=1:length(bi)
        index_TTL(i)=b(i,bi(i)) ;
    end
    
    % replace the tempo code by the corresponding real timestamps
    event_t(a)=item1_on(index_TTL) ;
    % remove them from the timestamp file
    item1_on(index_TTL)=[] ;
    
    clear a b index_TTL bi bb i
    
    % finally, if there are timestamps left, integrates them in the code array
    % as "code 110"
    if ~isempty(item1_on)
        [event_t,i]=sort([event_t item1_on]) ;
        event_ID=[event_ID 110*ones(size(item1_on))] ;
        event_ID=event_ID(i) ;
    end
    
    % do the same for "release item 1" and "item1_off"
    
    a=find(event_ID==11) ;
    b=knnsearch(item1_off',event_t(a)','K',2) ;
    bb=[item1_off(b(:,1))' item1_off(b(:,2))'] - repmat(event_t(a)',1,2);
    bb(bb>0)=9999999999999;
    [abi, bi]=min(abs(bb), [],2) ;
    bi(abi>500)=[] ;
    a(abi>500)=[];
    b(abi>500,:)=[];
    
    for i=1:length(bi)
        index_TTL(i)=b(i,bi(i)) ;
    end
    
    % replace the tempo code by the corresponding real timestamps
    event_t(a)=item1_off(index_TTL) ;
    % remove them from the timestamp file
    item1_off(index_TTL)=[] ;
    
    clear a b index_TTL bi bb i
    
    % finally, if there are timestamps left, integrates them in the code array
    % as "code 111"
    if ~isempty(item1_off)
        [event_t,i]=sort([event_t item1_off]) ;
        event_ID=[event_ID 111*ones(size(item1_off))] ;
        event_ID=event_ID(i) ;
    end
end

if ~isempty(item2_on)
    
    % change the timing of the onset of the pulling of item 2 (code 12),
    % and replace it with the TTL "item2_on"
    
    a=find(event_ID==12) ;
    b=knnsearch(item2_on',event_t(a)','K',2) ;
    bb=[item2_on(b(:,1))' item2_on(b(:,2))'] - repmat(event_t(a)',1,2);
    bb(bb>0)=9999999999999;
    [abi, bi]=min(abs(bb), [],2) ;
    bi(abi>500)=[] ;
    a(abi>500)=[];
    b(abi>500,:)=[];
    
    for i=1:length(bi)
        index_TTL(i)=b(i,bi(i)) ;
    end
    
    % replace the tempo code by the corresponding real timestamps
    event_t(a)=item2_on(index_TTL) ;
    % remove them from the timestamp file
    item2_on(index_TTL)=[] ;
    
    clear a b index_TTL bi bb i
    
    % finally, if there are timestamps left, integrates them in the code array
    % as "code 112"
    if ~isempty(item2_on)
        [event_t,i]=sort([event_t item2_on]) ;
        event_ID=[event_ID 112*ones(size(item2_on))] ;
        event_ID=event_ID(i) ;
    end
    
    % do the same for the release of item 2 and the TTL "item2_off"
    
    a=find(event_ID==13) ;
    b=knnsearch(item2_off',event_t(a)','K',2) ;
    bb=[item2_off(b(:,1))' item2_off(b(:,2))'] - repmat(event_t(a)',1,2);
    bb(bb>0)=9999999999999;
    [abi, bi]=min(abs(bb), [],2) ;
    bi(abi>500)=[] ;
    a(abi>500)=[];
    b(abi>500,:)=[];
    
    for i=1:length(bi)
        index_TTL(i)=b(i,bi(i)) ;
    end
    
    % replace the tempo code by the corresponding real timestamps
    event_t(a)=item2_off(index_TTL) ;
    % remove them from the timestamp file
    item2_off(index_TTL)=[] ;
    
    clear a b index_TTL bi bb i
    
    % finally, if there are timestamps left, integrates them in the code array
    % as "code 113"
    if ~isempty(item2_off)
        [event_t,i]=sort([event_t item2_off]) ;
        event_ID=[event_ID 113*ones(size(item2_off))] ;
        event_ID=event_ID(i) ;
    end
end

% a=find(event_ID==20) ;
% b=find(event_ID==10) ;
%
% for i=1:length(a)
%     aa(i,:)=event_t(a(i))-event_t(b) ;
%     aa(i,aa(i,:)<0 | aa(i,:)>500)=9999999999 ;
% end

% aa=repmat(event_t(a)',size(event_t(b))) ;
% bb=repmat(event_t(b),size(event_t(a)')) ;
% dif=aa-b' ;


%%
if ~isempty(snippet)
    f=whichfiles(1) ;
    filename= ['F' year month day '-' sprintf('%04d',f)];
    load(filename,'CEMG_041_TimeBegin') ;
    
    snip= snippet*TTL_SampleRate+CEMG_041_TimeBegin*TTL_SampleRate;
    bla=event_t>=snip(1) & event_t<=snip(2) ;
    event_ID=event_ID(bla) ;
    event_t=event_t(bla) ;
end

event_ID_all=event_ID;
event_t_all=event_t ;

if ~(isempty(item1_on) && isempty(item2_on))
    x=event_ID>100 ;
    event_ID(x)=[] ;
    event_t(x)=[] ;
end

% return
% plot(event_t2,event_ID2, '-^') ;
% hold on
% grid on
% plot(event_t,event_ID, 'm-^') ;
%
%
% plot(event_ID2, '-^') ;
% hold on
% grid on
% plot(event_ID, 'm-^') ;
% vline(item1_on, '-r')
% vline(item2_off, '-g')
% vline(item2_on, '--m')
%% make a matrix to divide events into trials

trial_starts=find(event_ID==20) ;
trial_ends=find(event_ID<=4);%find(event_ID<=4 | event_ID>=36) ; %36 for 3 objects, but might not work correctly. CHECK!!! formerly 4 --> took too long to pull lever 2

reward_trial = find(event_ID==18);

if trial_starts(2)<trial_ends(1)
    correct_first_trial = find(trial_starts<trial_ends(1),1, 'last');
    trial_starts = trial_starts(correct_first_trial:end);
end

if trial_starts(1)>trial_ends(1)
    trial_ends(1)=[] ;
end

if trial_starts(end)>trial_ends(end)
    trial_starts(end)=[] ;
end




% truncate the lenght of the trials down to the shortest vector. whetehr it's trial starts or ends (by RPh 19/02/2015)

trial_starts = trial_starts(1:min([length(trial_starts),length(trial_ends)]));
trial_ends = trial_ends(1:min([length(trial_starts),length(trial_ends)]));

% figure;
% plot(trial_starts(1:(end-5)),trial_ends);
% trial_dur=trial_ends-trial_starts;
% figure;
% plot(trial_dur)




if length(trial_starts)~=length(trial_ends)
    error('not same number of trial starts and ends.') ;
end

alltrials_legend={'index of first event', 'index of last event', 'trial outcome'} ;

alltrials=[trial_starts' trial_ends' event_ID(trial_ends)'] ;

helpfile={'event_ID' 'codes of task-relevant behavioral events' ; 'event_t' 'absolute timing of the codes in event_ID' ...
    ;'TTL_SampleRate' 'recording sample rate in Hz' ; 'alltrials' 'information about each trial: index of first and last event in event_t and event_ID, outcome of the trial' ;
    'alltrials_legend' 'legend of the columns in alltrials' ; 'codelegend' 'legend of the codes in event_ID' ...
    ; 'snippet' 'snippet of data from the original data, if periods were excluded'} ;

save(fullfile(savepath,[monkeyname year month day '_AOevents_' outnumber]), 'alltrials*', 'allfiles','event_*', 'TTL_SampleRate', 'helpfile', 'codelegend', 'snippet');

clearvars -except monkeyname b test testtest