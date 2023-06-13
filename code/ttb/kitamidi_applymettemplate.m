function [keytime,mettime,nearestmettime,timediff,F,T,P]  = kitamidi
%%%%%%%%%%%%%%%%%%%%
% Set Parameters
%%%%%%%%%%%%%%%%%%%%

%パスを選んでください。
filename    = 'P:\Data\Kita\Movie_00_(20130318104951).wav';
mettemplate_filename = 'P:\Data\Kita\mettemplate.mat';

%時間を一つ選んでください(sec)。
% timerange   = [0    4];keyfreqrange    = [0 600];     % R1
% timerange   = [4    8];keyfreqrange    = [0 600];     % R2
% timerange   = [9    13];keyfreqrange    = [0 600];    % R3
% timerange   = [13   17];keyfreqrange    = [0 600];    % R4
% timerange   = [17   21];keyfreqrange    = [0 600];    % R5
% timerange   = [21   26];keyfreqrange    = [0 600];    % L1
% timerange   = [26   30];keyfreqrange    = [0 600];    % L1
% timerange   = [30   34];keyfreqrange    = [1000 1350];    % L2
% timerange   = [35   39];keyfreqrange    = [1000 1350];    % L2
% timerange   = [39   44];keyfreqrange    = [1200 1550];    % L3
% timerange   = [44   48];keyfreqrange    = [1200 1550];    % L3
% timerange   = [49   55];keyfreqrange    = [1200 1550];    % L4
% timerange   = [55   60];keyfreqrange    = [1200 1550];    % L4
% timerange   = [60   65];keyfreqrange    = [1200 1550];    % L5
% timerange   = [65   inf];keyfreqrange    = [1200 1550];   % L5
timerange = [60 61];    % metronome only


%KeyとMetronomeの周波数帯域を選択してください。
keyfreqrange    = [0 600];
% keyfreqrange    = [1100 1550];
metfreqrange    = [3000 inf];

%移動FFT解析する時間解像度
nfftwin = 256;
dT      = 0.001; %sec

%音声シグナルとノイズを切り分ける閾値
snth    = 0;    % percent

%2階微分した時の閾値
keysnth2    = -2e-004;
metsnth2    = -5e-006;

%微分する際の平滑化時間（ある時点より前X秒間の平均と、後ろX秒間の平均の差を求める）
nsmooth = 0.1;   % sec





%%%%%%%%%%%%%%%%%%%%


[Y,FS] = wavread(filename);
X   = ((1:length(Y))-1)/FS;

Y   = Y(X>=timerange(1) & X<=timerange(2));
% X   = X(X>=timerange(1) & X<=timerange(2));

dT  = (floor(FS.*dT))./FS;

[S,F,T,P] = spectrogram(Y,nfftwin,(nfftwin-FS.*dT),nfftwin,FS);


figure;
h(1)    = subplot(5,2,1);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
view(0,90);
title('spectrogram');xlabel('time(s)'); ylabel('frequency(Hz)');



% mettimeを決める
metfreqrangeind = F >= metfreqrange(1) & F <= metfreqrange(2);
met = mean(P(metfreqrangeind,:),1);
metpowerth  = prctile(met,snth);
met(met<metpowerth)   = 0;
dmet    = smoothdiff(met,floor(nsmooth./dT));
ddmet   = smoothdiff(dmet,floor(nsmooth./dT));

mettimeind = [0, dmet(1:end-1)] > 0 & dmet <= 0;
nT      = length(T);
Tind    = 1:nT;
mettimeind  = Tind(mettimeind);

% 2階微分した値の絶対値が閾値より大きいもののみとる
mettimeind  = mettimeind(ddmet(mettimeind)<metsnth2);
mettime =T(mettimeind);


%
load(mettemplate_filename)

nmet    = length(mettime);
mettimerangeind = floor(mettimerange ./ dT) ;

for imet=1:nmet
    startind    = mettimeind(imet)+mettimerangeind(1);
    stopind     = mettimeind(imet)+mettimerangeind(2);
    
    if(startind>=1 && stopind<=nT)
        P(:,startind:stopind)   = (sqrt(P(:,startind:stopind)) - sqrt(mettemplate)).^2;
%         P(:,startind:stopind)   = abs(P(:,startind:stopind) - mettemplate);
    end
end
    










h(2)    = subplot(5,2,2);
% plot(F,mean(P,2));
% title('power spectrum');xlabel('frequency(Hz)');ylabel('mean power')
surf(T,F,10*log10(P),'edgecolor','none'); axis tight;
view(0,90);
title('spectrogram');xlabel('time(s)'); ylabel('frequency(Hz)');


