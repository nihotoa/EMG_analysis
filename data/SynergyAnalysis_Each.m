%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
目標：このクソみたいなコードを解読すること
please set current dir as 'data'
%trouble point
easyData -> P-DATA -> eachSyn4con.matはどの関数で作られるのか?
synplot_results_syn4_post_FIXW_trig1.matはどの関数で作られるのか？
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yall] = SynergyAnalysis_Each()
%% settings
% nrep = 20;
nrep = 20;
alg  = 'mult';
convMethod = 'Takei';
dataTrig = 'EMG_NDfilt'; % EMG(TTakeifilt), EMG_NDfilt(NUchida filt)
WtType = 'filtNO5';
% realname = 'SesekiL';
realname = 'Yachimun';
global task;
task = 'standard';
save_fold = 'easyData';
fixType = 'FIXH'; %FIXW : fix W as static structure, FIXH : fix H (use the result of FIXW), eachFIXW : use the result of both (W and H) variable analysis 
make_EMGaveData = 0;

switch realname 
    case 'SesekiL'
        EMGselect = [12 6 5 4 2 3 1 8 11]; %SsekiL
        EMGn = length(EMGselect);
        %{'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'}??
        %{'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'}??????????
        trig = 3;
        synN = 4;
        rng = [-15 15];
%         %averaged W value in 200117, 200119, 200120
%         Wt = [0.295831902735274,0.647581611198144,0.512484735394365;...
%               1.02487282392244,0.633370815481093,0.680329231346413;...
%               0.314160974923295,0.960106124635076,0.686683457871271;...
%               0.401137844520291,0.658558626101923,1.14714113532109;...
%               1.14642587372624,0.0348692320077074,0.278376675607631;...
%               0.830777172058581,0.0742780015584719,0.246643741188330;...
%               1.04654462628161,0.0913631589734942,0.262859257445150;...
%               0.0162689711664235,1.16892867575555,0.306215131316755;...
%               0.161556032468142,0.872338375879118,0.310106350002910];
        %averaged W value in 200117, 200119
        % Wt = [0.177602306046587,1.02204320788470,0.466012001773749;...
        %     0.808288172116166,0.471125817830836,0.219609321514101;...
        %     0.341318057209398,1.11818366253313,0.174556494309163;...
        %     0.102767608374375,0.221499232248307,1.52571404254396;...
        %     1.15600686263263,0.0847403362133115,0.324159462461283;...
        %     0.981423471677633,0.178242742525461,0.398840559523247;...
        %     1.14997287449600,0.163834361267128,0.241858265501353;...
        %     0.0477436658410045,1.33307434185017,0.0934606532952011;...
        %     0.273528146911561,0.971815695011839,0.206724681025619];
%         Wt = Wt([7 5 6 4 3 2 8 9 1],:);
        mpv_order = [1 2 3 4 5 6 8 11 12];
    case 'Yachimun'
        EMGselect = [1 2 3 4 5 6 7 8 9 10 11 12]; %Yachimun
        EMGn = length(EMGselect);
        %{'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'}??
        %{'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'}??????????
        
        %range, trig, synNum
        trig = 1;
        synN = 4;
        rng = [-25 5];
        
%         %range, trig, synNum
%         trig = 2;
%         synN = 4;
%         rng = [-15 15];

%         Wt = [1.49323022611735,0.0397318310791186,0.0460139583825142,0.0983236048311538;...
%               1.60784023729382,0.000496296531144027,0.210366124002408,0.200287599481687;...
%               0.415186107979537,0.350151743360627,0.00426027802975028,1.34110809737388;...
%               0.431625706985393,0.00474083025246242,0.319292662456333,1.55722910702634;...
%               0.0110818783041949,0.00533094786078267,0.621782446222554,1.93605546655492;...
%               1.45627302711619,1.13654471795474e-06,0.458479884923028,0.275785050634193;...
%               0.483630623634477,0.198178135488708,1.71092365226358,0.0641136726587648;...
%               0.376445260291431,1.58598760492346,0.0867735363468484,0.0455000905644715;...
%               1.46608078336290,0.334446496142377,0.00520858218878363,0.0146272062212853;...
%               0.154552101532872,1.68556675455529,0.312543314614253,0.0581839095697953;...
%               0.0210493319401135,1.98924316755835,0.0610565075806292,0.0759549458663837;...
%               0.0482422771028691,0.544509273427235,1.71064062492813,0.190017344153075];
%           Wt = Wt([9 11 10 8 12 7 1 2 6 5 4 3],:);
          mpv_order = [1 2 3 4 5 6 7 8 9 10 11 12];
