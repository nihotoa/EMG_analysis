function Y  = buffers(command,varargin)

switch command
    case 'new'
        S.maxsize = 5000 * 60;
        [temp,S.BuffID]     = fileparts(tempname);
        S.BuffID            = ['BUFFER',S.BuffID];
        if(length(varargin)>1)
            X                   = varargin{1};
            S.noverlap          = varargin{2};
        else
            X                   = varargin{1};
            S.noverlap          = 100;
        end
        [S.nData,S.nChan]   = size(X);
        S.nBuff             = ceil(S.nData./S.maxsize);
        

        for iBuff =1:S.nBuff
            I1  = max(1,S.maxsize * (iBuff - 1) - S.noverlap + 1);
            I2  = min(S.maxsize * iBuff,S.nData);
            data    = X(I1:I2,:);
            save(fullfile(tempdir,[S.BuffID,'_B',num2str(iBuff)]),'data'),disp(['BUFFERS(new)',fullfile(tempdir,[S.BuffID,'_B',num2str(iBuff)])])
        end
        %         S.BuffID    = BuffID;
        %         S.noverlap  = noverlap;
        %         S.nData     = nData;
        %         S.nChan     = nChan;
        %         S.nBuff     = nBuff;

        save(fullfile(tempdir,S.BuffID),'-struct','S'),disp(['BUFFERS(new)',fullfile(tempdir,S.BuffID)]);
        
        Y           = S.BuffID;
    case 'save'
        BuffID  = varargin{1};
        iBuff   = varargin{2};
        data    = varargin{3};

        save(fullfile(tempdir,[BuffID,'_B',num2str(iBuff)]),'data'),disp(['BUFFERS(save)',fullfile(tempdir,[BuffID,'_B',num2str(iBuff)])])
        
        Y   = BuffID;


    case 'load'

        if(length(varargin)>1)
            BuffID  = varargin{1};
            iBuff   = varargin{2};
        else
            BuffID  = varargin{1};
            iBuff   = 0;
        end


        if(iBuff==0)
            S   = load(fullfile(tempdir,BuffID));
            Y   = zeros(S.nData,S.nChan);

            for iBuff=S.nBuff:-1:1
                I1  = max(1,S.maxsize * (iBuff - 1) - S.noverlap + 1);
                I2  = min(S.maxsize * iBuff,S.nData);
                load(fullfile(tempdir,[S.BuffID,'_B',num2str(iBuff)]));
                Y(I1:I2,:)  = data;
            end


        else

            load(fullfile(tempdir,[BuffID,'_B',num2str(iBuff)]));
            Y   = data;
        end
        
    case 'get'
        if(length(varargin)>1)
            BuffID  = varargin{1};
            PropName= varargin{2};
            Y   = load(fullfile(tempdir,BuffID));
            Y   = Y.(PropName);
            
        else
            BuffID  = varargin{1};
            Y   = load(fullfile(tempdir,BuffID));
        end


    case 'delete'
        try
            if(~isempty(varargin))
            BuffID  = varargin{1};
            S   = load(fullfile(tempdir,BuffID));

            for iBuff=1:S.nBuff
                delete(fullfile(tempdir,[S.BuffID,'_B',num2str(iBuff)])),disp(['BUFFERS(delete)',fullfile(tempdir,[S.BuffID,'_B',num2str(iBuff)])]);
            end
            delete(fullfile(tempdir,BuffID)),disp(['BUFFERS(delete)',fullfile(tempdir,S.BuffID)]);
            Y   =1;
            else
                files   = strfilt(dirmat(tempdir),'BUFFER');
                if(~isempty(files))
                    nfile   = length(files);
                    for ifile=1:nfile
                        delete(fullfile(tempdir,files{ifile}));disp(['BUFFERS(delete)',fullfile(tempdir,files{ifile})]);
                    end
                    
                end
                
            end
        catch
            Y   =0;
        end
end
