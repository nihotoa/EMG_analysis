function pse_btc(BaseWindow, SearchTW, nsd, kknn, alpha, nSPF, psename, method, SearchObj, BaseLineChannel_flag)
% pse_btc(BaseWindow, SearchTW, nsd, kknn, alpha, nSPF, psename, method, SearchObj[, BaseLineChannel_flag])
% pse_btc([-0.03 -0.01],[0.003 0.015],2,[0 0],0.05/20, 100,'pseS2','Schieber', []); %All
% pse_btc([-0.03 -0.01],[-0.01 -0.02],3,[0.001 0.002],0.01/20,1,'pse1', 'any');
%
% BaseWindow    (sec) [-0.03 -0.01];
% nsd           2;
% kknn          [kk nn](sec) kk/nn(sec)よりdurationが長いものを選ぶ（機能は下を参照）;
% alpha         0.05/20;
%
%
%
%
% BaseLineとは,ISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
% すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。ISA≠BaseLine
%
% ---------------------------
% Method
%     'sdr'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Peakとしてみなされた範囲のデータbasetimeのデータに対して対応のない（poolされたデータ）t検定を行う。
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
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
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
%     Basetimeの平均と各時間データをMultiple fragment methodによってfragmentに分けてpaired ttestを行う。
%     このttestで有意な点が、kk/nn(sec)以上続いているものをpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%     None
% Example
%     pse_btc([-0.03 -0.01],[-0.01 -0.02],[],[0.001 0.002],0.01/20,1,'pseT1','ttest','any');
%
% ---------------------------
% Method
%     'schieber'
% BaseLine adjustment
%     nothing (STA作成時にISA_flagを1にしていた場合は、ISAを使ってベースラインを補正)
% Peak Detection
%     Davidson et al 2007を参照
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%     Davidson et al, 2007
% Example
%     pse_btc([-0.03 -0.01],[0.003 0.015],2,[0 0],0.05/20,100,'pseS1','schieber',[]);
%
% ---------------------------
% Method
%     'baker'
% BaseLine adjustment
%     referenceからは不明だったので、次のLemonと一緒にしている。
% Peak Detection
%     Basetimeの平均±nsd(1)を、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Peakのアンプリチュードがnsd(2)を超えるものを有意とみなす。
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
%     linear(Basetime(2,1)からBasetime(2,2)までとBasetime(3,1)からBasetime(3,2)までのデータ（一般的に波形の一番最初と一番最後）を使って線形のフィッティングをしこれを補正する)
% Peak Detection
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
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

ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'対象とするfileを選択してください');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end

if(BaseLineChannel_flag==1) % 今のところ'sdr'のみ
    InputDir    = InputDirs{1};
    Reffiles    = dirmat(fullfile(ParentDir,InputDir));
    Reffiles    = sortxls(strfilt(Reffiles,'~._'));
    Reffiles    = uiselect(Reffiles,1,'Base Lineとするfileを選択してください');
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
                
                
                [Tar_hdr2,Tar_dat] = applyTrialsToUse(Tar_hdr,Tar_dat); % applyTrialsToUseする。
                Ref_hdr            = applyTrialsToUse(Ref_hdr); 
                
                % applyTrialsToUseをしてpseを行い、psename fieldを作る
                Tar_hdr2 = pse(Tar_hdr2,Tar_dat,BaseWindow,SearchTW,nsd,nn,kk,alpha,nSPF,psename,method,SearchObj,Ref_hdr);
                Tar_hdr.(psename)   = Tar_hdr2.(psename);   % psename fieldだけを元のhdrファイルに戻す（TrialsToUse情報はSTAファイルに残るが、pseがどのTrialsToUse状態で行ったのかはわからなくなる）
                
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