% keyfreqrangeind = F >= keyfreqrange(1) & F <= keyfreqrange(2);
% metfreqrangeind = F >= metfreqrange(1) & F <= metfreqrange(2);
% 
% key = mean(P(keyfreqrangeind,:),1);
% met = mean(P(metfreqrangeind,:),1);
% 
% keypowerth  = prctile(key,snth);
% metpowerth  = prctile(met,snth);
% 
% key(key<keypowerth)   = 0;
% met(met<metpowerth)   = 0;
% 
% 
% dkey    = smoothdiff(key,floor(nsmooth./dT));
% dmet    = smoothdiff(met,floor(nsmooth./dT));
% 
% ddkey   = smoothdiff(dkey,floor(nsmooth./dT));
% ddmet   = smoothdiff(dmet,floor(nsmooth./dT));
% 
% keytimeind = [0, dkey(1:end-1)] > 0 & dkey <= 0;
% mettimeind = [0, dmet(1:end-1)] > 0 & dmet <= 0;
% 
% Tind    = 1:length(T);
% keytimeind  = Tind(keytimeind);
% mettimeind  = Tind(mettimeind);
% 
% 
% % 2階微分した値の絶対値が閾値より大きいもののみとる
% keytimeind  = keytimeind(ddkey(keytimeind)<keysnth2);
% mettimeind  = mettimeind(ddmet(mettimeind)<metsnth2);
% 
% 
% 
% 
% keytime =T(keytimeind);
% mettime =T(mettimeind);
% 
% nearestmettime  = nearest(mettime,keytime,'before');
% timediff    = keytime - nearestmettime;
% 
% h(3)    = subplot(5,2,3);
% plot(T,key,'k-');title('keyboard -original');xlabel('time(s)');ylabel('power');
% hold on
% plot(keytime,key(keytimeind),'r*');
% 
% h(4)    = subplot(5,2,4);
% plot(T,met,'k-');title('metronome -original');xlabel('time(s)');ylabel('power');
% hold on
% plot(mettime,met(mettimeind),'b*');
% 
% h(5)    = subplot(5,2,5);
% plot(T,dkey,'k-');title('keyboard -derivative');xlabel('time(s)');ylabel('power');
% hold on
% plot(keytime,dkey(keytimeind),'r*');
% 
% h(6)    = subplot(5,2,6);
% plot(T,dmet,'k-');title('metronome -derivative');xlabel('time(s)');ylabel('power');
% hold on
% plot(mettime,dmet(mettimeind),'b*');
% 
% h(7)    = subplot(5,2,7);
% plot(T,ddkey,'k-');title('keyboard -derivative');xlabel('time(s)');ylabel('power');
% hold on
% plot(keytime,ddkey(keytimeind),'r*');
% plot([T(1) T(end)],ones(1,2)*keysnth2,'-r')
% 
% h(8)    = subplot(5,2,8);
% plot(T,ddmet,'k-');title('metronome -derivative');xlabel('time(s)');ylabel('power');
% hold on
% plot(mettime,ddmet(mettimeind),'b*');
% plot([T(1) T(end)],ones(1,2)*metsnth2,'-b')
% 
% 
% h(9)    = subplot(5,2,9);
% plot(keytime,zeros(size(keytime)),'r*',mettime,zeros(size(mettime)),'b*',nearestmettime,zeros(size(nearestmettime)),'g*')
% title('r:key, b:met, g:nearest-met');xlabel('time(s)');ylabel([]);
% 
% h(10)    = subplot(5,2,10);
% plot(timediff,'k-');title('key time - met time');xlabel('#stroke');ylabel('time difference (s)');
% 
% linkaxes(h([1,3:9]),'x')
% 
% 
% % % % % % メトロノームのテンプレートを作成して引き算しようとしたが、純粋なメトロノーム音のみの部分が少ないのでとりあえず諦め
% % % % %メトロノームの切り出す時間幅
% % % % mettimerange    = [-0.05 0.2];
% % % % % mettemplate
% % % % nT      = length(T);
% % % % Tind    = 1:nT;
% % % % 
% % % % nmet    = length(mettime);
% % % % mettimerangeind = floor(mettimerange ./ dT) ;
% % % % mettemplate   = nan(length(F),mettimerangeind(2)-mettimerangeind(1)+1,nmet);
% % % % 
% % % % 
% % % % mettimeind  = Tind(mettimeind);
% % % % 
% % % % for imet=1:nmet
% % % %     startind    = mettimeind(imet)+mettimerangeind(1);
% % % %     stopind     = mettimeind(imet)+mettimerangeind(2);
% % % % 
% % % %     if(startind>=1 && stopind<=nT)
% % % %         mettemplate(:,:,imet) = P(:,startind:stopind);
% % % %     end
% % % % end
% % % % 
% % % % mettemplate   = nanmean(mettemplate,3);
% % % % 
% % % % save('mettemplate.mat','mettemplate');
% 
% 


end

function y  = smoothdiff(x,dt)
xx  = conv(x,ones(1,dt));

pre     = xx(1:length(x));
post    = xx(dt:end);

y   = post - pre;
end


function [result, index] = nearest(vector, values, method)
% function [result, index] = NEAREST(vector, values)
% Returns the value in the vector that is nearest the values requested
% Values in the vector must be sorted in either descending or ascending order


if numel(values)==1
    [result,index]  = local_nearest(vector,values, method);
else
    [m,n]   = size(values);
    values  = reshape(values,m*n,1);
    result  = nan(m*n,1);
    index   = nan(m*n,1);
    
    for ii=1:m*n
        [result(ii),index(ii)]  = local_nearest(vector,values(ii), method);
        
    end
    result  = reshape(result,m,n);
    index   = reshape(index,m,n);
    
end

end

function [result,index]  = local_nearest(vector,value,method)

switch method
    case 'before'
        vector(vector>value)    = inf;
    case 'after'
        vector(vector<value)    = -inf;
end


result = [];
index = [];
if isempty(vector) || isempty(value)
    return
end

if length(vector) == 1
    result = vector;
    index = 1;
    return
end

if vector(end) > vector(1)
    if value > vector(end)
        result = vector(end);
        index = length(vector);
        return
    end
    
    if value < vector(1)
        result = vector(1);
        index = 1;
        return
    end
else
    if value < vector(end)
        result = vector(end);
        index = length(vector);
        return
    end
    
    if value > vector(1)
        result = vector(1);
        index = 1;
        return
    end
end

[lnValue, index] = min(abs(vector - value));



result = vector(index);
end