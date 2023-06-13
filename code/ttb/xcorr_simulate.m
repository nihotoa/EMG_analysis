function [rou,p]=xcorr_simulate(data,data2,nLags,BinWidth,SDBins,Time,samplerate,ntrials)
tic
% ntrials = 100;
% nLags   = 1000;
% BinWidth    = 1;
% SDBins      = 10;
% Time        = [0 300];
% data    = a(1).data;% timestanp
% data2   = a(3).data;% continuous
% samplerate  = 20000;

% >> 元のデータでピーク相関係数（rou）を求める。
    samples = zeros(1, SDBins * 4 + (Time(2) - Time(1)) * 1000 / BinWidth);
    timestampBins = floor((data(1,:) * 1000.0) / (samplerate * BinWidth)) + SDBins * 2;
    n = length(timestampBins);
    nsamples = length(samples);
    for i=1:n
        bin = timestampBins(i);
        if bin > nsamples
            break;
        end
        samples(bin) = samples(bin) + 1;
    end
    samples = filter(discretegaussian(SDBins, SDBins * 4 + 1), 1, samples);
    samples = samples(SDBins * 4 + 1 : end);

    % <<downsample end
    
    %　>>　samples(->data1)とdata2のピーク相関係数を求めてrou(ii)に入れる
    data1   = samples;
    data1 = data1 - mean(data1);
    
    n1 = length(data1);
    n2 = length(data2);
    if n1 ~= n2
    %     disp(['ACorr: Warning, unequal data lengths for: ', name{i}, '(n=', num2str(n1), '), ', name{j}, '(n=', num2str(n2), '), in experimenent ', expName]);
        newSize = min(n1, n2);
        data1 = data1(1:newSize);
        data2 = data2(1:newSize);
    end

    [xcorrs, lags] = xcorr(data1, data2, nLags, 'coeff');
    [maxv,imax] = max(abs(xcorrs));
    rou = xcorrs(imax);
%     disp(rou)
% << 元のデータでピーク相関係数（rou）を求める。

for ii=1:ntrials
    
    % >>Time*samplerateの範囲で、dataと同じサイズのランダムなタイムスタンプ列(rdata)を作る
    rand('state',sum(100*clock));
    rdata   =rand(size(data));    %0.0-1.0の範囲で一様な確率
    rdata   =round(rdata*(Time(2)-Time(1))*samplerate+Time(1)*samplerate); %Time(1)*samplerate-Time(2)*samplerateの範囲
    rdata   =sort(rdata,2,'ascend');   %時系列データとして昇順にソート
    % <<
    
    
    % >>rdataをdownsampleしてcontinuousな時系列データ(samples)にする
    samples = zeros(1, SDBins * 4 + (Time(2) - Time(1)) * 1000 / BinWidth);
    timestampBins = floor((rdata(1,:) * 1000.0) / (samplerate * BinWidth)) + SDBins * 2;
    n = length(timestampBins);
    nsamples = length(samples);
    for i=1:n
        bin = timestampBins(i);
        if bin > nsamples
            break;
        end
        samples(bin) = samples(bin) + 1;
    end
    samples = filter(discretegaussian(SDBins, SDBins * 4 + 1), 1, samples);
    samples = samples(SDBins * 4 + 1 : end);

    % <<downsample end
    
    %　>>　samples(->data1)とdata2のピーク相関係数を求めてrou(ii)に入れる
    data1   = samples;
    data1 = data1 - mean(data1);
    
    n1 = length(data1);
    n2 = length(data2);
    if n1 ~= n2
    %     disp(['ACorr: Warning, unequal data lengths for: ', name{i}, '(n=', num2str(n1), '), ', name{j}, '(n=', num2str(n2), '), in experimenent ', expName]);
        newSize = min(n1, n2);
        data1 = data1(1:newSize);
        data2 = data2(1:newSize);
    else
        newSize = n1;
    end

    [xcorrs, lags] = xcorr(data1, data2, nLags, 'coeff');
    global takei
    takei{1}=xcorrs;
    takei{2}=lags;    
    [maxv,imax] = max(abs(xcorrs));
    
    rous(ii)    = xcorrs(imax);
    % <<
    if (mod(ii,10)==0)
        disp([num2str(ii),'trials   ',num2str(toc),'(sec)'])        
    end
end
p   =sum(abs(rous)>=abs(rou))/ntrials;
disp(['rou=',num2str(rou),'   p=',num2str(p)])
% figure;hist(abs(rous))