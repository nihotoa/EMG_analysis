function mda2xls(opt)
% mda2xls([option])
% mda analysesのデータをxlsにエクスポートする
%
% Analyses Browserでエクスポートしたいファイルを選択してmda2xlsを走らせる
% 途中出力フォルダを指定するように求められる
% 
% トライアルのデータ（psthの場合はrasterのtimestamp、staの場合はトライアルごとのデータ）をエクスポートしたい場合は、
% mda2xls('-trial')
% と入力する。

% written by Tomohiko Takei 20101222
% modified by Tomohiko Takei 20120926 spike-triggered averageでも-trialを有効化

% Check Input argment

if(nargin<1)
   trial_flag       = false; 
else
    if(strcmp(lower(opt),'-trial'))
        trial_flag  = true;
    end
end
    

% Check Parameters

OutputParent    = getconfig(mfilename,'OutputParent');
try
    if(~exist(OutputParent,'dir'))
        OutputParent    = pwd;
    end
catch
    OutputParent    = pwd;
end
OutputParent = uigetdir(OutputParent, '出力フォルダを選んでください。');
if(OutputParent==0)
    disp('User pressed cancel')
    return;
else
    setconfig(mfilename,'OutputParent',OutputParent);
end


Objs = gsma;
nAna    = length(Objs);
if nAna < 1
    disp('No analysis selected. Select one or more analyses in mda Analyses Browser')
    return;
end

for iAna = 1:nAna
    Obj         = Objs(iAna);
    ExpName     = get(Obj, 'ExperimentName');
    FileName    = get(Obj, 'Filename');
