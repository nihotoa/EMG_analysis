function ftcohtrig_btc(commands,comment)
%example
%ftcontrig_btc('control combine','070730')
%ftcontrig_btc('control','070730')
tic;

% Analysis parameters
AnalysisType   = 'ftcohtrig';
nfftPoints(1)   = 128;  % for compiled analyses
nfftPoints(2)   = 128;  % for time-series analyses
movingStep      = 128;       % for time-series analyses
% trigName{1}   = 'OutT1 Enter On (success valid)';
% trigName{2}   = 'Grip Onset (success valid)';
% trigName{3}   = 'CentT Enter Off (success valid)';
% 
% trigWindow{1} = [0 1.024];
% trigWindow{2} = [-0.256 0.768];
% trigWindow{3} = [-1.024 0];
% 
% VarName{1}  = 'Control';
% VarName{2}  = 'GripOn';
% VarName{3}  = 'EndHold';


trigName{1}   = 'Grip Onset (success valid)';
trigName{2}   = 'Grip peak deriv Torque (success valid)';
trigName{3}   = 'Grip Offset (success valid)';
trigName{4}   = 'CentT Enter Off (success valid)';
trigWindow{1} = [0 1.024];
trigWindow{2} = [0 1.024];
trigWindow{3} = [0 1.024];
trigWindow{4} = [-1.024 0];
VarName{1}  = 'GripOn';
VarName{2}  = 'GripTorPeak';
VarName{3}  = 'GripOff';
VarName{4}  = 'EndHold';

% trigName{1}   = 'CentT Enter Off (success valid)';
% trigWindow{1} = [-3.072 1.024];
% VarName{1}  = 'EndHold';

refName       = 'summed smoothed Torque';
opt_str     = '';

if nargin < 1
    commands = 'matrix'
    comment = [];
end

for ii=1:length(VarName)
    VarNames{ii}    = ',';
end
VarNames    = [VarName;VarNames];
VarNames    = [VarNames{:}];
VarNames(end)    = [];

combine_flag = 0;
commands = deblank(commands);
while (any(commands))              % Parse individual options from string.
    [com,commands] = strtok(commands);
    switch com
        case 'matrix'
            command  = 'matrix';
        case 'control'
            command  = 'control';
        case 'combine'
            combine_flag = 1;
    end

end
if(combine_flag==0)
    commands    = command;
else
    commands    = [command,'_combine'];
end

if(isempty(comment))
    string =[num2str(nfftPoints(1)),'_',num2str(nfftPoints(2)),'pts_',opt_str(opt_str~=' ')];
else
    string =[comment,'_',num2str(nfftPoints(1)),'_',num2str(nfftPoints(2)),'pts_',opt_str(opt_str~=' ')];
end

% get channel names
switch command
    case 'matrix'
        listName=getchanname('Select Continuous Channels');
    case 'control'
%                 controlName = getchanname('Control Channel');
        controlName = {'Non-filtered-subsample(uV)'};
%             controlName = {'FDI-subsample(uV)'};
%                 listName    = getchanname('Select Continuous Channels');
%         listName= {'FDI-subsample(uV)',...
%             'AbDM-subsample(uV)'};
%         listName= {'FDI-subsample-SR500Hz'};

%         listName    = {'FDI-subsample(uV)',...
%             'ADP-subsample(uV)',...
%             'AbPB-subsample(uV)',...
%             'ED23-subsample(uV)',...
%             'ECU-subsample(uV)',...
%             'ED45-subsample(uV)',...
%             'ECRl-subsample(uV)',...
%             'ECRb-subsample(uV)',...
%             'EDC-subsample(uV)',...
%             'FDPr-subsample(uV)',...
%             'FDPu-subsample(uV)',...
%             'FCU-subsample(uV)',...
%             'AbDM-subsample(uV)',...
%             'PL-subsample(uV)',...
%             'FDS-subsample(uV)',...
%             'FCR-subsample(uV)',...
%             'BRD-subsample(uV)',...
%             'PT-subsample(uV)',...
%             'BB-subsample(uV)'};

        listName    = {'FDI-subsample(uV)',...
            'AbDM-subsample(uV)'};
        
        if (length(controlName)~=1)
            disp('**** Cohtrig_btc error: Invalid selection of control.')
            return
        end
end


SelectedExp  = gsme;
if isempty(SelectedExp)
    disp('**** Cohtrig_btc error: No experiment is selected.')
    return
end

nExp    = length(SelectedExp);

