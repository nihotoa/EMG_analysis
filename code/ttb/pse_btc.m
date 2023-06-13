function pse_btc(BaseWindow, SearchTW, nsd, kknn, alpha, nSPF, psename, method, SearchObj, BaseLineChannel_flag)
% pse_btc(BaseWindow, SearchTW, nsd, kknn, alpha, nSPF, psename, method, SearchObj[, BaseLineChannel_flag])
% pse_btc([-0.03 -0.01],[0.003 0.015],2,[0 0],0.05/20, 100,'pseS2','Schieber', []); %All
% pse_btc([-0.03 -0.01],[-0.01 -0.02],3,[0.001 0.002],0.01/20,1,'pse1', 'any');
%
% BaseWindow    (sec) [-0.03 -0.01];
% nsd           2;
% kknn          [kk nn](sec) kk/nn(sec)���duration���������̂�I�ԁi�@�\�͉����Q�Ɓj;
% alpha         0.05/20;
%
%
%
%
% BaseLine�Ƃ�,ISAData��basetime�̕��ϒl��YData��originalbasemean�ɂ��킹�����́B
% ���Ȃ킿�A�`��̎��Ȃǂ́AYData-BaseLine+BaseMean������΁AISA-adjusted YData�ƂȂ�BISA��BaseLine
%
% ---------------------------
% Method
%     'sdr'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetime�̕��ρ}nsd���Akk/nn(sec)�����Ă��镨��peak�Ƃ݂Ȃ��B
%     ����ɁAOnset Latency��SearchTW�͈̔͂ɓ����Ă�����̂��ApeakTW�Ƃ��đI��ł���B
% Significance test of Peak
%     Peak�Ƃ��Ă݂Ȃ��ꂽ�͈͂̃f�[�^basetime�̃f�[�^�ɑ΂��đΉ��̂Ȃ��ipool���ꂽ�f�[�^�jt������s���B
%
% Reference
%     None
% Example
%     pse_btc([-1.5 -1.0], [-1.5 3.0], 2, [0.1 0.1], 0.05, 1, 'pseSD1','sdr','any')
%
% ---------------------------
% Method
%     'normal'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetime�̕��ρ}nsd���Akk/nn(sec)�����Ă��镨��peak�Ƃ݂Ȃ��B
%     ����ɁAOnset Latency��SearchTW�͈̔͂ɓ����Ă�����̂��ApeakTW�Ƃ��đI��ł���B
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peak�Ƃ��Ă݂Ȃ��ꂽ���Ԃ̃f�[�^�ɂ��āATrial��nSPF(number of spikes per fragment)�ɕ����Ċe�X�̕��ς����B
%     ���l��Basemean�̕��ς�fragment�ɕ����ĕ��ς����A���҂�paired-ttest���s���B
%     nSPF=1�Ƃ���ƁAMFmethod���g�킸�ɑSTrial�΂ɑ΂���paired ttest���s���B
% Reference
%     None
% Example
%     pse_btc([-0.03 -0.01],[-0.01 -0.02],3,[0.001 0.002],0.01/20,1,'pseN1','normal','any');
%
% ---------------------------
% Method
%     'ttest'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetime�̕��ςƊe���ԃf�[�^��Multiple fragment method�ɂ����fragment�ɕ�����paired ttest���s���B
%     ����ttest�ŗL�ӂȓ_���Akk/nn(sec)�ȏ㑱���Ă�����̂�peak�Ƃ݂Ȃ��B
%     ����ɁAOnset Latency��SearchTW�͈̔͂ɓ����Ă�����̂��ApeakTW�Ƃ��đI��ł���B
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peak�Ƃ��Ă݂Ȃ��ꂽ���Ԃ̃f�[�^�ɂ��āATrial��nSPF(number of spikes per fragment)�ɕ����Ċe�X�̕��ς����B
%     ���l��Basemean�̕��ς�fragment�ɕ����ĕ��ς����A���҂�paired-ttest���s���B
%     nSPF=1�Ƃ���ƁAMFmethod���g�킸�ɑSTrial�΂ɑ΂���paired ttest���s���B
% Reference
%     None
% Example
%     pse_btc([-0.03 -0.01],[-0.01 -0.02],[],[0.001 0.002],0.01/20,1,'pseT1','ttest','any');
%
% ---------------------------
% Method
%     'schieber'
% BaseLine adjustment
%     nothing (STA�쐬����ISA_flag��1�ɂ��Ă����ꍇ�́AISA���g���ăx�[�X���C����␳)
% Peak Detection
%     Davidson et al 2007���Q��
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peak�Ƃ��Ă݂Ȃ��ꂽ���Ԃ̃f�[�^�ɂ��āATrial��nSPF(number of spikes per fragment)�ɕ����Ċe�X�̕��ς����B
%     ���l��Basemean�̕��ς�fragment�ɕ����ĕ��ς����A���҂�paired-ttest���s���B
%     nSPF=1�Ƃ���ƁAMFmethod���g�킸�ɑSTrial�΂ɑ΂���paired ttest���s���B
% Reference
%     Davidson et al, 2007
% Example
%     pse_btc([-0.03 -0.01],[0.003 0.015],2,[0 0],0.05/20,100,'pseS1','schieber',[]);
%
% ---------------------------
% Method
%     'baker'
% BaseLine adjustment
%     reference����͕s���������̂ŁA����Lemon�ƈꏏ�ɂ��Ă���B
% Peak Detection
%     Basetime�̕��ρ}nsd(1)���Akk/nn(sec)�����Ă��镨��peak�Ƃ݂Ȃ��B
%     ����ɁAOnset Latency��SearchTW�͈̔͂ɓ����Ă�����̂��ApeakTW�Ƃ��đI��ł���B
% Significance test of Peak
%     Peak�̃A���v���`���[�h��nsd(2)�𒴂�����̂�L�ӂƂ݂Ȃ��B
% Reference
%     Baker and Lemon 1998
% Example
%     sta_btc([-0.04 0.06],[2000 Inf],5,0,0,0,0,0)
%     pse_btc([-0.04 -0.01;-0.04 -0.015;0.045 0.06], [-0.01 0.02], [2 3.6],[0.0002 0.0002] , [], [], 'pseB1','baker','any')
%
% ---------------------------
% Method
%     'lemon'
% BaseLine adjustment
%     linear(Basetime(2,1)����Basetime(2,2)�܂ł�Basetime(3,1)����Basetime(3,2)�܂ł̃f�[�^�i��ʓI�ɔg�`�̈�ԍŏ��ƈ�ԍŌ�j���g���Đ��`�̃t�B�b�e�B���O���������␳����)
% Peak Detection
%     Basetime�̕��ρ}nsd���Akk/nn(sec)�����Ă��镨��peak�Ƃ݂Ȃ��B
%     ����ɁAOnset Latency��SearchTW�͈̔͂ɓ����Ă�����̂��ApeakTW�Ƃ��đI��ł���B
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peak�Ƃ��Ă݂Ȃ��ꂽ���Ԃ̃f�[�^�ɂ��āATrial��nSPF(number of spikes per fragment)�ɕ����Ċe�X�̕��ς����B
%     ���l��Basemean�̕��ς�fragment�ɕ����ĕ��ς����A���҂�paired-ttest���s���B
%     nSPF=1�Ƃ���ƁAMFmethod���g�킸�ɑSTrial�΂ɑ΂���paired ttest���s���B
% Reference
%
% Example
%     sta_btc([-0.04 0.06],[2000 Inf],5,0,0,0,0,0)
%     pse_btc([-0.04 -0.01;-0.04 -0.015;0.035 0.06], [-0.01 0.02], 2,[0.0002 0.0002] , 0.05, 500, 'pseL1','lemon','any')
% ---------------------------





if nargin < 8
    method      = 'normal';
    SearchObj   = 'any';
    BaseLineChannel_flag    = 0;
elseif nargin < 9
    SearchObj   = 'any';
    BaseLineChannel_flag    = 0;
elseif nargin < 10
    BaseLineChannel_flag    = 0;
end

if(~strcmpi(method,'sdr'))
    BaseLineChannel_flag    = 0;
end
disp(['method:                  ',method]);
disp(['BaseLineChannel_flag:    ',num2str(BaseLineChannel_flag)]);

kk  = kknn(1);
nn  = kknn(2);

warning('off');

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end

ParentDir   = uigetdir(ParentDir,'�e�t�H���_��I�����Ă��������B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'�ΏۂƂ���file��I�����Ă�������');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end

if(BaseLineChannel_flag==1) % ���̂Ƃ���'sdr'�̂�
    InputDir    = InputDirs{1};
    Reffiles    = dirmat(fullfile(ParentDir,InputDir));
    Reffiles    = sortxls(strfilt(Reffiles,'~._'));
    Reffiles    = uiselect(Reffiles,1,'Base Line�Ƃ���file��I�����Ă�������');
    if(isempty(Reffiles))
        disp('User pressed cancel.')
    return;
end
else
    Reffiles    = {[]};
end

nTarfiles   = length(Tarfiles);
nReffiles   = length(Reffiles);

if(nTarfiles==nReffiles)
    OneToOne_flag   = 1;
    disp(['OneToOne_flag:           ',num2str(OneToOne_flag)]);
else
    OneToOne_flag   = 0;
    disp(['OneToOne_flag:           ',num2str(OneToOne_flag)]);
end

for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};

        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

        for ii=1:length(Tarfiles)
            try
                Tarfile = Tarfiles{ii};
                                
                InputFile_hdr  = fullfile(ParentDir,InputDir,Tarfile);
                InputFile_dat  = fullfile(ParentDir,InputDir,['._',Tarfile]);

                Tar_hdr = load(InputFile_hdr);

                if(exist(InputFile_dat,'file'))
                    if(ismember('TrialData',who('-file',InputFile_dat)))
                        if(ismember('ISATrialData',who('-file',InputFile_dat)))
                            Tar_dat = load(InputFile_dat,'TrialData','ISATrialData');
                        else
                            Tar_dat = load(InputFile_dat,'TrialData');
                        end
                    else
                        Tar_dat = [];
                    end
                else
                    Tar_dat = [];
                end
                
                if(BaseLineChannel_flag==1)
                    if(OneToOne_flag==1)
                        Reffile = Reffiles{ii};
                    else
                        Reffile = Reffiles{1};
                    end
                    if(isempty(Reffile))
                        Ref_hdr = [];
                    else
                        fullReffile = fullfile(ParentDir,InputDir,Reffile);
                        Ref_hdr     = load(fullReffile);
                    end
                else
                    Ref_hdr = [];
                end
                
                
                [Tar_hdr2,Tar_dat] = applyTrialsToUse(Tar_hdr,Tar_dat); % applyTrialsToUse����B
                Ref_hdr            = applyTrialsToUse(Ref_hdr); 
                
                % applyTrialsToUse������pse���s���Apsename field�����
                Tar_hdr2 = pse(Tar_hdr2,Tar_dat,BaseWindow,SearchTW,nsd,nn,kk,alpha,nSPF,psename,method,SearchObj,Ref_hdr);
                Tar_hdr.(psename)   = Tar_hdr2.(psename);   % psename field����������hdr�t�@�C���ɖ߂��iTrialsToUse����STA�t�@�C���Ɏc�邪�Apse���ǂ�TrialsToUse��Ԃōs�����̂��͂킩��Ȃ��Ȃ�j
                
                save(InputFile_hdr,'-struct','Tar_hdr')
                clear('Tar_hdr','Tar_dat')

                disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',InputFile_hdr])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})];
                disp(errormsg)
                errorlog(errormsg);
            end
            %                 indicator(ii,length(Tarfiles))
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

warning('on');