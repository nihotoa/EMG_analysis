function[wbest,hbest,normbest] = nnmf2(a,k,w0,h0,nrep,alg,target_param,pre_normalize,post_normalize)

% a:  data ([mm,nn]=size(a) mm channels x nn data length)
% k:  ターゲットとするNMFの数
% w0,h0：  wとhの初期値、ランダムから始めたい場合は[]にする。
% target_param： 'wh' or 'h' どのパラメータを更新するか？hのみもしくはwとh
% post_normalize：   最後に計算したあとのHでノーマライズするかどうか 'mean'or 'none'

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
maxiter = 1000; %情報更新ルールを最大で何回行うか
tolx    = 10^-4; %dVAFの値の閾値
toln    = 20; %何個の初期値でnmfを行うか
w0isempty   = isempty(w0); %w0がemptyならw0isemptyにlogical値1が代入される
h0isempty   = isempty(h0);

% w0      = [];
% h0      = [];
%

% Check required arguments
%error(nargchk(2,Inf,nargin,'struct'))
[n,m] = size(a);
if ~isscalar(k) || ~isnumeric(k) || k<1 || k>min(m,n) || k~=round(k) %ここよく分からない
    error('stats:nnmf:BadK',...
        'K must be a positive integer no larger than the number of rows or columns in A.');
end

if(strcmp(alg,'mult')) %よくわからない
    ismult  = true;
else
    ismult  = false;
end


S = RandStream.getGlobalStream; %乱数作成のアルゴリズム

fprintf('repetition\titeration\tSSE\tVAF\tdVAF\tAlgorithm\n');


% pre_normalize
switch pre_normalize
    case 'mean'
        a = normalize(a,'mean'); %正規化(おそらく前段階で済み)
        disp([mfilename,': pre_normalize = mean']);
    case 'none'
        disp([mfilename,': pre_normalize = none']);
end


for irep=1:nrep
    
    if(w0isempty)
        w0  = rand(S,n,k); %n*k列の乱数行列を作成
    end
    if(h0isempty)
        h0  = rand(S,k,m); %k*m列の乱数行列を作成
    end
    
    % Perform a factorization
    [w1,h1,norm1,iter1,SSE1,VAF1,dVAF1] =    nnmf1(a,w0,h0,ismult,target_param,maxiter,tolx,toln);
    %w1:乗法更新後の最終的な空間シナジー h1:最終的な時間シナジー norm1:最終的なノルム(どの乱数からのデータを適用するかの判断材料) iter1:何回乗法更新したか
    %SSE1:最終的なSSE VAF1:最終的なVAF dVAF1:最後のdVAF
    
    fprintf('%7d\t%7d\t%12g\t%12g\t%12g\t%s\t%s\n',irep,iter1,SSE1,VAF1,dVAF1,alg,target_param);
    if(irep==1) %1個目の乱数による、NMFの結果
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
        % HのUnitを揃えるためにnormalizeする。
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
[~,idx] = sort(sum(wbest.^2,1),'descend');
wbest = wbest(:,idx);
hbest = hbest(idx,:);



end



% -------------------
function [w,h,dnorm,iter,SSE,VAF,dVAF] = nnmf1(a,w0,h0,ismult,target_param,maxiter,tolx,toln)
% Single non-negative matrix factorization
sqrteps = sqrt(eps);

for iter=1:maxiter %何回情報更新するか
    if ismult
        % Multiplicative update formula
        switch lower(target_param)
            case 'wh' %w,hの両方を乗法更新する
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                numer   = a*h';
                w       = w0 .* (numer ./ (w0*(h*h') + eps(numer)));
            case 'h'
                numer   = w0'*a;
                h       = h0 .* (numer ./ ((w0'*w0)*h0 + eps(numer)));
                w       = w0;
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
        end
%         disp('als')
    end
    
    
    % Get norm, SSE, SST and VAF
    b = w*h; %乗法更新した後のwとhから構成された筋電
    A   = reshape(a,numel(a),1); %a(筋電X)の要素同士の比較を容易にするために一行の行列にサイズ変換する
    B   = reshape(b,numel(b),1); %b(再構成筋電wh)
    D   = A-B; %X-wh
    dnorm   = sqrt(sum(D.^2)/length(D)); %筋電と再構成筋電のユークリッドノルム
    SSE = sum(D.^2);    % sum of squared residuals (errors)
    SST = sum((A-mean(A)).^2);  % sum of squared total?

    dw = max(max(abs(w-w0) / (sqrteps+max(max(abs(w0))))));
    dh = max(max(abs(h-h0) / (sqrteps+max(max(abs(h0))))));
    delta = max(dw,dh);
    
    % Check for convergence
    if(iter==1) %一番最初の乗法更新則の適用後
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
%     
%     drawnow;
    %         keyboard
    
    
%     TAKEI NNMF FUNC
% % %     if(iter>=toln)
% % %         if(all(dVAF((iter-toln+1):iter)<tolx))
% % % %             close(fig)
% % %             break;
% % %         end
% % %     elseif(iter==maxiter)
% % %         disp('*******Iteration reached maxiter before convergence.')
% % %         break;
% % %     end
    

%    MATLAB NNMF FUNC
     if iter>20
        if delta <= 1e-4
            break; %このfor文(乗法更新)を抜ける
        %elseif dnorm0-dnorm <= tolx*max(1,dnorm0)
        elseif dVAF(iter) <= tolx
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

