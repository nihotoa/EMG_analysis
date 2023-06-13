function kitamidi_makemettemplate
%%%%%%%%%%%%%%%%%%%%
% Set Parameters
%%%%%%%%%%%%%%%%%%%%

%パスを選んでください。
filename    = 'P:\Data\Kita\Movie_00_(20130318104951).wav';
mettemplate_filename = 'P:\Data\Kita\mettemplate.mat';

%時間を選んでください(sec)。
timerange = [60 61];    % metronome only

%Metronomeの周波数帯域を選択してください。
metfreqrange    = [3000 inf];

%移動FFT解析する時間解像度
nfftwin = 256;
dT      = 0.001; %sec

%音声シグナルとノイズを切り分ける閾値
snth    = 0;    % percent

%2階微分した時の閾値
metsnth2    = -5e-006;

%微分する際の平滑化時間（ある時点より前X秒間の平均と、後ろX秒間の平均の差を求める）
nsmooth = 0.1;   % sec

%メトロノームの切り出す時間幅
mettimerange    = [-0.05 0.2];

%%%%%%%%%%%%%%%%%%%%


[Y,FS] = wavread(filename);
X   = ((1:length(Y))-1)/FS;

Y   = Y(X>=timerange(1) & X<=timerange(2));
% X   = X(X>=timerange(1) & X<=timerange(2));

dT  = (floor(FS.*dT))./FS;

[S,F,T,P] = spectrogram(Y,nfftwin,(nfftwin-FS.*dT),nfftwin,FS);


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


% % メトロノームのテンプレートを作成

% mettemplate
nmet    = length(mettime);
mettimerangeind = floor(mettimerange ./ dT) ;
mettemplate   = nan(length(F),mettimerangeind(2)-mettimerangeind(1)+1,nmet);



for imet=1:nmet
    startind    = mettimeind(imet)+mettimerangeind(1);
    stopind     = mettimeind(imet)+mettimerangeind(2);

    if(startind>=1 && stopind<=nT)
        mettemplate(:,:,imet) = P(:,startind:stopind);
    end
end

mettemplate   = nanmean(mettemplate,3);

save(mettemplate_filename,'mettemplate','mettimerange');




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