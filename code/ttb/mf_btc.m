function mf_btc(psename,EMGind,dth)

if nargin < 3
    dth = 0;
end



% dth     = 0.003;        %%% duration threshold　durationが3ms以上のものを有意とみなす。
% fname   = 'sigpeakindTW';   %%% TW内のすべての有意なピークからMFを算出する
fname   = 'maxsigpeakindTW';  %%% TW内のabs(peakd)が最大の有意なピークからMFを算出する

ParentDir   = uigetdir(fullfile(datapath,'STA'),'SpTAデータが入っている親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
OutputDir   = uigetdir(fullfile(datapath,'MF'),'出力先フォルダを選択してください。');


InputDir    = InputDirs{1};
files       = dirmat(fullfile(ParentDir,InputDir));
files       = strfilt(files,'STA ~._');
[Trigs,EMGs]= getRefTarName(files);
EMGs        = sortxls(unique(EMGs));

nDirs       = length(InputDirs);
nEMG        = length(EMGs);
uiwait(msgbox(EMGs',['確認 nEMG=',num2str(nEMG)],'modal'));

isAny         = false(1,length(EMGs));
isAnyF        = isAny;
isAnyS        = isAny;
isPSE         = isAny;
isPSF         = isAny;  % 1
isPSS         = isAny;  % 2
isSE          = isAny;  % 3
isSF          = isAny;  % 3
isSS          = isAny;  % 4
MPIs           = zeros(1,length(EMGs));
PPIs           = MPIs;
APIs           = MPIs;

CRonsets    = EMGind.onset;
CRPWHM      = EMGind.pwhm;


for iDir=1:nDirs
    InputDir    = InputDirs{iDir};

    try
        for iEMG=1:nEMG
            EMG     = EMGs{iEMG};
            
            CRonset = CRonsets(EMGind.Type(strmatch(parseEMG(EMG),EMGind.Name)));

            file    = strfilt(files,[EMG,' ~._']);
            if(length(file)~=1)
                error('フィルターしても唯一のファイルになりませんでした。ファイルの名前の付け方が特殊な可能性があります。')
            end
            file    = file{1};
            Inputfile   = fullfile(ParentDir,InputDir,file);
            Outputfile  = fullfile(OutputDir,[InputDir,'.mat']);
            
            s   = load(Inputfile,psename);
            if(exist(Outputfile,'file'))
                S   = load(Outputfile);
                if(isfield(S,psename))
                    S   = rmfield(S,psename);
                end
            end
            
            if(~isempty(s.(psename).(fname)) && ~s.(psename).isXtalk)

                onset   = [s.(psename).peaks(s.(psename).(fname)).onset];
                offset  = [s.(psename).peaks(s.(psename).(fname)).offset];
                duration  = [s.(psename).peaks(s.(psename).(fname)).duration];
                MPI     = [s.(psename).peaks(s.(psename).(fname)).MPI];
                PPI     = [s.(psename).peaks(s.(psename).(fname)).PPI];
                API     = [s.(psename).peaks(s.(psename).(fname)).API];
                PWHM    = [s.(psename).peaks(s.(psename).(fname)).PWHM_duration];
                ind     = duration >=dth;


                if(sum(ind)~=0) %%%
                    isAny(iEMG)   = true;
                    onset   = onset(ind);   %%%
                    offset   = offset(ind);   %%%
                    duration   = duration(ind);   %%%
                    MPI   = MPI(ind);   %%%
                    PWHM   = PWHM(ind);   %%%
                    
                    if(any(MPI > 0))
                        isAnyF(iEMG)   = true;
                    else
                        isAnyF(iEMG)   = false;
                    end
                    if(any(MPI < 0))
                        isAnyS(iEMG)   = true;
                    else
                        isAnyS(iEMG)   = false;
                    end
                    
                    if(any(onset >= CRonset & PWHM < CRPWHM))
                        isPSE(iEMG)   = true;
                        MPIs(iEMG)    = MPI;
                        PPIs(iEMG)    = PPI;
                        APIs(iEMG)    = API;
                    else
                        isPSE(iEMG)   = false;
                        MPIs(iEMG)    = 0;
                        PPIs(iEMG)    = 0;
                        APIs(iEMG)    = 0;
                    end
                    if(any(onset >= CRonset & PWHM < CRPWHM & MPI > 0))
                        isPSF(iEMG)   = true;
                    else
                        isPSF(iEMG)   = false;
                    end
                    if(any(onset >= CRonset & PWHM < CRPWHM & MPI < 0))
                        isPSS(iEMG)   = true;
                    else
                        isPSS(iEMG)   = false;
                    end

                    if(any(onset < CRonset | PWHM >= CRPWHM))
                        isSE(iEMG)   = true;
                    else
                        isSE(iEMG)   = false;
                    end
                    if(any((onset < CRonset | PWHM >= CRPWHM) & MPI > 0))
                        isSF(iEMG)   = true;
                    else
                        isSF(iEMG)   = false;
                    end
                    if(any((onset < CRonset & PWHM >= CRPWHM) & MPI < 0))
                        isSS(iEMG)   = true;
                    else
                        isSS(iEMG)   = false;
                    end

                else%%%
                    isAny(iEMG)       = false;    %%%
                    isAnyF(iEMG)      = false;    %%%
                    isAnyS(iEMG)      = false;    %%%
                    isPSE(iEMG)       = false;    %%%
                    isPSF(iEMG)       = false;    %%%
                    isPSS(iEMG)       = false;    %%%
                    isSE(iEMG)        = false;    %%%
                    isSF(iEMG)        = false;    %%%
                    isSS(iEMG)        = false;    %%%
                    MPIs(iEMG)    = 0;
                        PPIs(iEMG)    = 0;
                        APIs(iEMG)    = 0;
                end

            else
                isAny(iEMG)       = false;    %%%
                isAnyF(iEMG)      = false;    %%%
                isAnyS(iEMG)      = false;    %%%
                isPSE(iEMG)       = false;    %%%
                isPSF(iEMG)       = false;    %%%
                isPSS(iEMG)       = false;    %%%
                isSE(iEMG)        = false;    %%%
                isSF(iEMG)        = false;    %%%
                isSS(iEMG)        = false;    %%%
                MPIs(iEMG)    = 0;
                        PPIs(iEMG)    = 0;
                        APIs(iEMG)    = 0;
            end


        end

        S.Name      = InputDir;
        S.AnalysisType  = 'MF';
        S.EMGName   = EMGs;
        S.(psename).CRonset   = CRonsets;
        S.(psename).CRPWHM    = CRPWHM;
        S.(psename).isAny       =isAny;
        S.(psename).isAnyF      =isAnyF;
        S.(psename).isAnyS      =isAnyS;
        S.(psename).isPSE       =isPSE;
        S.(psename).isPSF       =isPSF;
        S.(psename).isPSS       =isPSS;
        S.(psename).isSE        =isSE;
        S.(psename).isSF        =isSF;
        S.(psename).isSS        =isSS;
        S.(psename).MPI         =MPIs;
        S.(psename).PPI         =PPIs;
        S.(psename).API         =APIs;
        S.(psename).N_Any      = sum(isAny);
        S.(psename).N_AnyF     = sum(isAnyF);
        S.(psename).N_AnyS     = sum(isAnyS);
        S.(psename).N_PSE      = sum(isPSE);
        S.(psename).N_PSF      = sum(isPSF);
        S.(psename).N_PSS      = sum(isPSS);
        S.(psename).N_SE      = sum(isSE);
        S.(psename).N_SF      = sum(isSF);
        S.(psename).N_SS      = sum(isSS);

        S.(psename).AnyMTX       =double(isAny)' * double(isAny);
        S.(psename).AnyFMTX      =double(isAnyF)' * double(isAnyF);
        S.(psename).AnySMTX      =double(isAnyS)' * double(isAnyS);
        S.(psename).PSEMTX       =double(isPSE)' * double(isPSE);
        S.(psename).PSFMTX       =double(isPSF)' * double(isPSF);
        S.(psename).PSSMTX       =double(isPSS)' * double(isPSS);
        S.(psename).SEMTX        =double(isSE)' * double(isSE);
        S.(psename).SFMTX        =double(isSF)' * double(isSF);
        S.(psename).SSMTX        =double(isSS)' * double(isSS);
        S.(psename).PSF_PSSMTX       =double(isPSF)' * double(isPSS);
        S.(psename).PSS_PSFMTX       =double(isPSS)' * double(isPSF);


        nGroup  = length(EMGind.GroupName);

        S.(psename).GroupAny       =false(1,nGroup);
        S.(psename).GroupAnyF      =false(1,nGroup);
        S.(psename).GroupAnyS      =false(1,nGroup);
        S.(psename).GroupPSE       =false(1,nGroup);
        S.(psename).GroupPSF       =false(1,nGroup);
        S.(psename).GroupPSS       =false(1,nGroup);
        S.(psename).GroupSE        =false(1,nGroup);
        S.(psename).GroupSF        =false(1,nGroup);
        S.(psename).GroupSS        =false(1,nGroup);

        S.(psename).Group_N_Any      = zeros(1,nGroup);
        S.(psename).Group_N_AnyF     = zeros(1,nGroup);
        S.(psename).Group_N_AnyS     = zeros(1,nGroup);
        S.(psename).Group_N_PSE      = zeros(1,nGroup);
        S.(psename).Group_N_PSF      = zeros(1,nGroup);
        S.(psename).Group_N_PSS      = zeros(1,nGroup);
        S.(psename).Group_N_SE       = zeros(1,nGroup);
        S.(psename).Group_N_SF       = zeros(1,nGroup);
        S.(psename).Group_N_SS       = zeros(1,nGroup);

        S.(psename).GroupAnyMTX       = false(nGroup,nGroup);
        S.(psename).GroupAnyFMTX       = false(nGroup,nGroup);
        S.(psename).GroupAnySMTX       = false(nGroup,nGroup);
        S.(psename).GroupPSEMTX       = false(nGroup,nGroup);
        S.(psename).GroupPSFMTX       = false(nGroup,nGroup);
        S.(psename).GroupPSSMTX       = false(nGroup,nGroup);
        S.(psename).GroupSEMTX       = false(nGroup,nGroup);
        S.(psename).GroupSFMTX       = false(nGroup,nGroup);
        S.(psename).GroupSSMTX       = false(nGroup,nGroup);

        S.(psename).GroupPSF_PSSMTX   = false(nGroup,nGroup);
        S.(psename).GroupPSS_PSFMTX   = false(nGroup,nGroup);
        
        S.(psename).Group_N_AnyMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_AnyFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_AnySMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_PSEMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_PSFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_PSSMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_SEMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_SFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_SSMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_N_PSF_PSSMTX   = zeros(nGroup,nGroup);
        S.(psename).Group_N_PSS_PSFMTX   = zeros(nGroup,nGroup);
        
        S.(psename).Group_P_AnyMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_AnyFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_AnySMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_PSEMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_PSFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_PSSMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_SEMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_SFMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_SSMTX       = zeros(nGroup,nGroup);
        S.(psename).Group_P_PSF_PSSMTX   = zeros(nGroup,nGroup);
        S.(psename).Group_P_PSS_PSFMTX   = zeros(nGroup,nGroup);


        for iGroup  =1:nGroup
            S.(psename).GroupAny(iGroup)        =  any(isAny(EMGind.Group==iGroup));
            S.(psename).GroupAnyF(iGroup)        =  any(isAnyF(EMGind.Group==iGroup));
            S.(psename).GroupAnyS(iGroup)        =  any(isAnyS(EMGind.Group==iGroup));
            S.(psename).GroupPSE(iGroup)        =  any(isPSE(EMGind.Group==iGroup));
            S.(psename).GroupPSF(iGroup)        =  any(isPSF(EMGind.Group==iGroup));
            S.(psename).GroupPSS(iGroup)        =  any(isPSS(EMGind.Group==iGroup));
            S.(psename).GroupSE(iGroup)         =  any(isSE(EMGind.Group==iGroup));
            S.(psename).GroupSF(iGroup)         =  any(isSF(EMGind.Group==iGroup));
            S.(psename).GroupSS(iGroup)         =  any(isSS(EMGind.Group==iGroup));

            S.(psename).Group_N_Any(iGroup)        =  sum(isAny(EMGind.Group==iGroup));
            S.(psename).Group_N_AnyF(iGroup)        =  sum(isAnyF(EMGind.Group==iGroup));
            S.(psename).Group_N_AnyS(iGroup)        =  sum(isAnyS(EMGind.Group==iGroup));
            S.(psename).Group_N_PSE(iGroup)        =  sum(isPSE(EMGind.Group==iGroup));
            S.(psename).Group_N_PSF(iGroup)        =  sum(isPSF(EMGind.Group==iGroup));
            S.(psename).Group_N_PSS(iGroup)        =  sum(isPSS(EMGind.Group==iGroup));
            S.(psename).Group_N_SE(iGroup)         =  sum(isSE(EMGind.Group==iGroup));
            S.(psename).Group_N_SF(iGroup)         =  sum(isSF(EMGind.Group==iGroup));
            S.(psename).Group_N_SS(iGroup)         =  sum(isSS(EMGind.Group==iGroup));

        end

        for iGroup =1:nGroup
            for jGroup =1:nGroup
                if(iGroup==jGroup)
                    if(S.(psename).Group_N_Any(iGroup)>1)
                        S.(psename).Group_N_AnyMTX(iGroup,jGroup) = S.(psename).Group_N_Any(iGroup) - 1;
                        S.(psename).Group_P_AnyMTX(iGroup,jGroup) = combination(S.(psename).Group_N_Any(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupAnyMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_AnyMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_AnyMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupAnyMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_AnyF(iGroup)>1)
                        S.(psename).Group_N_AnyFMTX(iGroup,jGroup) = S.(psename).Group_N_AnyF(iGroup) - 1;
                        S.(psename).Group_P_AnyFMTX(iGroup,jGroup) = combination(S.(psename).Group_N_AnyF(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupAnyFMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_AnyFMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_AnyFMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupAnyFMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_AnyS(iGroup)>1)
                        S.(psename).Group_N_AnySMTX(iGroup,jGroup) = S.(psename).Group_N_AnyS(iGroup) - 1;
                        S.(psename).Group_P_AnySMTX(iGroup,jGroup) = combination(S.(psename).Group_N_AnyS(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupAnySMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_AnySMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_AnySMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupAnySMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_PSE(iGroup)>1)
                        S.(psename).Group_N_PSEMTX(iGroup,jGroup) = S.(psename).Group_N_PSE(iGroup) - 1;
                        S.(psename).Group_P_PSEMTX(iGroup,jGroup) = combination(S.(psename).Group_N_PSE(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupPSEMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_PSEMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_PSEMTX(iGroup,jGroup) = 0;                        
                        S.(psename).GroupPSEMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_PSF(iGroup)>1)
                        S.(psename).Group_N_PSFMTX(iGroup,jGroup) = S.(psename).Group_N_PSF(iGroup) - 1;
                        S.(psename).Group_P_PSFMTX(iGroup,jGroup) = combination(S.(psename).Group_N_PSF(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupPSFMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_PSFMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_PSFMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupPSFMTX(iGroup,jGroup)  = false;
                    end

                    if(S.(psename).Group_N_PSS(iGroup)>1)
                        S.(psename).Group_N_PSSMTX(iGroup,jGroup) = S.(psename).Group_N_PSS(iGroup) - 1;
                        S.(psename).Group_P_PSSMTX(iGroup,jGroup) = combination(S.(psename).Group_N_PSS(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupPSSMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_PSSMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_PSSMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupPSSMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_SE(iGroup)>1)
                        S.(psename).Group_N_SEMTX(iGroup,jGroup) = S.(psename).Group_N_SE(iGroup) - 1;
                        S.(psename).Group_P_SEMTX(iGroup,jGroup) = combination(S.(psename).Group_N_SE(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupSEMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_SEMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_SEMTX(iGroup,jGroup) = 0;                        
                        S.(psename).GroupSEMTX(iGroup,jGroup)  = false;
                    end
                    if(S.(psename).Group_N_SF(iGroup)>1)
                        S.(psename).Group_N_SFMTX(iGroup,jGroup) = S.(psename).Group_N_SF(iGroup) - 1;
                        S.(psename).Group_P_SFMTX(iGroup,jGroup) = combination(S.(psename).Group_N_SF(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupSFMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_SFMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_SFMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupSFMTX(iGroup,jGroup)  = false;
                    end

                    if(S.(psename).Group_N_SS(iGroup)>1)
                        S.(psename).Group_N_SSMTX(iGroup,jGroup) = S.(psename).Group_N_SS(iGroup) - 1;
                        S.(psename).Group_P_SSMTX(iGroup,jGroup) = combination(S.(psename).Group_N_SS(iGroup),2) / combination(EMGind.GroupN(iGroup),2);
                        S.(psename).GroupSSMTX(iGroup,jGroup)  = true;
                    else
                        S.(psename).Group_N_SSMTX(iGroup,jGroup) = 0;
                        S.(psename).Group_P_SSMTX(iGroup,jGroup) = 0;
                        S.(psename).GroupSSMTX(iGroup,jGroup)  = false;
                    end
                else
                    S.(psename).Group_N_AnyMTX(iGroup,jGroup) = (S.(psename).Group_N_Any(iGroup) > 0)*S.(psename).Group_N_Any(jGroup);
                    S.(psename).Group_P_AnyMTX(iGroup,jGroup) = (S.(psename).Group_N_Any(iGroup) * S.(psename).Group_N_Any(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupAnyMTX(iGroup,jGroup)  = (S.(psename).GroupAny(iGroup) & S.(psename).GroupAny(jGroup));
                    
                    S.(psename).Group_N_AnyFMTX(iGroup,jGroup) = (S.(psename).Group_N_AnyF(iGroup) > 0)*S.(psename).Group_N_AnyF(jGroup);
                    S.(psename).Group_P_AnyFMTX(iGroup,jGroup) = (S.(psename).Group_N_AnyF(iGroup) * S.(psename).Group_N_AnyF(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupAnyFMTX(iGroup,jGroup)  = (S.(psename).GroupAnyF(iGroup) & S.(psename).GroupAnyF(jGroup));
                    
                    S.(psename).Group_N_AnySMTX(iGroup,jGroup) = (S.(psename).Group_N_AnyS(iGroup) > 0)*S.(psename).Group_N_AnyS(jGroup);
                    S.(psename).Group_P_AnySMTX(iGroup,jGroup) = (S.(psename).Group_N_AnyS(iGroup) * S.(psename).Group_N_AnyS(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupAnySMTX(iGroup,jGroup)  = (S.(psename).GroupAnyS(iGroup) & S.(psename).GroupAnyS(jGroup));
                    
                    S.(psename).Group_N_PSEMTX(iGroup,jGroup) = (S.(psename).Group_N_PSE(iGroup) > 0)*S.(psename).Group_N_PSE(jGroup);
                    S.(psename).Group_P_PSEMTX(iGroup,jGroup) = (S.(psename).Group_N_PSE(iGroup) * S.(psename).Group_N_PSE(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupPSEMTX(iGroup,jGroup)  = (S.(psename).GroupPSE(iGroup) & S.(psename).GroupPSE(jGroup));
                    
                    S.(psename).Group_N_PSFMTX(iGroup,jGroup) = (S.(psename).Group_N_PSF(iGroup) > 0)*S.(psename).Group_N_PSF(jGroup);
                    S.(psename).Group_P_PSFMTX(iGroup,jGroup) = (S.(psename).Group_N_PSF(iGroup) * S.(psename).Group_N_PSF(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupPSFMTX(iGroup,jGroup)  = (S.(psename).GroupPSF(iGroup) & S.(psename).GroupPSF(jGroup));

                    S.(psename).Group_N_PSSMTX(iGroup,jGroup) = (S.(psename).Group_N_PSS(iGroup) > 0)*S.(psename).Group_N_PSS(jGroup);
                    S.(psename).Group_P_PSSMTX(iGroup,jGroup) = (S.(psename).Group_N_PSS(iGroup) * S.(psename).Group_N_PSS(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupPSSMTX(iGroup,jGroup)  = (S.(psename).GroupPSS(iGroup) & S.(psename).GroupPSS(jGroup));
                    
                    S.(psename).Group_N_SEMTX(iGroup,jGroup) = (S.(psename).Group_N_SE(iGroup) > 0)*S.(psename).Group_N_SE(jGroup);
                    S.(psename).Group_P_SEMTX(iGroup,jGroup) = (S.(psename).Group_N_SE(iGroup) * S.(psename).Group_N_SE(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupSEMTX(iGroup,jGroup)  = (S.(psename).GroupSE(iGroup) & S.(psename).GroupSE(jGroup));
                    
                    S.(psename).Group_N_SFMTX(iGroup,jGroup) = (S.(psename).Group_N_SF(iGroup) > 0)*S.(psename).Group_N_SF(jGroup);
                    S.(psename).Group_P_SFMTX(iGroup,jGroup) = (S.(psename).Group_N_SF(iGroup) * S.(psename).Group_N_SF(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupSFMTX(iGroup,jGroup)  = (S.(psename).GroupSF(iGroup) & S.(psename).GroupSF(jGroup));

                    S.(psename).Group_N_SSMTX(iGroup,jGroup) = (S.(psename).Group_N_SS(iGroup) > 0)*S.(psename).Group_N_SS(jGroup);
                    S.(psename).Group_P_SSMTX(iGroup,jGroup) = (S.(psename).Group_N_SS(iGroup) * S.(psename).Group_N_SS(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupSSMTX(iGroup,jGroup)  = (S.(psename).GroupSS(iGroup) & S.(psename).GroupSS(jGroup));

                    S.(psename).Group_N_PSF_PSSMTX(iGroup,jGroup)  = (S.(psename).Group_N_PSF(iGroup) > 0)*S.(psename).Group_N_PSS(jGroup);
                    S.(psename).Group_P_PSF_PSSMTX(iGroup,jGroup) = (S.(psename).Group_N_PSF(iGroup) * S.(psename).Group_N_PSS(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupPSF_PSSMTX(iGroup,jGroup)  = (S.(psename).GroupPSF(iGroup) & S.(psename).GroupPSS(jGroup));

                    S.(psename).Group_N_PSS_PSFMTX(iGroup,jGroup)  = (S.(psename).Group_N_PSS(iGroup) > 0)*S.(psename).Group_N_PSF(jGroup);
                    S.(psename).Group_P_PSS_PSFMTX(iGroup,jGroup) = (S.(psename).Group_N_PSS(iGroup) * S.(psename).Group_N_PSF(jGroup)) / (EMGind.GroupN(iGroup) * EMGind.GroupN(jGroup));
                    S.(psename).GroupPSS_PSFMTX(iGroup,jGroup)  = (S.(psename).GroupPSS(iGroup) & S.(psename).GroupPSF(jGroup));

                end
            end
        end

        
        save(Outputfile,'-struct','S');
        disp(Outputfile)


    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end