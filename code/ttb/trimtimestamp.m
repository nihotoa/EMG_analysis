function trimtimestamp
tsName      = 'Grip Onset (svwostim)';
dir_flags    = [0 1 2];    % 0=all, 1=down, 2= up

Expnames    = {'EitoT004',...
    'EitoT005',...
    'EitoT009',...
    'EitoT010'};

nExp    = length(Expnames);
dfirstcells  = [2063 2883    3923   3299]; % um
deepesttimes = [9120 5470    12111  10685]; % sec

% criteria    = [0, 500;...    250,    750;...
%     500,    1000;...    750,    1250;...
%     1000,   1500;...    1250,   1750;...
%     1500,   2000;...    1750,   2250;...
%     2000,   2500;...    2250,   2750;...
%     2500,   3000;...    2750,   3250;...
%     3000,   3500;...    3250,   3750;...
%     3500,   4000];

criteria    = [0, 1000;...
    250,    1250;...
    500,    1500;...    
    750,    1750;...
    1000,   2000;...    
    1250,   2250;...
    1500,   2500;...    
    1750,   2750;...
    2000,   3000;...    
    2250,   3250;...
    2500,   3500;...    
    2750,   3750;...
    3000,   4000];

for iExp  = 1:nExp

    rootpath    = fullfile(matdata,Expnames{iExp});
    ts	= load(fullfile(rootpath,tsName));
    dp  = load(fullfile(rootpath,'Electrode Depth(um)'));
    
    dfirstcell      = dfirstcells(iExp);
    deepesttime     = deepesttimes(iExp);

    if ts.SampleRate ~= dp.SampleRate
        disp('SampleRate合ってる？？')
        return;
    end

    deepesttimeIndex    = deepesttime*ts.SampleRate + 1;


    for ii=1:length(dir_flags)
        dir_flag    = dir_flags(ii);
        switch dir_flag
            case 1
                prefix      = 'down';
                tsData  = ts.Data(ts.Data <= deepesttimeIndex); % トラックの下りのときのデータだけ使う
            case 2
                prefix      = 'up';
                tsData  = ts.Data(ts.Data > deepesttimeIndex); % トラックの上がりのときのデータだけ使う
            otherwise
                prefix      = 'all';
                tsData  = ts.Data; % 全部のデータを使う
        end

        dpData  = dp.Data(tsData)-dfirstcell;

        for ii  = 1:size(criteria,1)
            outputname  = [tsName,'(',prefix,'-',num2str(criteria(ii,1)),'-',num2str(criteria(ii,2)),')'];

            S           = ts;
            S.Data      = tsData(dpData>=criteria(ii,1)&dpData<criteria(ii,2));
            S.Name      = outputname;

            save(fullfile(rootpath,outputname),'-struct','S');
            disp([fullfile(rootpath,outputname),' was saved. Data Size=',num2str(size(S.Data))])
        end
    end
end