%     SubClass       = get(Obj,'SubClass');
    Comps       = analyses(Obj, 'componentobjs');
    nComp       = length(Comps);
    if nComp < 1
        disp(['No components in ' FileName]);
        break;
    end
    OutputDir   = fullfile(OutputParent,FileName);
    if(~exist(OutputDir,'dir'))
        mkdir(OutputDir);
    end

    for iComp=1:nComp
        Comp        = Comps(iComp);
        Name        = get(Comp,'Name');
        SubClass    = get(Comp,'SubClass'); %: 'perievent histogram'
        
        switch SubClass
            case 'perievent histogram'
                % Read Header
                XConversionFactor   = units('conversionfactor', 'time', get(Comp, 'TimeUnits'), 'seconds');
                
                hdr.Name        = get(Comp,'Name'); %: 'Movement onset-E'
                hdr.SubClass    = get(Comp,'SubClass'); %: 'perievent histogram'
                hdr.BinWidth    = get(Comp,'BinWidth') * XConversionFactor;
                hdr.Reference   = get(Comp,'Reference');
                hdr.Target      = get(Comp,'Target');
                hdr.TrialCount  = get(Comp,'TrialCount');
                hdr.WindowStart = get(Comp,'WindowStart') * XConversionFactor;
                hdr.WindowStop  = get(Comp,'WindowStop') * XConversionFactor; %: 3
                hdr.TimeUnits   = 'seconds'; % get(Comp,'TimeUnits'); %: 'milliseconds'
                hdr.Comments    = get(Comp,'Comments'); %: ''
                
                % Read Data
                if(trial_flag)
                    dat.YData   = get(Comp,'TrialData'); % デフォルトでsecond単位なので変換する必要なし
                else
                    dat.XData   = get(Comp,'XData') * XConversionFactor;
                    dat.YData   = get(Comp,'YData');
                end
                
            case 'triggered average'
                XConversionFactor   = units('conversionfactor', 'time', get(Comp, 'TimeUnits'), 'seconds');
                YConversionFactor   = units('conversionfactor','signal units',get(Comp,'YUnits'),'milliVolts',Comp);
                TrialConversionFactor   = units('conversionfactor','signal units','digitizing units','milliVolts',Comp);
                
                hdr.Name        = get(Comp,'Name'); %: 'FCR rect'
                hdr.SubClass    = get(Comp,'SubClass'); %: 'triggered average'
                hdr.SampleRate  = get(Comp,'SampleRate'); %: 5000
                hdr.Reference   = get(Comp,'Reference'); %: 'MSD1-1 (without stim effect)'
                hdr.Target      = get(Comp,'Target'); %: 'FCR rect'
                hdr.TrialCount  = get(Comp,'TrialCount'); %: 1218
                hdr.WindowStart = get(Comp,'WindowStart') * XConversionFactor; %: -50
                hdr.WindowStop  = get(Comp,'WindowStop') * XConversionFactor; %: 50
                hdr.TimeUnits   = 'seconds'; % get(Comp,'TimeUnits'); %: 'milliseconds'
                hdr.YUnits      = 'milliVolts';  %get(Comp,'YUnits'); %: 'Volts'
                hdr.Comments    = get(Comp,'Comments'); %: ''

                % Read Data
                if(trial_flag)
                    dat.XData   = get(Comp,'XData') * XConversionFactor;
                    dat.YData   = double(get(Comp,'TrialData')) * TrialConversionFactor;
                else
                    dat.XData   = get(Comp,'XData') * XConversionFactor;
                    dat.YData   = double(get(Comp,'YData')) * YConversionFactor;
                end

        end

        if(trial_flag)
        OutputFile  = [Name,'-trial.xls'];
        else
        OutputFile  = [Name,'.xls'];
        end
        OutputFullFile  = fullfile(OutputDir,OutputFile);

        % Open file
        fid = fopen(OutputFullFile,'w');
        if(fid<1)
            error('Output file may be open. Close it and try again.')
        end

        % Write header
        hdrnames    = fieldnames(hdr);
        nhdr        = length(hdrnames);
        for ihdr=1:nhdr
            fprintf(fid,[hdrnames{ihdr},'\t',num2str(hdr.(hdrnames{ihdr})),'\n']);
        end
        
        % Write data
               
        fprintf(fid,'\n');
        
        if(trial_flag)
            switch SubClass
                case 'perievent histogram'
                    ndat    = hdr.TrialCount;
                    ndata   = nan(1,ndat);
                    % Label
                    for idat=1:ndat
                        ndata(idat)   = length(dat.YData{idat});
                        if(idat~=ndat)
                            fprintf(fid,['#',num2str(idat),'\t']);
                        else
                            fprintf(fid,['#',num2str(idat)]);
                        end
                    end
                    % Data
                    for idata=1:max(ndata)
                        fprintf(fid,'\n');
                        for idat=1:ndat
                            if(ndata(idat)>=idata)
                                value   = num2str(dat.YData{idat}(idata));
                            else
                                value   = '';
                            end
                                
                            if(idat~=ndat)
                                fprintf(fid,[value,'\t']);
                            else
                                fprintf(fid,value);
                            end
                        end
                    end
                case 'triggered average'
                    ndat    = hdr.TrialCount;   % nTrials
                    ndata   = size(dat.YData,2);    % nData
                    
                    % Label
                    fprintf(fid,['time\t']);
                    for idat=1:ndat
                        if(idat~=ndat)
                            fprintf(fid,['#',num2str(idat),'\t']);
                        else
                            fprintf(fid,['#',num2str(idat)]);
                        end
                    end
                    % Data
                    for idata=1:ndata
                        fprintf(fid,'\n');
                        for idat=1:(ndat+1)
                            if(idat==1)
                                value   = dat.XData(idata);
                            else                               
                                value   = dat.YData((idat-1),idata);
%                                 value   = (idat-1);
                            end
                            if(idat~=(ndat+1))
                                fprintf(fid,'%f\t',value);
                            else
                                fprintf(fid,'%f',value);
                            end
                        end
                    end
                    
                    
            end
        else
            datnames    = fieldnames(dat);
            ndat        = length(datnames);
            ndata       = length(dat.(datnames{1}));

            % Label
            for idat=1:ndat
                if(idat~=ndat)
                    fprintf(fid,[datnames{idat},'\t']);
                else
                    fprintf(fid,datnames{idat});
                end
            end
            % Data
            for idata=1:ndata
                fprintf(fid,'\n');
                for idat=1:ndat
                    if(idat~=ndat)
                        fprintf(fid,'%f\t',dat.(datnames{idat})(idata));
                    else
                        fprintf(fid,'%f',dat.(datnames{idat})(idata));
                    end
                end
            end
        end
        
        
        % Close file
        fclose('all');
        disp(OutputFullFile)
    end

end