end
disp("please select all refenrece day's '_standard.mat' ")
Allfiles_S = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');
%% 
cd([realname '/' save_fold '/P-DATA'])
switch dataTrig
   case 'EMG_NDfilt'
      load(['eachSyn' sprintf('%d',synN) 'con_AVE.mat'],['meanPre_val_trig' sprintf('%d',trig)])
      eval(['meanPre_val = meanPre_val_trig' sprintf('%d',trig) ';'])
   otherwise
      load(['eachSyn' sprintf('%d',synN) 'con_AVE.mat'])
end
% load('SeLSynfixedW_filt2_syn3.mat')
switch realname 
    case 'SesekiL'
        switch fixType
            case 'FIXW'
               WtAll = load([realname 'controlWt_' WtType '.mat']);
               eval(['Wt = WtAll.aveWt_synN' sprintf('%d',synN)]);
%                switch synN
%                   case 3
%                      %5Hz LPF version
% %                       Wt = [0.0785042468976446,0.497599274543455,0.912455348069243;0.627423083320095,0.376530919496763,1.82655563479344;0.355757574135311,0.947319047281033,0.449020478121019;0.692170667067916,0.583246684583885,0.126721803748429;1.22525009355801,0.0850756257014174,0.394305398070133;1.14812638604122,0.144798148801834,0.232637146719784;1.08815052599004,0.0992901958340266,0.379639643452521;0.0434210835322471,1.51098781844858,0.159770542874924;0.158593126487766,0.994205543704110,0.315975711262197];
%                       Wt = [0.295831902735274,0.647581611198144,0.512484735394365;...
%                             1.02487282392244,0.633370815481093,0.680329231346413;...
%                             0.314160974923295,0.960106124635076,0.686683457871271;...
%                             0.401137844520291,0.658558626101923,1.14714113532109;...
%                             1.14642587372624,0.0348692320077074,0.278376675607631;...
%                             0.830777172058581,0.0742780015584719,0.246643741188330;...
%                             1.04654462628161,0.0913631589734942,0.262859257445150;...
%                             0.0162689711664235,1.16892867575555,0.306215131316755;...
%                             0.161556032468142,0.872338375879118,0.310106350002910];
%                   case 4
%                      %5Hz LPF version
% %                       Wt = [0.972563824035241,0.690439172314636,0.0151597363110010,0.162097308467191;0.277851402086077,2.21120925260438,0.442255906753044,0.542546543562437;1.36499177717139,0.156240743141139,0.121286089586767,0.479320587299683;0.153741907273329,0.199984077693563,1.19565855285775,0.380328906923915;0.0689691218904348,0.428348106975911,0.239326619072893,1.27929263835899;0.0646788404120626,0.210553372842737,0.374352919493586,1.16259135737344;0.169148825027374,0.378308567527401,0.0808503946615490,1.20603841372901;1.19320340140353,0.0635798565554907,0.932894876395423,0.00396818589030104;0.579628213125650,0.412463636035500,0.874344081825621,0.0544560524091020];
%                       Wt = [0.259022179727417,1.05600618698064,0.239509503490726,0.455520760290614;...
%                             0.348840506797647,0.966911860300564,0.432343163966132,0.263839071336143;...
%                             0.270906890284799,0.745711938571384,0.128352940760541,0.837144372057150;...
%                             0.130836065116181,0.170782255617130,1.89868913883173,0.262902291426893;...
%                             1.28055235744652,0.485011345289374,0.239648212544636,0.175143899103003;...
%                             1.46466054491805,0.116253596581585,0.698179724220475,0.117664958026463;...
%                             1.24256083764243,0.544209465771990,0.180316469742560,0.196168376449942;...
%                             0.0448535356883303,0.316297809479552,0.131536348261260,1.51327409205992;...
%                             0.152106720672155,0.513058061932892,0.283099363327384,1.04108563819746];
%                end
                Wt = Wt([7 5 6 4 3 2 8 9 1],:);
            case 'FIXH'
