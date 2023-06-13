function trimmdadata

MSDflag = false;

Exps = gsme;
if isempty(Exps)
    disp('**** Cohtrig_btc error: No experiment is selected.')
    return
end
ExperimentNames  = get(Exps,'Name');


Listfilename    = uigetfullfile('*.xls','Pick a Analysis file and Select 5 colums.');
[temp1,temp2,List] = xlsread(Listfilename,-1,{'タイトルは含まずに、';'[ExpName, suffix,depth, TotalTime(1),TotalTime(2),(MSD Name)]';'を選択する'});
if(size(List,2)~=5)
    if(size(List,2)==6)
        MSDflag = true;
    else
        msgbox({'invalid selection';'select [ExpName, suffix,depth, TotalTime(1),TotalTime(2),(MSD Name)]'})
        return;

    end
end
nList   = size(List,1);
ChanNames    = getchanname('Select Continuous or Timestamp Channels');

Outputparent    = uigetdir(matpath);

hh  = 0;
for jj  = 1:nList

    ind             = strcmp(ExperimentNames,List{jj,1});
    currExp         = Exps(ind);
    ExperimentName  = get(currExp,'Name');
    suffix          = List{jj,2};
    if(isnan(suffix))
        Outputpath      = fullfile(Outputparent,ExperimentName);
    else
        Outputpath      = fullfile(Outputparent,[ExperimentName,suffix]);
    end
    try
        if(~exist(Outputpath))
            status  = mkdir(Outputpath);
        else
            status  = 1;
        end
        if(status==0)
            disp('**** Failure to make output directory.')
            %         return
        end

        % get and save data
        if(isempty(List{jj,4}) | isempty(List{jj,5}) | isnan(List{jj,4}) | isnan(List{jj,5}))
%             TimeRange   = [0 Inf];
            TimeRange   = [1 get(currExp,'TotalTime')]
        else
            if(ischar(List{jj,4}))
                List{jj,4}  = str2double(List{jj,4});
            end
            if(ischar(List{jj,5}))
                List{jj,5}  = str2double(List{jj,5});
            end

            TimeRange   = [List{jj,4},List{jj,5}];
        end
        if(~isempty(ChanNames))
            IDs = experiment(currExp, 'findchannelobjs', ChanNames);
        else
            IDs = [];
        end

        if(MSDflag)
            MSDName = List{jj,6};
            if(~(isempty(MSDName) | isnan(MSDName)))
                MSDID   = experiment(currExp, 'findchannelobjs', MSDName);
                if(~isnull(MSDID))
                    IDs = [IDs,MSDID];
%                 else
%                     disp(['***** error: could not find MSD channel: ', MSDName]);
                end
%             else
%                 disp(['***** error: could not find MSD channel: ', MSDName]);
            end
        end

        if(~isempty(IDs))
            if any(isnull(IDs))
                error('**** Could not find some channels');
            
            end
            
            nID = length(IDs);
            for iID=1:nID
                try
                    Name        = get(IDs(iID), 'Name');
                    Class       = get(IDs(iID), 'Class');
                    SampleRate  = get(IDs(iID), 'SampleRate');
%                     Data        = getdata(currExp, Name, TimeRange, {{}});
%                     Data        = Data{:};
                    temp        = getdata(currExp, Name, TimeRange, {{}});
                    temp        = temp{:};
                    
                    switch Class
                        case 'continuous channel'
                            Data    = temp;
                        case 'timestamp channel'
                            if(size(temp,1)>1)
                                Children = get(IDs(iID),'Children');
                                nChild  = length(Children);
                                accessory_flag  = false(1,nChild);
                                for iChild  = 1:nChild
                                    accessory_flag(iChild)  = strcmp(get(Children(iChild),'Class'),'accessory data');
                                end
                                Children    = Children(accessory_flag);
                                nChild      = length(Children);
                                for iChild  = 1:nChild
                                    accessory_data(iChild).Name = get(Children(iChild),'Name');
                                    accessory_data(iChild).Data = temp(iChild+1,:);
                                end
                                Data    = temp(1,:) - TimeRange(1) * SampleRate;
                            else
                                Data    = temp - TimeRange(1) * SampleRate;
                                accessory_data  = [];
                            end
                        case 'interval channel'
                            error('interval channelは今のところサポートしてません。というか、MDAのインターバルチャンネルはわかりづらくて嫌いです。代わりに、Start/Stopに使用するtimestampチャンネルをexportして、後でmakeOriginalChannelsを走らせてください。');
                    end
                    
                    clear('temp')
                    mpack

                    
                    if(MSDflag & strcmp(Name,MSDName))
                        Name    = 'MSD';
                    end
                    
                    
                    
                    Outputfile  = [fullfile(Outputpath,Name),'.mat'];
                    switch Class
                        case 'continuous channel'
                            save(Outputfile,'Name','Data','SampleRate','Class','TimeRange')
                        case 'timestamp channel'
                            if(~isempty(accessory_data))
                                save(Outputfile,'Name','Data','accessory_data','SampleRate','Class','TimeRange')
                            else
                                save(Outputfile,'Name','Data','SampleRate','Class','TimeRange')
                            end
                        case 'interval channel'
                            error('interval channelは今のところサポートしてません。というか、MDAのインターバルチャンネルはわかりづらくて嫌いです。代わりに、Start/Stopに使用するtimestampチャンネルをexportして、後でmakeOriginalChannelsを走らせてください。');
                    end
%                     save(Outputfile,'Name','Data','SampleRate','Class','TimeRange')
                    disp(['Exported (',num2str(iID),'/',num2str(nID),') => ', Outputfile])
                catch
                    hh  = hh+1;
                    ExperimentName  = get(currExp,'Name');
                    Name        = get(IDs(iID), 'Name');
                    errormsg    = ['**** error occurred in ',fullfile(Outputpath,Name),'.mat'];
                    disp(errormsg);
                    errorlog([errormsg,'(',mfilename,')']);
                    errorfiles{hh}  = [fullfile(Outputpath,Name),'.mat'];
                end % try

            end     % iID=1:nID
        else
            disp(['No matched data in',Outputpath] )
        end

    catch
        disp(['error occurred in',Outputpath] )
    end
end         % for jj=1:nList
if hh~=0;
    disp({['Following ',num2str(hh),' files have not been created.'],' ',errorfiles{:}}')
    errordlg({['Following ',num2str(hh),' files have not been created.'],' ',errorfiles{:}})
end