if(combine_flag==0)
    for kk=1:nExp
        try
            currExp  = SelectedExp(kk);

            % initializing parameters
            TimeRange{1}   = [0 get(currExp,'TotalTime')];
            %         if(TimeRange(2)>=1000)
            %             TimeRange=[0 1000];
            %         end
            %         TimeRange   = [1 600]
            ExperimentName  = [get(currExp,'Name')];
            Datapath        = ['L:\tkitom\MDAdata\mat\',ExperimentName,'\'];

            if(isempty(comment))
                string =[num2str(nfftPoints(1)),'_',num2str(nfftPoints(2)),'pts_',opt_str(opt_str~=' ')];
            else
                string =[comment,'_',num2str(nfftPoints(1)),'_',num2str(nfftPoints(2)),'pts_',opt_str(opt_str~=' ')];
            end

            disp(['[+]',ExperimentName,' (',num2str(kk),'/',num2str(nExp),') start at ',datestr(now)]);


            % initializing output directory and file
%             if(~exist('c:\data'))
%                 mkdir('c:\', 'data')
%             end
%             if(~exist('c:\data\tcohtrig'))
%                 mkdir('c:\data\', 'tcohtrig')
%             end
%             if(~exist(['c:\data\tcohtrig\',ExperimentName]))
%                 status  = mkdir('c:\data\tcohtrig\',ExperimentName);
%             end
%             if(~exist(['c:\data\tcohtrig\',ExperimentName ,'\',commands]))
%                 status  = mkdir(['c:\data\tcohtrig\',ExperimentName,'\'],commands);
%             end
            if(~exist(['L:\tkitom\data\tcohtrig\',comment]))
                status  = mkdir(['L:\tkitom\data\tcohtrig\',comment]);
            else
                status  = 1;
            end
            if(status==0)
                disp('**** Cohtrig_btc error: Failure to make output directory.')
                return
            end
            Outputpath  = ['L:\tkitom\data\tcohtrig\',comment,'\'];

            switch command
                case 'matrix'
                    nCh = length(listName);
                    if nCh < 1
                        disp('**** Cohtrig_btc error: No channels selected.')
                        return
                    end

                    nAna    = ((nCh)*(nCh-1))/2;
                    iAna    = 1;

                    for ii  = 1:length(trigName)
                        chantrig{ii}    = load([Datapath,trigName{ii}]);
                    end
                    chanref{1} = load([Datapath,refName]);

                    for ii=1:nCh
                        chan1{1}   = load([Datapath,listName{ii}]);
                        for jj=ii+1:nCh
                            chan2{1}   = load([Datapath,listName{jj}]);
                            Outputfile  = [Outputpath,ExperimentName ,'_',chan1{1}.Name,'__',chan2{1}.Name,'_',string,'.mat'];
                            %                         GripOn      = ftcohtrig(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                            %                         [GripOn,Control]= ftcohtrig(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                            %                             [EndHold,GripOn]      = ftcohtrig2(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                            eval(['[',VarNames,']      = ftcohtrig2(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);'])
                            %                 if(exist(Outputfile))
                            %                     Temp    = load(Outputfile);
                            %                     exVariables = fieldnames(Temp);
                            %                     if(ismember('EndHold',exVariables))
                            %                             tempVar = EndHold;
                            %                             load(Outputfile);
                            %                             EndHold = tempVar;
                            %                             save(Outputfile,exVariables{:});
                            %                         else
                            %                             load(Outputfile);
                            %                             save(Outputfile,exVariables{:},'EndHold');
                            %                         end
                            %
                            %                     else
                            %                         save(Outputfile,'EndHold');
                            %                 end
                            save(Outputfile,VarName{:});
                            disp([' L-- ',' ',num2str((iAna)),'/',num2str(nAna),' done. (',num2str(toc),'sec) => ',Outputfile]);
                            iAna    = iAna + 1;
                        end
                    end


                case 'control'
                    
                    nCh = length(listName);
                    if nCh < 1
                        disp('**** Cohtrig_btc error: No channels selected.')
                        return
                    end
                    for ii  = 1:length(trigName)
                        chantrig{1,ii}    = load([Datapath,trigName{ii}]);
                    end
                    chanref{1} = load([Datapath,refName]);
                    chan1{1}    = load([Datapath,controlName{1}]);
                    for ii=1:nCh
                        chan2{1}   = load([Datapath,listName{ii}]);
                        Outputfile  = [Outputpath,ExperimentName ,'_',chan1{1}.Name,'__',chan2{1}.Name,'_',string,'.mat'];
                        %                        [GripOn,Control]      = ftcohtrig(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                        %                         [EndHold,GripOn]      =
                        %                         ftcohtrig2(TimeRange,nfft
                        %                         Points,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                        
                        eval(['[',VarNames,']      = ftcohtrig2(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);'])
                        %                 if(exist(Outputfile))
                        %                     Temp    = load(Outputfile);
                        %                     exVariables = fieldnames(Temp);
                        %                     if(ismember('EndHold',exVariables))
                        %                             tempVar = EndHold;
                        %                             load(Outputfile);
                        %                             EndHold = tempVar;
                        %                             save(Outputfile,exVariables{:});
                        %                         else
                        %                             load(Outputfile);
                        %                             save(Outputfile,exVariables{:},'EndHold');
                        %                         end
                        %
                        %                     else
                        %                         save(Outputfile,'EndHold');
                        %                 end
                        save(Outputfile,VarName{:});
                        disp([' L-- ',' ',num2str((ii)),'/',num2str(nCh),' done. (',num2str(toc),'sec) => ',Outputfile]);
                    end

            end     % switch command
        catch
            currExp  = SelectedExp(kk);
            ExperimentName  = get(currExp,'Name');
            disp(['**** Cohtrig_btc error: error occurred in ',ExperimentName])
        end
    end         % for kk=1:nExp
elseif(combine_flag==1)
    currExp  = SelectedExp(1);
    firstExperimentName  = [get(currExp,'Name')];

    % initializing output directory and file
%     if(~exist('c:\data'))
%         mkdir('c:\', 'data')
%     end
%     if(~exist('c:\data\tcohtrig'))
%         mkdir('c:\data\', 'tcohtrig')
%     end
%     if(~exist(['c:\data\tcohtrig\',firstExperimentName]))
%         status  = mkdir('c:\data\tcohtrig\',firstExperimentName);
%     end
%     if(~exist(['c:\data\tcohtrig\',firstExperimentName ,'\',commands]))
%         status  = mkdir(['c:\data\tcohtrig\',firstExperimentName,'\'],commands);
%     end
    if(~exist(['L:\tkitom\data\tcohtrig\',comment]))
        status  = mkdir(['L:\tkitom\data\tcohtrig\',comment]);
    else
        status  = 1;
    end
    if(status==0)
        disp('**** Cohtrig_btc error: Failure to make output directory.')
        return
    end
    Outputpath  = ['L:\tkitom\data\tcohtrig\',comment,'\'];

    disp(['[+]',firstExperimentName,' start at ',datestr(now)]);

    switch command
        case 'control'

            for kk=1:nExp
                currExp  = SelectedExp(kk);

                % initializing parameters
                ExperimentName{kk}  = [get(currExp,'Name')];
                Datapath{kk}        = ['L:\tkitom\MDAdata\mat\',ExperimentName{kk},'\'];

                TimeRange{kk,1}   = [0 get(currExp,'TotalTime')];
                chanref{kk,1} = load([Datapath{kk},refName]);
                chan1{kk,1}    = load([Datapath{kk},controlName{1}]);

                for ii  = 1:length(trigName)
                    chantrig{kk,ii}    = load([Datapath{kk},trigName{ii}]);
                end
            end
            trigWindow  = repmat(trigWindow,nExp,1);


            nCh = length(listName);
            if nCh < 1
                disp('**** Cohtrig_btc error: No channels selected.')
                return
            end


            for ii=1:nCh
                for kk=1:nExp
                    chan2{kk,1}   = load([Datapath{kk},listName{ii}]);
                end
                %                 [EndHold,GripOn]      = ftcohtrig2(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);
                eval(['[',VarNames,']      = ftcohtrig2(TimeRange,nfftPoints,movingStep,chan1,chan2,chantrig,trigWindow,chanref, opt_str);'])
                Outputfile  = [Outputpath,firstExperimentName ,'_',chan1{1,1}.Name,'__',chan2{1,1}.Name,'_',string,'.mat'];

                %                 if(exist(Outputfile))
                %                     Temp    = load(Outputfile);
                %                     exVariables = fieldnames(Temp);
                %                     if(ismember('EndHold',exVariables))
                %                             tempVar = EndHold;
                %                             load(Outputfile);
                %                             EndHold = tempVar;
                %                             save(Outputfile,exVariables{:});
                %                         else
                %                             load(Outputfile);
                %                             save(Outputfile,exVariables{:},'EndHold');
                %                         end
                %
                %                     else
                %                         save(Outputfile,'EndHold');
                %                 end
                save(Outputfile,VarName{:});
                disp([' L-- ',' ',num2str((ii)),'/',num2str(nCh),' done. (',num2str(toc),'sec) => ',Outputfile]);
            end

    end     % switch command
end         % for kk=1:nExp


load handel;
p = audioplayer(y, Fs);
play(p, [1 (get(p, 'SampleRate') * 0.5)]);