%                 FIXHdata = load('synplot_results_syn3_pre_nnmffunc_prenormalizedcon_filt2_FIXW.mat');
%                 FIXHdata = load(['synplot_results_syn' sprintf('%d',synN) '_post25_FIXW.mat']);
                FIXHdata = load(['synplot_results_syn' sprintf('%d',synN) '_pre_FIXW_trig' sprintf('%d',trig) '.mat']);
            case 'eachFIXW'
                load('SeLSynfixedW_filt2_syn3.mat')
        end
    case 'Yachimun'
        switch fixType
            case 'FIXW'
               WtAll = load([realname 'controlWt_' WtType '.mat']);
               eval(['Wt = WtAll.aveWt_synN' sprintf('%d',synN)]);
%                 Wt = [1.49323022611735,0.0397318310791186,0.0460139583825142,0.0983236048311538;...
%                       1.60784023729382,0.000496296531144027,0.210366124002408,0.200287599481687;...
%                       0.415186107979537,0.350151743360627,0.00426027802975028,1.34110809737388;...
%                       0.431625706985393,0.00474083025246242,0.319292662456333,1.55722910702634;...
%                       0.0110818783041949,0.00533094786078267,0.621782446222554,1.93605546655492;...
%                       1.45627302711619,1.13654471795474e-06,0.458479884923028,0.275785050634193;...
%                       0.483630623634477,0.198178135488708,1.71092365226358,0.0641136726587648;...
%                       0.376445260291431,1.58598760492346,0.0867735363468484,0.0455000905644715;...
%                       1.46608078336290,0.334446496142377,0.00520858218878363,0.0146272062212853;...
%                       0.154552101532872,1.68556675455529,0.312543314614253,0.0581839095697953;...
%                       0.0210493319401135,1.98924316755835,0.0610565075806292,0.0759549458663837;...
%                       0.0482422771028691,0.544509273427235,1.71064062492813,0.190017344153075];
                Wt = Wt([9 11 10 8 12 7 1 2 6 5 4 3],:);
            case 'FIXH'
%                 FIXHdata = load('synplot_results_syn4_pre_nnmffunc_prenormalizedcon_FIXW.mat');
%                 FIXHdata = load('synplot_results_syn4_post_nnmffunc_prenormalizedcon_FIXW47.mat');
                FIXHdata = load(['synplot_results_syn' sprintf('%d',synN) '_post_FIXW_trig' sprintf('%d',trig) '.mat']);
            case 'eachFIXW'
        end
end
        
Yall = cell(S(2),1);
PreAdata = cell(S(2),1);
trialNall = zeros(S(2),1);
    for s = 1:S(2)%session loop
        X = load([Allfiles{s} '_dataTrig' dataTrig '.mat']);
        T = load([Allfiles{s} '_Pdata.mat']);
        switch trig
            case 1
                DataSize = size(X.alignedData_trial.tData3{1});
            case 2
                DataSize = size(X.alignedData_trial.tData1{1});
            case 3
                DataSize = size(X.alignedData_trial.tData2{1});
        end
        trialN = DataSize(1);
        dataN = DataSize(2);
        W = cell(trialN,1);
        H = cell(trialN,1);
        D = cell(trialN,1);
        VAF = cell(trialN,1);
        Acel = cell(EMGn,1);
        dayA = cell(1,trialN);
        trialNall(s) = trialN;
        for t = 1:trialN
            switch trig
                 case 1
                    LenR = sum(X.D.Range3);
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData3{m}(t,round(dataN*(X.D.Range3(1)+rng(1))/100)+1:round(dataN*(X.D.Range3(1)+rng(2)/LenR)/100));
                    end
                 case 2 
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData1{m}(t,round((0.5+rng(1)/100)*dataN):round((0.5+rng(2)/100)*dataN));
                    end
                    
                case 3 
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData2{m}(t,round((0.5+rng(1)/100)*dataN):round((0.5+rng(2)/100)*dataN));
                    end
             end
            A = cell2mat(Acel);
            
            
            dayApreproc{1,t} = A;
            A = A - repmat(min(A,[],2),1,length(A));
