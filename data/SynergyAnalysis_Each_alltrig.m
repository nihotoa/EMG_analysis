function [Yall] = SynergyAnalysis_Each_alltrig()
%% set parameter
% nrep = 20;
nrep = 20;
alg  = 'mult';
convMethod = 'Takei';
dataTrig = 'EMG'; % EMG(TTakeifilt), EMG_NDfilt(NUchida filt)
WtType = 'filtNO5';
% realname = 'SesekiL';
realname = 'Yachimun';
% realname = 'Matatabi';
global task;
task = 'standard';
save_fold = 'easyData';
fixType = 'none'; %FIXW : fix W as static structure, FIXH : fix H (use the result of FIXW), eachFIXW : use the result of both (W and H) variable analysis 
make_EMGaveData = 1;

%% basic information about monkeys
switch realname 
    case 'SesekiL'
        EMGselect = [12 6 5 4 2 3 1 8 11]; %SsekiL
        EMGn = length(EMGselect);
        %{'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'}??
        %{'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'}??????????
        trig = 3;
        synN = 4;
        rng = [-15 15];
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
        mpv_order = [1 2 3 4 5 6 7 8 9 10 11 12];
   case 'Matatabi'
        EMGselect = [1 2 3 4 5 6]; %Yachimun
        EMGn = length(EMGselect);
        %range, trig, synNum
        trig = 2;
        synN = 3;
        rng = [-25 5];
        mpv_order = [1 2 3 4 5 6];
end

%% select standard files which you'd like to extract muscle synergy
Allfiles_S = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,['_' task '.mat'],'');
%% load dataset for analsysis 
cd([realname '/' save_fold '/P-DATA'])
switch dataTrig
   case {'EMG_NDfilt','EMG'}
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
               Wt = Wt([9 11 10 8 12 7 1 2 6 5 4 3],:);
            case 'FIXH'
%                 FIXHdata = load('synplot_results_syn4_pre_nnmffunc_prenormalizedcon_FIXW.mat');
%                 FIXHdata = load('synplot_results_syn4_post_nnmffunc_prenormalizedcon_FIXW47.mat');
                FIXHdata = load(['synplot_results_syn' sprintf('%d',synN) '_post_FIXW_trig' sprintf('%d',trig) '.mat']);
            case 'eachFIXW'
        end
    case 'Matatabi'
       switch fixType
            case 'FIXW'
               WtAll = load([realname 'controlWt_' WtType '.mat']);
               eval(['Wt = WtAll.aveWt_synN' sprintf('%d',synN)]);
               Wt = Wt([4 3 1 6 5 2],:);
            case 'FIXH'
%                 FIXHdata = load('synplot_results_syn4_pre_nnmffunc_prenormalizedcon_FIXW.mat');
%                 FIXHdata = load('synplot_results_syn4_post_nnmffunc_prenormalizedcon_FIXW47.mat');
                FIXHdata = load(['synplot_results_syn' sprintf('%d',synN) '_post_FIXW_trig' sprintf('%d',trig) '.mat']);
            case 'eachFIXW'
        end
end
%% NMF part (cut data, matrix factrization)
Yall = cell(S(2),1);
PreAdata = cell(S(2),1);
trialNall = zeros(S(2),1);
    for s = 1:S(2)%session loop
        X = load([Allfiles{s} '_dataTrig' dataTrig '.mat']);
        T = load([Allfiles{s} '_Pdata.mat']);
        switch trig
            case {1,2,3,4}
               eval(['DataSize = size(X.alignedData_trial.tData' sprintf('%d',trig) '{1});']);
            case 'Task'
               eval(['DataSize = size(X.alignedData_trial.tData' trig '{1});']);
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
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData2{m}(t,round((T.D.trig2_per(1)+rng(1))*dataN/100):round((T.D.trig2_per(1)+rng(2))*dataN/100));
                    end
                 case 2 
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData2{m}(t,round((T.D.trig2_per(1)+rng(1))*dataN/100):round((T.D.trig2_per(1)+rng(2))*dataN/100));
                    end
                    
                case 3 
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData3{m}(t,round((T.D.trig3_per(1)+rng(1))*dataN/100):round((T.D.trig3_per(1)+rng(2))*dataN/100));
                    end
                case 4
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tData4{m}(t,round((T.D.trig4_per(1)+rng(1))*dataN/100):round((T.D.trig4_per(1)+rng(2))*dataN/100));
                    end
               case 'Task'
                    for m = EMGselect
                        Acel{m} = X.alignedData_trial.tDataTask{m}(t,:);
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