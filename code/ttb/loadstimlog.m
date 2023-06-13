function loadstimlog



ParentDir    = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象となるExperimentを選択してください。');

for jj=1:length(InputDirs)
    try
        PATH    = fullfile(ParentDir,InputDirs{jj});
        disp(PATH)
        stimlogfile = fullfile(PATH,'stimlog.txt');
        if(exist(stimlogfile,'file'))
            [Name,Data] = textread(stimlogfile,'%s%f%*[^\n]','delimiter',',');
        else
            error(['****** no stimlog.txt in',InputDirs{jj}]);
        end
        Name    = Name';
        Data    = Data';
        
        Data(strmatch('Actual1/Scale1',Name))   = Data(strmatch('Actual Amp1',Name)) ./ Data(strmatch('Scale1',Name));
        Data(strmatch('Actual1/Scale2',Name))   = Data(strmatch('Actual Amp2',Name)) ./ Data(strmatch('Scale2',Name));
        Data(strmatch('Actual1/Scale3',Name))   = Data(strmatch('Actual Amp3',Name)) ./ Data(strmatch('Scale3',Name));

        Data            = mat2cell(Data,ones(size(Name,1),1),ones(1,size(Name,2)));
        accessory_data  = struct('Name',Name,'Data',Data);
        
        nAccData        = length(accessory_data);

        stimpulsefile    = fullfile(PATH,'Stim pulse.mat');
        if(exist(stimpulsefile,'file'))
            s       = load(stimpulsefile);
        else
            disp(['*** ',stimpulsefile,' does not exist.'])
        end

        nData   = length(s.Data);

        for iAccData    =1:nAccData
            switch accessory_data(iAccData).Name
                case 'Stimulus ID'
                    accessory_data(iAccData).Data   = 1:nData;
                otherwise
                    accessory_data(iAccData).Data   = ones(1,nData)*accessory_data(iAccData).Data;
            end
        end
        
        s.accessory_data    = accessory_data;
        
%         outputfile  = fullfile(PATH,[deext(stimpulsefile),'2.mat']);
        outputfile  = fullfile(PATH,[deext(stimpulsefile),'.mat']);
        
        save(outputfile,'-struct','s');
        disp(outputfile);


    catch
        disp(['****** Error occured in ',InputDirs{jj}])
    end

end
beep