%             [W{t},H{t},D{t},VAF{t}]   = nnmfT(A,synN,[],[],nrep,alg,'wh','mean','none',meanPre_val(mpv_order));
            switch fixType
                case 'FIXW'
                    [W{t},H{t},D{t},VAF{t}]   = nnmfT(A,synN,Wt,[],nrep,alg,'h','meanPre','none',meanPre_val(mpv_order),convMethod);
                case 'FIXH'
                    [W{t},H{t},D{t},VAF{t}]   = nnmfT(A,synN,[],FIXHdata.Yall{s}.H{t},nrep,alg,'w','meanPre','none',meanPre_val(mpv_order),convMethod);
                case 'eachFIXW'
                    [W{t},H{t},D{t},VAF{t}]   = nnmfT(A,synN,Wt{s},[],nrep,alg,'h','meanPre','none',meanPre_val(mpv_order),convMethod);
               case 'none'
                  [W{t},H{t},D{t},VAF{t}]   = nnmfT(A,synN,[],[],nrep,alg,'wh','meanPre','none',meanPre_val(mpv_order),convMethod);
            end
            
%             A = A./repmat(mean(A,2),1,length(A));
            if make_EMGaveData == 1
                
                if t==1
                    Aave = mean(A,2);
                else
                    Aave = (Aave + mean(A,2))./2;
                end
            end
            A = A./repmat(meanPre_val(mpv_order)',1,length(A));
            dayA{1,t} = A;
            opt = statset('MaxIter',1000);
%             [W{t},H{t},D{t}]   = nnmf(A,synN,'replicates',nrep,'algorithm',alg,'options',opt);
%             [W{t},H{t},D{t}]   = nnmf(A,synN,'w0', Wt,'replicates',nrep,'algorithm',alg,'options',opt);%fixed W by control 3 sessions 
        end
        PreAdata{s,1} = dayA;
        PreAdatapre{s,1} = dayApreproc;
        Y.W = W;
        Y.H = H;
        Y.D = D;
        Y.VAF = VAF;
%         save([Allfiles{s} '_EachSynNNMFfunc_' sprintf('%d',synN) '.mat'],'Y');
        Yall{s} = Y;
    end
    
    switch realname
        case 'SesekiL'
            %make matrix for plotting Pre Data
            %SesekiL:{'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'}
            plotTar_AVE = cell(S(2),EMGn);
            for s= 1:S(2)
                for M = 1:EMGn
                    plotTar = cell(trialNall(s),1);
                    plotTarpre = cell(trialNall(s),1);
                    for t = 1:trialNall(s)
                        plotTar{t} = PreAdata{s}{t}(M,:);
                        plotTarpre{t} = PreAdatapre{s}{t}(M,:);
                    end
                    plotTar_AVE{s,M} = mean(cell2mat(plotTar));
                    plotTar_AVEpre{s,M} = mean(cell2mat(plotTarpre));
                end
            end
            MM = 1;
            SeND = 68;
            figure;
            cRGB = linspace(0, 1, 28);
            for s = 1:S(2)
                plot(normalizeData(plotTar_AVE{s,MM},SeND),'Color',[cRGB(s) 0 0])
                hold on;
            end
            figure;
            for s = 1:S(2)
                plot(normalizeData(plotTar_AVEpre{s,MM},SeND),'Color',[0 cRGB(s) 0])
                hold on;
            end
        case 'Yachimun'
    end
end
function[wbest,hbest,normbest,VAFbest] = nnmfT(a,k,w0,h0,nrep,alg,target_param,pre_normalize,post_normalize,meanPre_val,convMethod)

% a:  data ([mm,nn]=size(a) mm channels x nn data length)
% k:  ?^?[?Q?b?g??????NMF????
% w0,h0?F  w??h???????l?A?????_???????n????????????[]???????B
% target_param?F 'wh' or 'h' ?????p?????[?^???X?V???????Hh????????????w??h
% post_normalize?F   ???????v?Z??????????H???m?[?}???C?Y???????????? 'mean'or 'none'

if(nargin<3)
    w0      = [];
    h0      = [];
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<4)
    h0      = [];
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<5)
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
   
elseif(nargin<6)
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<7)
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<8)
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<9)
    post_normalize  = 'none';
