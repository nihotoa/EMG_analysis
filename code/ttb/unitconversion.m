function unitconversion

use_calibrationfile     = 1;

% X:　デジタイジングされた時の電圧値
% Y:　対応する実際の値（uV,mmなど）
% Y   = a*X + b;
% とした時のaとbを入力する。

% {filename gain offset unit}
% gains   ={'Non-filtered-subsample',1000,0,'uV';...     % gain＝デジタイジングした時の1Vが実際の何uVかを指定する。
%     'FDI-subsample',320,0,'uV';...     %1
%     'ADP-subsample', 40,0,'uV';...     %2
%     'AbPB-subsample',320,0,'uV';...    %3
%     'ED23-subsample', 40,0,'uV';...    %4
%     'AbPL-subsample',320,0,'uV';...    %5
%     'ECU-subsample',160,0,'uV';...     %6
%     'ED45-subsample',320,0,'uV';...    %7
%     'ECRl-subsample',320,0,'uV';...    %8
%     'ECRb-subsample',320,0,'uV';...    %9
%     'EDC-subsample',320,0,'uV';...     %10
%     'FDPr-subsample',320,0,'uV';...    %11
%     'FDPu-subsample',320,0,'uV';...    %12
%     'FCU-subsample',320,0,'uV';...     %13
%     'AbDM-subsample', 40,0,'uV';...    %14
%     'PL-subsample',320,0,'uV';...      %15
%     'FDS-subsample',320,0,'uV';...     %16
%     'FCR-subsample',320,0,'uV';...     %17
%     'BRD-subsample',320,0,'uV';...     %18
%     'PT-subsample',320,0,'uV';...      %19
%     'BB-subsample',320,0,'uV'};        %20
%
% gains   ={'smoothed Index Torque',3.4,0,'N';...     % gain＝デジタイジングした時の1Vが実際の何uVかを指定する。
%     'smoothed Thumb Torque',3.9,0,'N'};

% gains   ={'Non-filtered-subsample', 1000, 0, 'uV';...     % gain＝デジタイジングした時の1Vが実際の何uV(指定した単位による)かを指定する。
%     'FDI-subsample',  1280, 0, 'uV';...      %1
%     'AbDM-subsample', 1280, 0, 'uV';...      %2
%     'smoothed Index Torque',1.16,0,'N';...
%     'smoothed Thumb Torque',1.33,0,'N'};

% gains   ={'smoothed Index Torque',1.16,0,'N';...
%     'smoothed Thumb Torque',1.33,0,'N'};
%  gains   ={'Non-filtered-subsample', 1000, 0, 'uV'};
%  gains   ={'FDI-subsample',  1280, 0, 'uV';...      %1
%     'AbDM-subsample', 1280, 0, 'uV'};      %2

% List   ={'Triceps-hp5',80,0,'uV','Triceps'};     % gain＝デジタイジングした時の1Vが実際の何uV(指定した単位による)かを指定する。




VoltageRange    = 5;
BitPrecision    = 16;
cfactor         = VoltageRange / pow2(BitPrecision - 1);    %d.u. -> V


ParentDir    = uigetdir(matpath,'親フォルダを選択してください。');
% ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = uiselect(dirdir(ParentDir),1,'対象となるExperimentを選択してください。');

for jj=1:length(InputDirs)
    try
        PATH    = fullfile(ParentDir,InputDirs{jj});
        disp(PATH)
        
        if(use_calibrationfile     == 1)
            
            calfile = fullfile(PATH,'calibration.txt');
            if(exist(calfile,'file'))
                %             [NAMEs,gains,offsets,units,NewNAMEs] = textread(calfile,'%s%f%f%s%s','delimiter',',');
                [NAMEs,gains,offsets,units,NewNAMEs] = textread(calfile,'%s%f%f%s%s%*[^\n]','delimiter',',');
                %             [NAMEs,gains,offsets,units,NewNAMEs,delete_flags] = textread(calfile,'%s%f%f%s%s%d','delimiter',',');
            else
                error(['****** no calibration file in',InputDirs{jj}]);
            end
        else
            NAMEs   = List(:,1);
            gains   = [List{:,2}];
            offsets = [List{:,3}];
            units   = List(:,4);
            NewNAMEs    = List(:,5);
            
        end
        
        nfiles      = size(gains,1);
        
        nNewNAMEs   = size(NewNAMEs,1);
        if(nNewNAMEs<nfiles)
            for ii=(nNewNAMEs+1):nfiles
                NewNAMEs{ii}    = '';
                disp('足りない分を補償しました(NewNAMEs)')
            end
        end
        
        %     ndelete_flags   = size(delete_flags,1);
        %     if(ndelete_flags<nfiles)
        %         for ii=(ndelete_flags+1):nfiles
        %         delete_flags(ii)    = 0;
        %         disp('足りない分を補償しました')
        %         end
        %     end
        
        
        for ii=1:size(gains,1)
            
            NAME    = NAMEs{ii};
            gain    = gains(ii);
            offset  = offsets(ii); % d.u.
            unit    = units{ii};
            NewNAME = NewNAMEs{ii};
            %         delete_flag = delete_flags(ii);
            fullfilename    = fullfile(PATH,[NAME,'.mat']);
            if(exist(fullfilename,'file'))
                s       = load(fullfilename);
                
                if(isempty(NewNAME))
                    s.Name      = [NAME,'(',unit,')'];
                else
                    s.Name      = [NewNAME,'(',unit,')'];
                end
                
                if(~isfield(s,'Unit'))
                    s.Unit  = 'du';
                end
                switch s.Unit
                    case 'du'
                        s.Data      = double(s.Data) * cfactor;  % d.u. -> V
                        disp('du->V')
                    case 'mV'
                        s.Data      = double(s.Data) / 1000;  % mV -> V
                        disp('mV->V')
                    case 'V'
                        s.Data      = double(s.Data);  % V -> V
                        disp('V->V')
                end
                
                s.Data      = s.Data * gain + offset;
                s.Unit      = unit;
                
                
                outputfile  = fullfile(PATH,[s.Name,'.mat']);
                
                save(outputfile,'-struct','s')
                disp(outputfile)
            else
                disp(['*** ',fullfilename,' does not exist.'])
            end
            
            
            %         if(delete_flag==1)
            %             delete(fullfilename);
            %             disp(['   L-- X ',fullfilename,' was deleted.'])
            %
            %         end
            
        end
    catch
        disp(['****** Error occured in ',InputDirs{jj}])
    end
    
end
beep

