function applyBSSW_btc(use_buffer)

if(nargin<1)
    use_buffer=0;
end

warning('off');

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
ParentDir   = uigetdir(ParentDir,'EMGの親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(sortxls(Tarfiles),1,'対象とするEMGfileを選択してください');


WDir    = getconfig(mfilename,'WDir');
try
    if(~exist(WDir,'dir'))
        WDir    = pwd;
    end
catch
    WDir    = pwd;
end
WDir   = uigetdir(WDir,'BSSWの入っているフォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'WDir',WDir);
end


nDir    = length(InputDirs);
nTar    = length(Tarfiles);

if(use_buffer)
    
    for iDir=1:nDir
        try
            clear('W','X')
            InputDir    = InputDirs{iDir};
            disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
            %         Wfile= InputDir(1:(end-2));
            Wfile= InputDir;
            W    = load(fullfile(WDir,Wfile));
            
            BuffID  = cell(1,nTar);
            EMGNames = cell(1,nTar);
            
            for iTar=1:nTar
                clear('Tar')
                Tarfile     = Tarfiles{iTar};
                Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
                Tar         = load(Inputfile);
                
                %             if(iTar==1)
                %                 X   = zeros(size(Tar.Data,2),nTar);
                %
                %             end
                %             X(:,iTar)   = Tar.Data';
                %
                BuffID{iTar}    = buffers('new', Tar.Data');
                EMGNames{iTar}   = deext(Tar.Name);
                disp([Tarfile,' loaded.'])
            end
            if(~all(cellmatch(W.EMGName,EMGNames)))
                disp('***** EMGがマッチしていません')
                return;
            else
                disp('EMG matched!')
            end
            Tar.Data    = [];
            
            
            nBuffer   = buffers('get', BuffID{1}, 'nBuff');
            
            
            for iBuffer=1:nBuffer
                for iTar=1:nTar
                    temp = buffers('load', BuffID{iTar}, iBuffer);
                    if(iTar==1)
                        X    = zeros(size(temp,1),nTar);
                    end
                    X(:,iTar)    = temp;
                end
                % Apply 3rd order difference;
                X   = filter([1 -3 3 -1], 1, X);
                
                X(:,W.ValidEMGInd)   = applyBSSW(W.W,X(:,W.ValidEMGInd));
                
                % Apply 3rd order integral
                X = filter(1, [1 -3 3 -1], X);
                
                for iTar=1:nTar
                    buffers('save', BuffID{iTar}, iBuffer, X(:,iTar));
                end
                
                indicator(iBuffer,nBuffer,'Buffers')
            end
            
            disp(' Data calculated.')
            
            for iTar=1:nTar
                
                EMGName = EMGNames{iTar};
                
                Name    = [EMGName,'-bss'];
                Tar.Name    = Name;
                Tar.Data    = buffers('load',BuffID{iTar})';
                Outputfile  = fullfile(ParentDir,InputDir,Name);
                save(Outputfile,'-struct','Tar');
                disp(Outputfile)
                
                
            end
            
            for iTar=1:nTar
                buffers('delete',BuffID{iTar});
            end
        catch
            errormsg    = ['****** Error occured in ',InputDirs{iDir}];
            disp(errormsg)
            errorlog(errormsg);
            for iTar=1:nTar
                buffers('delete',BuffID{iTar});
            end
            
        end
        %     indicator(0,0)
        
        
        
    end
else    % if(use_buffer=0)
    
    for iDir=1:nDir
        try
            clear('W','X')
            InputDir    = InputDirs{iDir};
            disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
            Wfile= InputDir;
            W    = load(fullfile(WDir,Wfile));
            
            EMGNames = cell(1,nTar);

            % load data
            for iTar=1:nTar
                clear('Tar')
                Tarfile     = Tarfiles{iTar};
                Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
                Tar         = load(Inputfile);
                
                if(iTar==1)
                    X   = zeros(size(Tar.Data,2),nTar);
                    
                end
                
                temp    = Tar.Data;
                % %
                % spike2の場合、おなじ時間で取っていてもデータの長さが違う場合がある。
                % その場合は、スタートは一緒だと仮定してデータの長いものを切ってしまう。
                if(isfield(Tar,'PlatForm'))
                    if(strcmp(Tar.PlatForm,'spike2'))
                        len1    = size(X,1);
                        len2    = length(temp);
                        
                        if(len1 ~= len2)
                            disp(['Data length mismatch!! len1=',num2str(len1),' len2=',num2str(len2)])
                        end
                        
                        if(len1 < len2)
                            temp    = temp(1:len1);
                            disp(['Data length was changed to ',num2str(len1)])
                        elseif(len1 > len2)
                            X       = X(1:len2,:);
                            disp(['Data length was changed to ',num2str(len2)])
                        end
                    end
                end
                % %
                
                X(:,iTar)   = temp';
                
                EMGNames{iTar}   = deext(Tar.Name);
                disp([Tarfile,' loaded.'])
            end
            if(~all(cellmatch(W.EMGName,EMGNames)))
                disp('***** EMGがマッチしていません')
                return;
            else
                disp('EMG matched!')
            end
            
            
            % Apply 3rd order difference;
            X   = filter([1 -3 3 -1], 1, X);
            
            X(:,W.ValidEMGInd)   = applyBSSW(W.W,X(:,W.ValidEMGInd));
            
            % Apply 3rd order integral
            X = filter(1, [1 -3 3 -1], X);
            
            disp(' Data calculated.')
            
            % save data
            for iTar=1:nTar
                
                EMGName = EMGNames{iTar};
                
                Name    = [EMGName,'-bss'];
                Tar.Name    = Name;
                Tar.Data    = X(:,iTar)';
                Outputfile  = fullfile(ParentDir,InputDir,Name);
                save(Outputfile,'-struct','Tar');
                disp(Outputfile)
                
                
            end
            
            
        catch
            errormsg    = ['****** Error occured in ',InputDirs{iDir}];
            disp(errormsg)
            errorlog(errormsg);
            
        end
        %     indicator(0,0)
        
        
        
    end
    
    
end

warning('on');