end

% 
% alg     = 'mult';

% nrep    = 1;
maxiter = 1000;
tolx    = 10^-6;
toln    = 30;
w0isempty   = isempty(w0);
h0isempty   = isempty(h0);

% w0      = [];
% h0      = [];
%

% Check required arguments
%error(nargchk(2,Inf,nargin,'struct'))
[n,m] = size(a);
if ~isscalar(k) || ~isnumeric(k) || k<1 || k>min(m,n) || k~=round(k)
    error('stats:nnmf:BadK',...
        'K must be a positive integer no larger than the number of rows or columns in A.');
end

if(strcmp(alg,'mult'))
    ismult  = true;
else
    ismult  = false;
end


S = RandStream.getGlobalStream;

fprintf('repetition\titeration\tSSE\tVAF\tdVAF\tAlgorithm\n');


% pre_normalize
switch pre_normalize
    case 'mean'
        a   = normalize(a,'mean');
        disp([mfilename,': pre_normalize = mean']);
    case 'meanPre'
         a   = a./repmat(meanPre_val',1,length(a));
        disp([mfilename,': pre_normalize = meanPre']);
    case 'none'
        disp([mfilename,': pre_normalize = none']);
end


for irep=1:nrep
    
    if(w0isempty)
        w0  = rand(S,n,k);
    end
    if(h0isempty)
        h0  = rand(S,k,m);
    end
    
    % Perform a factorization
    switch convMethod
       case 'Takei'
          [w1,h1,norm1,iter1,SSE1,VAF1,dVAF1] =    nnmfB(a,w0,h0,ismult,target_param,maxiter,tolx,toln);
       case 'defaultMatlab'
          [w1,h1,norm1,iter1,SSE1,VAF1,dVAF1] =    nnmfA(a,w0,h0,ismult,target_param,maxiter,tolx,toln);
    end
    
    
    fprintf('%7d\t%7d\t%12g\t%12g\t%12g\t%s\t%s\n',irep,iter1,SSE1,VAF1,dVAF1,alg,target_param);
    if(irep==1)
        wbest   = w1;
        hbest   = h1;
        normbest    = norm1;
        iterbest    = iter1;
        SSEbest     = SSE1;
        VAFbest     = VAF1;
        dVAFbest    = dVAF1;
        irepbest    = irep;
    else
        if(norm1<normbest)
            wbest   = w1;
            hbest   = h1;
            normbest    = norm1;
            iterbest    = iter1;
            SSEbest     = SSE1;
            VAFbest     = VAF1;
            dVAFbest    = dVAF1;
            irepbest    = irep;
        end
    end
    
end




fprintf('Final result:\n');
fprintf('%7d\t%7d\t%12g\t%12g\t%12g\n',irepbest,iterbest,SSEbest,VAFbest,dVAFbest);


if normbest==Inf
    error('stats:nnmf:NoSolution',...
        'Algorithm could not converge to a finite solution.')
end


hlen = sqrt(sum(hbest.^2,2));
if any(hlen==0)
    warning('stats:nnmf:LowRank',...
        'Algorithm converged to a solution of rank %d rather than %d as specified.',...
        k-sum(hlen==0), k);
    hlen(hlen==0) = 1;
end

switch post_normalize
    case 'mean'
        % H??Unit??????????????normalize?????B
        A   = mean(hbest,2);
        wbest   = wbest .* repmat(A',size(wbest,1),1);
        hbest   = hbest ./ repmat(A ,1,size(hbest,2));
        disp([mfilename,': post_normalize = mean']);
    case 'none'
        disp([mfilename,': post_normalize = none']);
end
% wbest = bsxfun(@times,wbest,hlen');
% hbest = bsxfun(@times,hbest,1./hlen);




% Then order by w
switch target_param
   case 'w'
   case 'h'
   otherwise
      [~,idx] = sort(sum(wbest.^2,1),'descend');
      wbest = wbest(:,idx);
      hbest = hbest(idx,:);
end

end

% -------------------dafault MATLAB nnmf convergence 
function [w,h,dnorm,iter,SSE,VAF,dVAF] = nnmfA(a,w0,h0,ismult,target_param,maxiter,tolx,toln)
% Single non-negative matrix factorization
sqrteps = sqrt(eps);

for iter=1:maxiter
    if ismult
        % Multiplicative update formula
        switch lower(target_param)
            case 'wh'
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                numer   = a*h';
                w       = w0 .* (numer ./ (w0*(h*h') + eps(numer)));
            case 'h'
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                w       = w0;
            case 'w'
                h       = h0;
                numer   = a*h';
                w       = w0 .* (numer ./ (w0*(h*h') + eps(numer)));
        end
                
%         disp('mult')
    else
        % Alternating least squares
        switch lower(target_param)
            case 'wh'
                h = max(0, w0\a);
                w = max(0, a/h);
            case 'h'
                h = max(0, w0\a);
                w = w0;
            case 'w'
                h = h0;
                w = max(0, a/h);
        end
%         disp('als')
    end
    
    
    % Get norm, SSE, SST and VAF
    b = w*h;
    A   = reshape(a,numel(a),1);
    B   = reshape(b,numel(b),1);
    D   = A-B;
    dnorm   = sqrt(sum(D.^2)/length(D));
    dw = max(max(abs(w-w0) / (sqrteps+max(max(abs(w0))))));
    dh = max(max(abs(h-h0) / (sqrteps+max(max(abs(h0))))));
    delta = max(dw,dh);
    SSE = sum(D.^2);    % sum of squared residuals (errors)
    SST = sum((A-mean(A)).^2);  % sum of squared total?
    
    
    % Check for convergence
    if(iter==1)
        VAF     = nan(1,maxiter);
        dVAF    = nan(1,maxiter);
%         fig = figure;
%         if ismult
%             set(fig,'Name','nnmf -mult','Numbertitle','off');
%         else
%             set(fig,'Name','nnmf -als','Numbertitle','off');
%         end
%         hAx(1)  = subplot(2,1,1,'Parent',fig);
%         hL(1)  = plot(hAx(1),[1,2],[0 0],'b');
%         xlabel(hAx(1),'# iterations')
%         ylabel(hAx(1),'VAF')
%         hAx(2)  = subplot(2,1,2,'Parent',fig);
%         hL(2)  = plot(hAx(2),[1,2],[0 0],'b');hold(hAx(2),'on')
%         hL(3)  = plot(hAx(2),[1,2],[tolx tolx],'r');
%         
%         xlabel(hAx(2),'# iterations')
%         ylabel(hAx(2),'dVAF')
    end
    
    VAF(iter)  = 1 - SSE./SST;
%     set(hL(1),'XData',1:iter,'YData',VAF(1:iter));axis(hAx(1),'tight');
%     title(hAx(1),['iteration: ',num2str(iter)])
    
    if(iter==1)
        dVAF(iter) = VAF(iter);
    else
        dVAF(iter) = VAF(iter)-VAF(iter-1);
    end
%     set(hL(2),'XData',1:iter,'YData',dVAF(1:iter));
%     set(hL(3),'XData',[1,iter]);axis(hAx(2),'tight');
    
    drawnow;
    %         keyboard
% % % %     if(iter>=toln)
% % % %         if(all(dVAF((iter-toln+1):iter)<tolx))
% % % % %             close(fig)
% % % %             break;
% % % %         end
% % % %     elseif(iter==maxiter)
% % % %         disp('*******Iteration reached maxiter before convergence.')
% % % %         break;
% % % %     end
% % % %     
     if iter>1
        if delta <= 10^-4
            break;
        elseif dnorm0-dnorm <= tolx*max(1,dnorm0)
            break;
        elseif iter==maxiter
            break
        end
    end

    % Remember previous iteration results
    dnorm0 = dnorm;
    w0 = w;
    h0 = h;
end
VAF = VAF(iter);
dVAF = dVAF(iter);


end


% -------------------TAKEI METHOD only change convergence part
function [w,h,dnorm,iter,SSE,VAF,dVAF] = nnmfB(a,w0,h0,ismult,target_param,maxiter,tolx,toln)
% Single non-negative matrix factorization


for iter=1:maxiter
    if ismult
        % Multiplicative update formula
        switch lower(target_param)
            case 'wh'
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                numer   = a*h';
                w       = w0 .* (numer ./ (w0*(h*h') + eps(numer)));
            case 'h'
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                w       = w0;
            case 'w'
                h       = h0;
                numer   = a*h';
                w       = w0 .* (numer ./ (w0*(h*h') + eps(numer)));
        end
                
%         disp('mult')
    else
        % Alternating least squares
        switch lower(target_param)
            case 'wh'
                h = max(0, w0\a);
                w = max(0, a/h);
            case 'h'
                h = max(0, w0\a);
                w = w0;
            case 'w'
                h = h0;
                w = max(0, a/h);
        end
%         disp('als')
    end
    
    
    % Get norm, SSE, SST and VAF
    b = w*h;
    A   = reshape(a,numel(a),1);
    B   = reshape(b,numel(b),1);
    D   = A-B;
    dnorm   = sqrt(sum(D.^2)/length(D));
    SSE = sum(D.^2);    % sum of squared residuals (errors)
    SST = sum((A-mean(A)).^2);  % sum of squared total?
    
    
    % Check for convergence
    if(iter==1)
        VAF     = nan(1,maxiter);
        dVAF    = nan(1,maxiter);
%         fig = figure;
%         if ismult
%             set(fig,'Name','nnmf -mult','Numbertitle','off');
%         else
%             set(fig,'Name','nnmf -als','Numbertitle','off');
%         end
%         hAx(1)  = subplot(2,1,1,'Parent',fig);
%         hL(1)  = plot(hAx(1),[1,2],[0 0],'b');
%         xlabel(hAx(1),'# iterations')
%         ylabel(hAx(1),'VAF')
%         hAx(2)  = subplot(2,1,2,'Parent',fig);
%         hL(2)  = plot(hAx(2),[1,2],[0 0],'b');hold(hAx(2),'on')
%         hL(3)  = plot(hAx(2),[1,2],[tolx tolx],'r');
%         
%         xlabel(hAx(2),'# iterations')
%         ylabel(hAx(2),'dVAF')
    end
    
    VAF(iter)  = 1 - SSE./SST;
%     set(hL(1),'XData',1:iter,'YData',VAF(1:iter));axis(hAx(1),'tight');
%     title(hAx(1),['iteration: ',num2str(iter)])
    
    if(iter==1)
        dVAF(iter) = VAF(iter);
    else
        dVAF(iter) = VAF(iter)-VAF(iter-1);
    end
%     set(hL(2),'XData',1:iter,'YData',dVAF(1:iter));
%     set(hL(3),'XData',[1,iter]);axis(hAx(2),'tight');
    
    drawnow;
    %         keyboard
    if(iter>=toln)
        if(all(dVAF((iter-toln+1):iter)<tolx))
%             close(fig)
            break;
        end
    elseif(iter==maxiter)
        disp('*******Iteration reached maxiter before convergence.')
        break;
    end
    
    % Remember previous iteration results
    %     dnorm0 = dnorm;
    w0 = w;
    h0 = h;
end
VAF = VAF(iter);
dVAF = dVAF(iter);


end

function [DATA] = normalizeData(origData, dataPointN)
    L = length(origData);
    if L == dataPointN
        DATA = origData;
    elseif L < dataPointN
        DATA = interpft(origData,dataPointN);
    else
        DATA = resample(origData,dataPointN,L);
    end
end