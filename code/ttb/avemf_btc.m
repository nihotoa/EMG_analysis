function avemf_btc(Name,psename,EMGind)

InputDir    = uigetdir(fullfile(datapath,'MF'),'MFデータが入っているフォルダを選択してください。');
files       = uiselect(sortxls(deext(dirmat(InputDir))),1,'平均する対象となるファイルを選択してください');
OutputDir   = InputDir;
% OutputDir   = uigetdir(fullfile(datapath,'MF'),'出力先フォルダを選択してください。');
Outputfile  = fullfile(OutputDir,['AVEMF(',Name,').mat']);
if(exist(Outputfile,'file'))
    S       = load(Outputfile);
end

nfile       = length(files);



for ifile=1:nfile
    s   = load(fullfile(InputDir,files{ifile}));
    if(ifile==1)
        %         S   = s;

        S.Name      = ['AVEMF(',Name,')'];
        S.AnalysisType  = 'AVEMF';
        S.MFName    = files;
        S.nfiles    = nfile;
        S.EMGName   = s.EMGName;

        nEMG    = length(s.EMGName);
        nGroup  = length(EMGind.GroupName);


        S.(psename).isAny_all   = false(nfile,nEMG);
        S.(psename).isAnyF_all  = false(nfile,nEMG);
        S.(psename).isAnyS_all  = false(nfile,nEMG);
        S.(psename).isPSE_all   = false(nfile,nEMG);
        S.(psename).isPSF_all   = false(nfile,nEMG);
        S.(psename).isPSS_all   = false(nfile,nEMG);
        S.(psename).isSE_all    = false(nfile,nEMG);
        S.(psename).isSF_all    = false(nfile,nEMG);
        S.(psename).isSS_all    = false(nfile,nEMG);
        
        S.(psename).N_Any_cell   = zeros(nfile,1);
        S.(psename).N_AnyF_cell  = zeros(nfile,1);
        S.(psename).N_AnyS_cell  = zeros(nfile,1);
        S.(psename).N_PSE_cell   = zeros(nfile,1);
        S.(psename).N_PSF_cell   = zeros(nfile,1);
        S.(psename).N_PSS_cell   = zeros(nfile,1);
        S.(psename).N_SE_cell    = zeros(nfile,1);
        S.(psename).N_SF_cell    = zeros(nfile,1);
        S.(psename).N_SS_cell    = zeros(nfile,1);
        
        S.(psename).N_Any_EMG   = zeros(nfile,1);
        S.(psename).N_AnyF_EMG  = zeros(nfile,1);
        S.(psename).N_AnyS_EMG  = zeros(nfile,1);
        S.(psename).N_PSE_EMG   = zeros(nfile,1);
        S.(psename).N_PSF_EMG   = zeros(nfile,1);
        S.(psename).N_PSS_EMG   = zeros(nfile,1);
        S.(psename).N_SE_EMG    = zeros(nfile,1);
        S.(psename).N_SF_EMG    = zeros(nfile,1);
        S.(psename).N_SS_EMG    = zeros(nfile,1);
        
        S.(psename).MPI_all     = nan(nfile,nEMG);
        S.(psename).PPI_all     = nan(nfile,nEMG);
        S.(psename).API_all     = nan(nfile,nEMG);
        
        S.(psename).Group_isAny_all   = false(nfile,nGroup);
        S.(psename).Group_isAnyF_all  = false(nfile,nGroup);
        S.(psename).Group_isAnyS_all  = false(nfile,nGroup);
        S.(psename).Group_isPSE_all   = false(nfile,nGroup);
        S.(psename).Group_isPSF_all   = false(nfile,nGroup);
        S.(psename).Group_isPSS_all   = false(nfile,nGroup);
        S.(psename).Group_isSE_all    = false(nfile,nGroup);
        S.(psename).Group_isSF_all    = false(nfile,nGroup);
        S.(psename).Group_isSS_all    = false(nfile,nGroup);


        S.(psename).isAny       = false(nfile,1);
        S.(psename).isAnyF      = false(nfile,1);
        S.(psename).isAnyS      = false(nfile,1);
        S.(psename).isPSE       = false(nfile,1);
        S.(psename).isPSF       = false(nfile,1);
        S.(psename).isPSS       = false(nfile,1);
        S.(psename).isSE        = false(nfile,1);
        S.(psename).isSF        = false(nfile,1);
        S.(psename).isSS        = false(nfile,1);

        S.(psename).nCell       = nfile;
        S.(psename).nCell_Any   = [];
        S.(psename).nCell_AnyF  = [];
        S.(psename).nCell_AnyS  = [];
        S.(psename).nCell_PSE   = [];
        S.(psename).nCell_PSF   = [];
        S.(psename).nCell_PSS   = [];
        S.(psename).nCell_SE    = [];
        S.(psename).nCell_SF    = [];
        S.(psename).nCell_SS    = [];


        S.(psename).N_AnyMTX  = zeros(nEMG);
        S.(psename).N_AnyFMTX = zeros(nEMG);
        S.(psename).N_AnySMTX = zeros(nEMG);
        S.(psename).N_PSEMTX  = zeros(nEMG);
        S.(psename).N_PSFMTX  = zeros(nEMG);
        S.(psename).N_PSSMTX  = zeros(nEMG);
        S.(psename).N_SEMTX   = zeros(nEMG);
        S.(psename).N_SFMTX   = zeros(nEMG);
        S.(psename).N_SSMTX   = zeros(nEMG);

        S.(psename).P_AnyMTX  = zeros(nEMG);
        S.(psename).P_AnyFMTX = zeros(nEMG);
        S.(psename).P_AnySMTX = zeros(nEMG);
        S.(psename).P_PSEMTX  = zeros(nEMG);
        S.(psename).P_PSFMTX  = zeros(nEMG);
        S.(psename).P_PSSMTX  = zeros(nEMG);
        S.(psename).P_SEMTX   = zeros(nEMG);
        S.(psename).P_SFMTX   = zeros(nEMG);
        S.(psename).P_SSMTX   = zeros(nEMG);
        
        S.(psename).R_AnyMTX  = zeros(nEMG);
        S.(psename).R_AnyFMTX = zeros(nEMG);
        S.(psename).R_AnySMTX = zeros(nEMG);
        S.(psename).R_PSEMTX  = zeros(nEMG);
        S.(psename).R_PSFMTX  = zeros(nEMG);
        S.(psename).R_PSSMTX  = zeros(nEMG);
        S.(psename).R_SEMTX   = zeros(nEMG);
        S.(psename).R_SFMTX   = zeros(nEMG);
        S.(psename).R_SSMTX   = zeros(nEMG);

        S.(psename).Rp_AnyMTX  = zeros(nEMG);
        S.(psename).Rp_AnyFMTX = zeros(nEMG);
        S.(psename).Rp_AnySMTX = zeros(nEMG);
        S.(psename).Rp_PSEMTX  = zeros(nEMG);
        S.(psename).Rp_PSFMTX  = zeros(nEMG);
        S.(psename).Rp_PSSMTX  = zeros(nEMG);
        S.(psename).Rp_SEMTX   = zeros(nEMG);
        S.(psename).Rp_SFMTX   = zeros(nEMG);
        S.(psename).Rp_SSMTX   = zeros(nEMG);
% 
%         S.(psename).Surprise_AnyMTX  = zeros(nEMG);
%         S.(psename).Surprise_AnyFMTX = zeros(nEMG);
%         S.(psename).Surprise_AnySMTX = zeros(nEMG);
%         S.(psename).Surprise_PSEMTX  = zeros(nEMG);
%         S.(psename).Surprise_PSFMTX  = zeros(nEMG);
%         S.(psename).Surprise_PSSMTX  = zeros(nEMG);
%         S.(psename).Surprise_SEMTX   = zeros(nEMG);
%         S.(psename).Surprise_SFMTX   = zeros(nEMG);
%         S.(psename).Surprise_SSMTX   = zeros(nEMG);
% 
%         S.(psename).Predictor_AnyMTX  = zeros(nEMG);
%         S.(psename).Predictor_AnyFMTX = zeros(nEMG);
%         S.(psename).Predictor_AnySMTX = zeros(nEMG);
%         S.(psename).Predictor_PSEMTX  = zeros(nEMG);
%         S.(psename).Predictor_PSFMTX  = zeros(nEMG);
%         S.(psename).Predictor_PSSMTX  = zeros(nEMG);
%         S.(psename).Predictor_SEMTX   = zeros(nEMG);
%         S.(psename).Predictor_SFMTX   = zeros(nEMG);
%         S.(psename).Predictor_SSMTX   = zeros(nEMG);

        S.(psename).Group_N_AnyMTX  = zeros(nGroup);
        S.(psename).Group_N_AnyFMTX = zeros(nGroup);
        S.(psename).Group_N_AnySMTX = zeros(nGroup);
        S.(psename).Group_N_PSEMTX  = zeros(nGroup);
        S.(psename).Group_N_PSFMTX  = zeros(nGroup);
        S.(psename).Group_N_PSSMTX  = zeros(nGroup);
        S.(psename).Group_N_SEMTX   = zeros(nGroup);
        S.(psename).Group_N_SFMTX   = zeros(nGroup);
        S.(psename).Group_N_SSMTX   = zeros(nGroup);

        S.(psename).Group_P_AnyMTX  = zeros(nGroup);
        S.(psename).Group_P_AnyFMTX = zeros(nGroup);
        S.(psename).Group_P_AnySMTX = zeros(nGroup);
        S.(psename).Group_P_PSEMTX  = zeros(nGroup);
        S.(psename).Group_P_PSFMTX  = zeros(nGroup);
        S.(psename).Group_P_PSSMTX  = zeros(nGroup);
        S.(psename).Group_P_SEMTX   = zeros(nGroup);
        S.(psename).Group_P_SFMTX   = zeros(nGroup);
        S.(psename).Group_P_SSMTX   = zeros(nGroup);

        S.(psename).Group_N_isAnyMTX  = zeros(nGroup);
        S.(psename).Group_N_isAnyFMTX = zeros(nGroup);
        S.(psename).Group_N_isAnySMTX = zeros(nGroup);
        S.(psename).Group_N_isPSEMTX  = zeros(nGroup);
        S.(psename).Group_N_isPSFMTX  = zeros(nGroup);
        S.(psename).Group_N_isPSSMTX  = zeros(nGroup);
        S.(psename).Group_N_isSEMTX   = zeros(nGroup);
        S.(psename).Group_N_isSFMTX   = zeros(nGroup);
        S.(psename).Group_N_isSSMTX   = zeros(nGroup);

        S.(psename).Group_P_isAnyMTX  = zeros(nGroup);
        S.(psename).Group_P_isAnyFMTX = zeros(nGroup);
        S.(psename).Group_P_isAnySMTX = zeros(nGroup);
        S.(psename).Group_P_isPSEMTX  = zeros(nGroup);
        S.(psename).Group_P_isPSFMTX  = zeros(nGroup);
        S.(psename).Group_P_isPSSMTX  = zeros(nGroup);
        S.(psename).Group_P_isSEMTX   = zeros(nGroup);
        S.(psename).Group_P_isSFMTX   = zeros(nGroup);
        S.(psename).Group_P_isSSMTX   = zeros(nGroup);

    end
    S.(psename).isAny_all(ifile,:)    = s.(psename).isAny;
    S.(psename).isAnyF_all(ifile,:)   = s.(psename).isAnyF;
    S.(psename).isAnyS_all(ifile,:)   = s.(psename).isAnyS;
    S.(psename).isPSE_all(ifile,:)    = s.(psename).isPSE;
    S.(psename).isPSF_all(ifile,:)    = s.(psename).isPSF;
    S.(psename).isPSS_all(ifile,:)    = s.(psename).isPSS;
    S.(psename).isSE_all(ifile,:)     = s.(psename).isSE;
    S.(psename).isSF_all(ifile,:)     = s.(psename).isSF;
    S.(psename).isSS_all(ifile,:)     = s.(psename).isSS;

    S.(psename).MPI_all(ifile,:)     = s.(psename).MPI;
    S.(psename).PPI_all(ifile,:)     = s.(psename).PPI;
    S.(psename).API_all(ifile,:)     = s.(psename).API;
    
    S.(psename).Group_isAny_all(ifile,:)    = s.(psename).GroupAny;
    S.(psename).Group_isAnyF_all(ifile,:)   = s.(psename).GroupAnyF;
    S.(psename).Group_isAnyS_all(ifile,:)   = s.(psename).GroupAnyS;
    S.(psename).Group_isPSE_all(ifile,:)    = s.(psename).GroupPSE;
    S.(psename).Group_isPSF_all(ifile,:)    = s.(psename).GroupPSF;
    S.(psename).Group_isPSS_all(ifile,:)    = s.(psename).GroupPSS;
    S.(psename).Group_isSE_all(ifile,:)     = s.(psename).GroupSE;
    S.(psename).Group_isSF_all(ifile,:)     = s.(psename).GroupSF;
    S.(psename).Group_isSS_all(ifile,:)     = s.(psename).GroupSS;
    
    S.(psename).isAny(ifile)    = any(s.(psename).isAny);
    S.(psename).isAnyF(ifile)   = any(s.(psename).isAnyF);
    S.(psename).isAnyS(ifile)   = any(s.(psename).isAnyS);
    S.(psename).isPSE(ifile)    = any(s.(psename).isPSE);
    S.(psename).isPSF(ifile)    = any(s.(psename).isPSF);
    S.(psename).isPSS(ifile)    = any(s.(psename).isPSS);
    S.(psename).isSE(ifile)     = any(s.(psename).isSE);
    S.(psename).isSF(ifile)     = any(s.(psename).isSF);
    S.(psename).isSS(ifile)     = any(s.(psename).isSS);

    %         S.(psename).N_Any       = [S.(psename).N_Any ; s.(psename).N_Any];
    %         S.(psename).N_AnyF      = [S.(psename).N_AnyF ; s.(psename).N_AnyF];
    %         S.(psename).N_AnyS      = [S.(psename).N_AnyS ; s.(psename).N_AnyS];
    %         S.(psename).N_PSE       = [S.(psename).N_PSE ; s.(psename).N_PSE];
    %         S.(psename).N_PSF       = [S.(psename).N_PSF ; s.(psename).N_PSF];
    %         S.(psename).N_PSS       = [S.(psename).N_PSS ; s.(psename).N_PSS];
    %         S.(psename).N_SE        = [S.(psename).N_SE ; s.(psename).N_SE];
    %         S.(psename).N_SF        = [S.(psename).N_SF ; s.(psename).N_SF];
    %         S.(psename).N_SS        = [S.(psename).N_SS ; s.(psename).N_SS];

    S.(psename).N_AnyMTX       = S.(psename).N_AnyMTX + s.(psename).AnyMTX;
    S.(psename).N_AnyFMTX      = S.(psename).N_AnyFMTX + s.(psename).AnyFMTX;
    S.(psename).N_AnySMTX      = S.(psename).N_AnySMTX + s.(psename).AnySMTX;
    S.(psename).N_PSEMTX       = S.(psename).N_PSEMTX + s.(psename).PSEMTX;
    S.(psename).N_PSFMTX       = S.(psename).N_PSFMTX + s.(psename).PSFMTX;
    S.(psename).N_PSSMTX       = S.(psename).N_PSSMTX + s.(psename).PSSMTX;
    S.(psename).N_SEMTX        = S.(psename).N_SEMTX + s.(psename).SEMTX;
    S.(psename).N_SFMTX        = S.(psename).N_SFMTX + s.(psename).SFMTX;
    S.(psename).N_SSMTX        = S.(psename).N_SSMTX + s.(psename).SSMTX;

    S.(psename).Group_N_isAnyMTX       = S.(psename).Group_N_isAnyMTX + s.(psename).GroupAnyMTX;
    S.(psename).Group_N_isAnyFMTX      = S.(psename).Group_N_isAnyFMTX + s.(psename).GroupAnyFMTX;
    S.(psename).Group_N_isAnySMTX      = S.(psename).Group_N_isAnySMTX + s.(psename).GroupAnySMTX;
    S.(psename).Group_N_isPSEMTX       = S.(psename).Group_N_isPSEMTX + s.(psename).GroupPSEMTX;
    S.(psename).Group_N_isPSFMTX       = S.(psename).Group_N_isPSFMTX + s.(psename).GroupPSFMTX;
    S.(psename).Group_N_isPSSMTX       = S.(psename).Group_N_isPSSMTX + s.(psename).GroupPSSMTX;
    S.(psename).Group_N_isSEMTX        = S.(psename).Group_N_isSEMTX + s.(psename).GroupSEMTX;
    S.(psename).Group_N_isSFMTX        = S.(psename).Group_N_isSFMTX + s.(psename).GroupSFMTX;
    S.(psename).Group_N_isSSMTX        = S.(psename).Group_N_isSSMTX + s.(psename).GroupSSMTX;

    %         S.(psename).GroupAny       = [S.(psename).GroupAny ; s.(psename).GroupAny];
    %         S.(psename).GroupAnyF       = [S.(psename).GroupAny ; s.(psename).GroupAnyF];
    %         S.(psename).GroupAnyS       = [S.(psename).GroupAny ; s.(psename).GroupAnyS];
    %         S.(psename).GroupPSE       = [S.(psename).GroupPSE ; s.(psename).GroupPSE];
    %         S.(psename).GroupPSF       = [S.(psename).GroupPSF ; s.(psename).GroupPSF];
    %         S.(psename).GroupPSS       = [S.(psename).GroupPSS ; s.(psename).GroupPSS];
    %         S.(psename).GroupSE        = [S.(psename).GroupSE ; s.(psename).GroupSE];
    %         S.(psename).GroupSF        = [S.(psename).GroupSF ; s.(psename).GroupSF];
    %         S.(psename).GroupSS        = [S.(psename).GroupSS ; s.(psename).GroupSS];

    %         S.(psename).Group_N_Any       = [S.(psename).Group_N_Any ; s.(psename).Group_N_Any];
    %         S.(psename).Group_N_AnyF      = [S.(psename).Group_N_AnyF ; s.(psename).Group_N_AnyF];
    %         S.(psename).Group_N_AnyS      = [S.(psename).Group_N_AnyS ; s.(psename).Group_N_AnyS];
    %         S.(psename).Group_N_PSE       = [S.(psename).Group_N_PSE ; s.(psename).Group_N_PSE];
    %         S.(psename).Group_N_PSF       = [S.(psename).Group_N_PSF ; s.(psename).Group_N_PSF];
    %         S.(psename).Group_N_PSS       = [S.(psename).Group_N_PSS ; s.(psename).Group_N_PSS];
    %         S.(psename).Group_N_SE        = [S.(psename).Group_N_SE ; s.(psename).Group_N_SE];
    %         S.(psename).Group_N_SF        = [S.(psename).Group_N_SF ; s.(psename).Group_N_SF];
    %         S.(psename).Group_N_SS        = [S.(psename).Group_N_SS ; s.(psename).Group_N_SS];

    %         S.(psename).GroupAnyMTX       = cat(3,S.(psename).GroupAnyMTX , s.(psename).GroupAnyMTX);
    %         S.(psename).GroupAnyFMTX       = cat(3,S.(psename).GroupAnyFMTX , s.(psename).GroupAnyFMTX);
    %         S.(psename).GroupAnySMTX       = cat(3,S.(psename).GroupAnySMTX , s.(psename).GroupAnySMTX);
    %         S.(psename).GroupPSEMTX       = cat(3,S.(psename).GroupPSEMTX , s.(psename).GroupPSEMTX);
    %         S.(psename).GroupPSFMTX       = cat(3,S.(psename).GroupPSFMTX , s.(psename).GroupPSFMTX);
    %         S.(psename).GroupPSSMTX       = cat(3,S.(psename).GroupPSSMTX , s.(psename).GroupPSSMTX);
    %         S.(psename).GroupSEMTX       = cat(3,S.(psename).GroupSEMTX , s.(psename).GroupSEMTX);
    %         S.(psename).GroupSFMTX       = cat(3,S.(psename).GroupSFMTX , s.(psename).GroupSFMTX);
    %         S.(psename).GroupSSMTX       = cat(3,S.(psename).GroupSSMTX , s.(psename).GroupSSMTX);
    %         S.(psename).GroupPSF_PSSMTX       = cat(3,S.(psename).GroupPSF_PSSMTX , s.(psename).GroupPSF_PSSMTX);
    %         S.(psename).GroupPSS_PSFMTX       = cat(3,S.(psename).GroupPSS_PSFMTX , s.(psename).GroupPSS_PSFMTX);

    %         S.(psename).Group_N_AnyMTX       = cat(3,S.(psename).Group_N_AnyMTX , s.(psename).Group_N_AnyMTX);
    %         S.(psename).Group_N_AnyFMTX       = cat(3,S.(psename).Group_N_AnyFMTX , s.(psename).Group_N_AnyFMTX);
    %         S.(psename).Group_N_AnySMTX       = cat(3,S.(psename).Group_N_AnySMTX , s.(psename).Group_N_AnySMTX);
    %         S.(psename).Group_N_PSEMTX       = cat(3,S.(psename).Group_N_PSEMTX , s.(psename).Group_N_PSEMTX);
    %         S.(psename).Group_N_PSFMTX       = cat(3,S.(psename).Group_N_PSFMTX , s.(psename).Group_N_PSFMTX);
    %         S.(psename).Group_N_PSSMTX       = cat(3,S.(psename).Group_N_PSSMTX , s.(psename).Group_N_PSSMTX);
    %         S.(psename).Group_N_SEMTX       = cat(3,S.(psename).Group_N_SEMTX , s.(psename).Group_N_SEMTX);
    %         S.(psename).Group_N_SFMTX       = cat(3,S.(psename).Group_N_SFMTX , s.(psename).Group_N_SFMTX);
    %         S.(psename).Group_N_SSMTX       = cat(3,S.(psename).Group_N_SSMTX , s.(psename).Group_N_SSMTX);
    %         S.(psename).Group_N_PSF_PSSMTX       = cat(3,S.(psename).Group_N_PSF_PSSMTX , s.(psename).Group_N_PSF_PSSMTX);
    %         S.(psename).Group_N_PSS_PSFMTX       = cat(3,S.(psename).Group_N_PSS_PSFMTX , s.(psename).Group_N_PSS_PSFMTX);
    %
    %         S.(psename).Group_P_AnyMTX       = cat(3,S.(psename).Group_P_AnyMTX , s.(psename).Group_P_AnyMTX);
    %         S.(psename).Group_P_AnyFMTX       = cat(3,S.(psename).Group_P_AnyFMTX , s.(psename).Group_P_AnyFMTX);
    %         S.(psename).Group_P_AnySMTX       = cat(3,S.(psename).Group_P_AnySMTX , s.(psename).Group_P_AnySMTX);
    %         S.(psename).Group_P_PSEMTX       = cat(3,S.(psename).Group_P_PSEMTX , s.(psename).Group_P_PSEMTX);
    %         S.(psename).Group_P_PSFMTX       = cat(3,S.(psename).Group_P_PSFMTX , s.(psename).Group_P_PSFMTX);
    %         S.(psename).Group_P_PSSMTX       = cat(3,S.(psename).Group_P_PSSMTX , s.(psename).Group_P_PSSMTX);
    %         S.(psename).Group_P_SEMTX       = cat(3,S.(psename).Group_P_SEMTX , s.(psename).Group_P_SEMTX);
    %         S.(psename).Group_P_SFMTX       = cat(3,S.(psename).Group_P_SFMTX , s.(psename).Group_P_SFMTX);
    %         S.(psename).Group_P_SSMTX       = cat(3,S.(psename).Group_P_SSMTX , s.(psename).Group_P_SSMTX);
    %         S.(psename).Group_P_PSF_PSSMTX       = cat(3,S.(psename).Group_P_PSF_PSSMTX , s.(psename).Group_P_PSF_PSSMTX);
    %         S.(psename).Group_P_PSS_PSFMTX       = cat(3,S.(psename).Group_P_PSS_PSFMTX , s.(psename).Group_P_PSS_PSFMTX);


    indicator(ifile,nfile)
end
% S.(psename).isAny       = any(S.(psename).isAny ,2);
% S.(psename).isAnyF      = any(S.(psename).isAnyF,2);
% S.(psename).isAnyS      = any(S.(psename).isAnyS,2);
% S.(psename).isPSE       = any(S.(psename).isPSE ,2);
% S.(psename).isPSF       = any(S.(psename).isPSF ,2);
% S.(psename).isPSS       = any(S.(psename).isPSS ,2);
% S.(psename).isSE        = any(S.(psename).isSE  ,2);
% S.(psename).isSF        = any(S.(psename).isSF  ,2);
% S.(psename).isSS        = any(S.(psename).isSS  ,2);

% S.(psename).nCell       = nfile;
S.(psename).nCell_Any   = sum(S.(psename).isAny);
S.(psename).nCell_AnyF  = sum(S.(psename).isAnyF);
S.(psename).nCell_AnyS  = sum(S.(psename).isAnyS);
S.(psename).nCell_PSE   = sum(S.(psename).isPSE);
S.(psename).nCell_PSF   = sum(S.(psename).isPSF);
S.(psename).nCell_PSS   = sum(S.(psename).isPSS);
S.(psename).nCell_SE    = sum(S.(psename).isSE);
S.(psename).nCell_SF    = sum(S.(psename).isSF);
S.(psename).nCell_SS    = sum(S.(psename).isSS);

S.(psename).N_Any_cell    = sum(S.(psename).isAny_all,2);
S.(psename).N_AnyF_cell   = sum(S.(psename).isAnyF_all,2);
S.(psename).N_AnyS_cell   = sum(S.(psename).isAnyS_all,2);
S.(psename).N_PSE_cell    = sum(S.(psename).isPSE_all,2);
S.(psename).N_PSF_cell    = sum(S.(psename).isPSF_all,2);
S.(psename).N_PSS_cell    = sum(S.(psename).isPSS_all,2);
S.(psename).N_SE_cell     = sum(S.(psename).isSE_all,2);
S.(psename).N_SF_cell     = sum(S.(psename).isSF_all,2);
S.(psename).N_SS_cell     = sum(S.(psename).isSS_all,2);
    
S.(psename).N_Any_EMG    = sum(S.(psename).isAny_all,1);
S.(psename).N_AnyF_EMG   = sum(S.(psename).isAnyF_all,1);
S.(psename).N_AnyS_EMG   = sum(S.(psename).isAnyS_all,1);
S.(psename).N_PSE_EMG    = sum(S.(psename).isPSE_all,1);
S.(psename).N_PSF_EMG    = sum(S.(psename).isPSF_all,1);
S.(psename).N_PSS_EMG    = sum(S.(psename).isPSS_all,1);
S.(psename).N_SE_EMG     = sum(S.(psename).isSE_all,1);
S.(psename).N_SF_EMG     = sum(S.(psename).isSF_all,1);
S.(psename).N_SS_EMG     = sum(S.(psename).isSS_all,1);

% S.(psename).SUM_AnyMTX       = squeeze(sum(S.(psename).AnyMTX,3));
% S.(psename).SUM_AnyFMTX      = squeeze(sum(S.(psename).AnyFMTX,3));
% S.(psename).SUM_AnySMTX      = squeeze(sum(S.(psename).AnySMTX,3));
% S.(psename).SUM_PSEMTX       = squeeze(sum(S.(psename).PSEMTX,3));
% S.(psename).SUM_PSFMTX       = squeeze(sum(S.(psename).PSFMTX,3));
% S.(psename).SUM_PSSMTX       = squeeze(sum(S.(psename).PSSMTX,3));
% S.(psename).SUM_SEMTX        = squeeze(sum(S.(psename).SEMTX,3));
% S.(psename).SUM_SFMTX        = squeeze(sum(S.(psename).SFMTX,3));
% S.(psename).SUM_SSMTX        = squeeze(sum(S.(psename).SSMTX,3));

S.(psename).P_AnyMTX       = S.(psename).N_AnyMTX ./    S.(psename).nCell_Any;
S.(psename).P_AnyFMTX      = S.(psename).N_AnyFMTX ./   S.(psename).nCell_AnyF;
S.(psename).P_AnySMTX      = S.(psename).N_AnySMTX ./   S.(psename).nCell_AnyS;
S.(psename).P_PSEMTX       = S.(psename).N_PSEMTX ./    S.(psename).nCell_PSE;
S.(psename).P_PSFMTX       = S.(psename).N_PSFMTX ./    S.(psename).nCell_PSF;
S.(psename).P_PSSMTX       = S.(psename).N_PSSMTX ./    S.(psename).nCell_PSS;
S.(psename).P_SEMTX        = S.(psename).N_SEMTX ./     S.(psename).nCell_SE;
S.(psename).P_SFMTX        = S.(psename).N_SFMTX ./     S.(psename).nCell_SF;
S.(psename).P_SSMTX        = S.(psename).N_SSMTX ./     S.(psename).nCell_SS;

% S.(psename).Predictor_AnyMTX    = S.(psename).N_Any_EMG'*  S.(psename).N_Any_EMG./  S.(psename).nCell_Any;
% S.(psename).Predictor_AnyFMTX   = S.(psename).N_AnyF_EMG'* S.(psename).N_AnyF_EMG./ S.(psename).nCell_AnyF;
% S.(psename).Predictor_AnySMTX   = S.(psename).N_AnyS_EMG'* S.(psename).N_AnyS_EMG./ S.(psename).nCell_AnyS;
% S.(psename).Predictor_PSEMTX    = S.(psename).N_PSE_EMG'*  S.(psename).N_PSE_EMG./  S.(psename).nCell_PSE;
% S.(psename).Predictor_PSFMTX    = S.(psename).N_PSF_EMG'*  S.(psename).N_PSF_EMG./  S.(psename).nCell_PSF;
% S.(psename).Predictor_PSSMTX    = S.(psename).N_PSS_EMG'*  S.(psename).N_PSS_EMG./  S.(psename).nCell_PSS;
% S.(psename).Predictor_SEMTX     = S.(psename).N_SE_EMG'*   S.(psename).N_SE_EMG./   S.(psename).nCell_SE;
% S.(psename).Predictor_SFMTX     = S.(psename).N_SF_EMG'*   S.(psename).N_SF_EMG./   S.(psename).nCell_SF;
% S.(psename).Predictor_SSMTX     = S.(psename).N_SS_EMG'*   S.(psename).N_SS_EMG./   S.(psename).nCell_SS;
% 
% S.(psename).Surprise_AnyMTX     = S.(psename).N_AnyMTX  - S.(psename).Predictor_AnyMTX;
% S.(psename).Surprise_AnyFMTX    = S.(psename).N_AnyFMTX - S.(psename).Predictor_AnyFMTX;
% S.(psename).Surprise_AnySMTX    = S.(psename).N_AnySMTX - S.(psename).Predictor_AnySMTX;
% S.(psename).Surprise_PSEMTX     = S.(psename).N_PSEMTX  - S.(psename).Predictor_PSEMTX;
% S.(psename).Surprise_PSFMTX     = S.(psename).N_PSFMTX  - S.(psename).Predictor_PSFMTX;
% S.(psename).Surprise_PSSMTX     = S.(psename).N_PSSMTX  - S.(psename).Predictor_PSSMTX;
% S.(psename).Surprise_SEMTX      = S.(psename).N_SEMTX   - S.(psename).Predictor_SEMTX;
% S.(psename).Surprise_SFMTX      = S.(psename).N_SFMTX   - S.(psename).Predictor_SFMTX;
% S.(psename).Surprise_SSMTX      = S.(psename).N_SSMTX   - S.(psename).Predictor_SSMTX;


[S.(psename).R_AnyMTX, S.(psename).Rp_AnyMTX]   = corrcoef(double(S.(psename).isAny_all(S.(psename).isAny,:)));
[S.(psename).R_AnyFMTX,S.(psename).Rp_AnyFMTX]  = corrcoef(double(S.(psename).isAnyF_all(S.(psename).isAnyF,:)));
[S.(psename).R_AnySMTX,S.(psename).Rp_AnySMTX]  = corrcoef(double(S.(psename).isAnyS_all(S.(psename).isAnyS,:)));
[S.(psename).R_PSEMTX, S.(psename).Rp_PSEMTX]   = corrcoef(double(S.(psename).isPSE_all(S.(psename).isPSE,:)));
[S.(psename).R_PSFMTX,S.(psename).Rp_PSFMTX]    = corrcoef(double(S.(psename).isPSF_all(S.(psename).isPSF,:)));
[S.(psename).R_PSSMTX,S.(psename).Rp_PSSMTX]    = corrcoef(double(S.(psename).isPSS_all(S.(psename).isPSS,:)));
[S.(psename).R_SEMTX, S.(psename).Rp_SEMTX]     = corrcoef(double(S.(psename).isSE_all(S.(psename).isSE,:)));
[S.(psename).R_SFMTX,S.(psename).Rp_SFMTX]      = corrcoef(double(S.(psename).isSF_all(S.(psename).isSF,:)));
[S.(psename).R_SSMTX,S.(psename).Rp_SSMTX]      = corrcoef(double(S.(psename).isSS_all(S.(psename).isSS,:)));

S.(psename).Rsig_AnyMTX     = S.(psename).Rp_AnyMTX <   0.05;
S.(psename).Rsig_AnyFMTX    = S.(psename).Rp_AnyFMTX <  0.05;
S.(psename).Rsig_AnySMTX    = S.(psename).Rp_AnySMTX <  0.05;
S.(psename).Rsig_PSEMTX     = S.(psename).Rp_PSEMTX <   0.05;
S.(psename).Rsig_PSFMTX     = S.(psename).Rp_PSFMTX <   0.05;
S.(psename).Rsig_PSSMTX     = S.(psename).Rp_PSSMTX <   0.05;
S.(psename).Rsig_SEMTX      = S.(psename).Rp_SEMTX <    0.05;
S.(psename).Rsig_SFMTX      = S.(psename).Rp_SFMTX <    0.05;
S.(psename).Rsig_SSMTX      = S.(psename).Rp_SSMTX <    0.05;


for iEMG=1:nEMG
    for jEMG=1:nEMG
        [temp, S.(psename).C_AnyMTX(iEMG,jEMG), S.(psename).Cp_AnyMTX(iEMG,jEMG)] = crosstab(S.(psename).isAny_all(S.(psename).isAny,iEMG),S.(psename).isAny_all(S.(psename).isAny,jEMG));
        [temp, S.(psename).C_AnyFMTX(iEMG,jEMG), S.(psename).Cp_AnyFMTX(iEMG,jEMG)] = crosstab(S.(psename).isAnyF_all(S.(psename).isAnyF,iEMG),S.(psename).isAnyF_all(S.(psename).isAnyF,jEMG));
        [temp, S.(psename).C_AnySMTX(iEMG,jEMG), S.(psename).Cp_AnySMTX(iEMG,jEMG)] = crosstab(S.(psename).isAnyS_all(S.(psename).isAnyS,iEMG),S.(psename).isAnyS_all(S.(psename).isAnyS,jEMG));

        [temp, S.(psename).C_PSEMTX(iEMG,jEMG), S.(psename).Cp_PSEMTX(iEMG,jEMG)] = crosstab(S.(psename).isPSE_all(S.(psename).isPSE,iEMG),S.(psename).isPSE_all(S.(psename).isPSE,jEMG));
        [temp, S.(psename).C_PSFMTX(iEMG,jEMG), S.(psename).Cp_PSFMTX(iEMG,jEMG)] = crosstab(S.(psename).isPSF_all(S.(psename).isPSF,iEMG),S.(psename).isPSF_all(S.(psename).isPSF,jEMG));
        [temp, S.(psename).C_PSSMTX(iEMG,jEMG), S.(psename).Cp_PSSMTX(iEMG,jEMG)] = crosstab(S.(psename).isPSS_all(S.(psename).isPSS,iEMG),S.(psename).isPSS_all(S.(psename).isPSS,jEMG));

        [temp, S.(psename).C_SEMTX(iEMG,jEMG), S.(psename).Cp_SEMTX(iEMG,jEMG)] = crosstab(S.(psename).isSE_all(S.(psename).isSE,iEMG),S.(psename).isSE_all(S.(psename).isSE,jEMG));
        [temp, S.(psename).C_SFMTX(iEMG,jEMG), S.(psename).Cp_SFMTX(iEMG,jEMG)] = crosstab(S.(psename).isSF_all(S.(psename).isSF,iEMG),S.(psename).isSF_all(S.(psename).isSF,jEMG));
        [temp, S.(psename).C_SSMTX(iEMG,jEMG), S.(psename).Cp_SSMTX(iEMG,jEMG)] = crosstab(S.(psename).isSS_all(S.(psename).isSS,iEMG),S.(psename).isSS_all(S.(psename).isSS,jEMG));

    end
end


S.(psename).Csig_AnyMTX     = S.(psename).Cp_AnyMTX <   0.05;
S.(psename).Csig_AnyFMTX    = S.(psename).Cp_AnyFMTX <  0.05;
S.(psename).Csig_AnySMTX    = S.(psename).Cp_AnySMTX <  0.05;
S.(psename).Csig_PSEMTX     = S.(psename).Cp_PSEMTX <   0.05;
S.(psename).Csig_PSFMTX     = S.(psename).Cp_PSFMTX <   0.05;
S.(psename).Csig_PSSMTX     = S.(psename).Cp_PSSMTX <   0.05;
S.(psename).Csig_SEMTX      = S.(psename).Cp_SEMTX <    0.05;
S.(psename).Csig_SFMTX      = S.(psename).Cp_SFMTX <    0.05;
S.(psename).Csig_SSMTX      = S.(psename).Cp_SSMTX <    0.05;


S.(psename).Group_P_isAnyMTX       = S.(psename).Group_N_isAnyMTX ./    S.(psename).nCell_Any;
S.(psename).Group_P_isAnyFMTX      = S.(psename).Group_N_isAnyFMTX ./   S.(psename).nCell_AnyF;
S.(psename).Group_P_isAnySMTX      = S.(psename).Group_N_isAnySMTX ./   S.(psename).nCell_AnyS;
S.(psename).Group_P_isPSEMTX       = S.(psename).Group_N_isPSEMTX ./    S.(psename).nCell_PSE;
S.(psename).Group_P_isPSFMTX       = S.(psename).Group_N_isPSFMTX ./    S.(psename).nCell_PSF;
S.(psename).Group_P_isPSSMTX       = S.(psename).Group_N_isPSSMTX ./    S.(psename).nCell_PSS;
S.(psename).Group_P_isSEMTX        = S.(psename).Group_N_isSEMTX ./     S.(psename).nCell_SE;
S.(psename).Group_P_isSFMTX        = S.(psename).Group_N_isSFMTX ./     S.(psename).nCell_SF;
S.(psename).Group_P_isSSMTX        = S.(psename).Group_N_isSSMTX ./     S.(psename).nCell_SS;
% S.(psename).SUM_GroupAnyMTX       = squeeze(sum(S.(psename).GroupAnyMTX,3));
% S.(psename).SUM_GroupAnyFMTX      = squeeze(sum(S.(psename).GroupAnyFMTX,3));
% S.(psename).SUM_GroupAnySMTX      = squeeze(sum(S.(psename).GroupAnySMTX,3));
% S.(psename).SUM_GroupPSEMTX       = squeeze(sum(S.(psename).GroupPSEMTX,3));
% S.(psename).SUM_GroupPSFMTX       = squeeze(sum(S.(psename).GroupPSFMTX,3));
% S.(psename).SUM_GroupPSSMTX       = squeeze(sum(S.(psename).GroupPSSMTX,3));
% S.(psename).SUM_GroupSEMTX        = squeeze(sum(S.(psename).GroupSEMTX,3));
% S.(psename).SUM_GroupSFMTX        = squeeze(sum(S.(psename).GroupSFMTX,3));
% S.(psename).SUM_GroupSSMTX        = squeeze(sum(S.(psename).GroupSSMTX,3));
%
% S.(psename).AVE_GroupAnyMTX       = S.(psename).SUM_GroupAnyMTX ./    nfile;
% S.(psename).AVE_GroupAnyFMTX      = S.(psename).SUM_GroupAnyFMTX ./   nfile;
% S.(psename).AVE_GroupAnySMTX      = S.(psename).SUM_GroupAnySMTX ./   nfile;
% S.(psename).AVE_GroupPSEMTX       = S.(psename).SUM_GroupPSEMTX ./    nfile;
% S.(psename).AVE_GroupPSFMTX       = S.(psename).SUM_GroupPSFMTX ./    nfile;
% S.(psename).AVE_GroupPSSMTX       = S.(psename).SUM_GroupPSSMTX ./    nfile;
% S.(psename).AVE_GroupSEMTX        = S.(psename).SUM_GroupSEMTX ./     nfile;
% S.(psename).AVE_GroupSFMTX        = S.(psename).SUM_GroupSFMTX ./     nfile;
% S.(psename).AVE_GroupSSMTX        = S.(psename).SUM_GroupSSMTX ./     nfile;
%
%
% S.(psename).SUM_Group_N_AnyMTX       = squeeze(sum(S.(psename).Group_N_AnyMTX,3));
% S.(psename).SUM_Group_N_AnyFMTX      = squeeze(sum(S.(psename).Group_N_AnyFMTX,3));
% S.(psename).SUM_Group_N_AnySMTX      = squeeze(sum(S.(psename).Group_N_AnySMTX,3));
% S.(psename).SUM_Group_N_PSEMTX       = squeeze(sum(S.(psename).Group_N_PSEMTX,3));
% S.(psename).SUM_Group_N_PSFMTX       = squeeze(sum(S.(psename).Group_N_PSFMTX,3));
% S.(psename).SUM_Group_N_PSSMTX       = squeeze(sum(S.(psename).Group_N_PSSMTX,3));
% S.(psename).SUM_Group_N_SEMTX        = squeeze(sum(S.(psename).Group_N_SEMTX,3));
% S.(psename).SUM_Group_N_SFMTX        = squeeze(sum(S.(psename).Group_N_SFMTX,3));
% S.(psename).SUM_Group_N_SSMTX        = squeeze(sum(S.(psename).Group_N_SSMTX,3));
%
% S.(psename).AVE_Group_N_AnyMTX       = S.(psename).SUM_Group_N_AnyMTX ./    nfile;
% S.(psename).AVE_Group_N_AnyFMTX      = S.(psename).SUM_Group_N_AnyFMTX ./   nfile;
% S.(psename).AVE_Group_N_AnySMTX      = S.(psename).SUM_Group_N_AnySMTX ./   nfile;
% S.(psename).AVE_Group_N_PSEMTX       = S.(psename).SUM_Group_N_PSEMTX ./    nfile;
% S.(psename).AVE_Group_N_PSFMTX       = S.(psename).SUM_Group_N_PSFMTX ./    nfile;
% S.(psename).AVE_Group_N_PSSMTX       = S.(psename).SUM_Group_N_PSSMTX ./    nfile;
% S.(psename).AVE_Group_N_SEMTX        = S.(psename).SUM_Group_N_SEMTX ./     nfile;
% S.(psename).AVE_Group_N_SFMTX        = S.(psename).SUM_Group_N_SFMTX ./     nfile;
% S.(psename).AVE_Group_N_SSMTX        = S.(psename).SUM_Group_N_SSMTX ./     nfile;
%
%
% S.(psename).SUM_Group_P_AnyMTX       = squeeze(sum(S.(psename).Group_P_AnyMTX,3));
% S.(psename).SUM_Group_P_AnyFMTX      =
% squeeze(sum(S.(psename).Group_P_AnyFMTX,3));
% S.(psename).SUM_Group_P_AnySMTX      = squeeze(sum(S.(psename).Group_P_AnySMTX,3));
% S.(psename).SUM_Group_P_PSEMTX       = squeeze(sum(S.(psename).Group_P_PSEMTX,3));
% S.(psename).SUM_Group_P_PSFMTX       = squeeze(sum(S.(psename).Group_P_PSFMTX,3));
% S.(psename).SUM_Group_P_PSSMTX       = squeeze(sum(S.(psename).Group_P_PSSMTX,3));
% S.(psename).SUM_Group_P_SEMTX        = squeeze(sum(S.(psename).Group_P_SEMTX,3));
% S.(psename).SUM_Group_P_SFMTX        = squeeze(sum(S.(psename).Group_P_SFMTX,3));
% S.(psename).SUM_Group_P_SSMTX        = squeeze(sum(S.(psename).Group_P_SSMTX,3));
%
% S.(psename).AVE_Group_P_AnyMTX       = S.(psename).SUM_Group_P_AnyMTX ./    nfile;
% S.(psename).AVE_Group_P_AnyFMTX      = S.(psename).SUM_Group_P_AnyFMTX ./
% nfile;
% S.(psename).AVE_Group_P_AnySMTX      = S.(psename).SUM_Group_P_AnySMTX ./   nfile;
% S.(psename).AVE_Group_P_PSEMTX       = S.(psename).SUM_Group_P_PSEMTX ./    nfile;
% S.(psename).AVE_Group_P_PSFMTX       = S.(psename).SUM_Group_P_PSFMTX ./    nfile;
% S.(psename).AVE_Group_P_PSSMTX       = S.(psename).SUM_Group_P_PSSMTX ./    nfile;
% S.(psename).AVE_Group_P_SEMTX        = S.(psename).SUM_Group_P_SEMTX ./     nfile;
% S.(psename).AVE_Group_P_SFMTX        = S.(psename).SUM_Group_P_SFMTX ./     nfile;
% S.(psename).AVE_Group_P_SSMTX        = S.(psename).SUM_Group_P_SSMTX ./
% nfile;






for iGroup=1:nGroup
    for jGroup=1:nGroup
        if(iGroup==jGroup)

            temp    = S.(psename).N_AnyMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_AnyMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_AnyMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_Any);

            temp    = S.(psename).N_AnyFMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_AnyFMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_AnyFMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) * S.(psename).nCell_AnyF);

            temp    = S.(psename).N_AnySMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_AnySMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_AnySMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) * S.(psename).nCell_AnyS);

            temp    = S.(psename).N_PSEMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_PSEMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_PSEMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSE);

            temp    = S.(psename).N_PSFMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_PSFMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_PSFMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSF);

            temp    = S.(psename).N_PSSMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_PSSMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_PSSMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSS);

            temp    = S.(psename).N_SEMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_SEMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_SEMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SE);

            temp    = S.(psename).N_SFMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_SFMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_SFMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SF);

            temp    = S.(psename).N_SSMTX(EMGind.Group==iGroup,EMGind.Group==iGroup);
            temp(logical(eye(size(temp,1))))   = [];
            S.(psename).Group_N_SSMTX(iGroup,iGroup)   = sum(sum(temp));
            S.(psename).Group_P_SSMTX(iGroup,iGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SS);
        else
            temp    = S.(psename).N_AnyMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_AnyMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_AnyMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_Any);

            temp    = S.(psename).N_AnyFMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_AnyFMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_AnyFMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) * S.(psename).nCell_AnyF);

            temp    = S.(psename).N_AnySMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_AnySMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_AnySMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) * S.(psename).nCell_AnyS);

            temp    = S.(psename).N_PSEMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_PSEMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_PSEMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSE);

            temp    = S.(psename).N_PSFMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_PSFMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_PSFMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSF);

            temp    = S.(psename).N_PSSMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_PSSMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_PSSMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *  S.(psename).nCell_PSS);

            temp    = S.(psename).N_SEMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_SEMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_SEMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SE);

            temp    = S.(psename).N_SFMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_SFMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_SFMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SF);

            temp    = S.(psename).N_SSMTX(EMGind.Group==iGroup,EMGind.Group==jGroup);
            S.(psename).Group_N_SSMTX(iGroup,jGroup)   = sum(sum(temp)) ;
            S.(psename).Group_P_SSMTX(iGroup,jGroup)   = sum(sum(temp)) ./ (numel(temp) *   S.(psename).nCell_SS);
        end
    end
end



% cluster analysis
% muscleごと

fname   = {'isAny_all',...
    'isAnyF_all',...
    'isAnyS_all',...
    'isPSE_all',...
    'isPSF_all',...
    'isPSS_all',...
    'isSE_all',...
    'isSF_all',...
    'isSS_all'};
nfname  = length(fname);

for ifname=1:nfname
    X   = S.(psename).(fname{ifname});
    Y   = zeros(1,nEMG*(nEMG-1)/2);
    kk  = 0;
    for ii =1:nEMG-1
        for jj =ii+1:nEMG
            kk  = kk+1;
            Y(kk)       = (nfile - double(X(:,ii))'*double(X(:,jj))) / nfile;
        end
    end
    S.(psename).(['cluster_',fname{ifname}(1:(end-4))])   = linkage(Y);
end

% groupごと

fname   = {'Group_isAny_all',...
    'Group_isAnyF_all',...
    'Group_isAnyS_all',...
    'Group_isPSE_all',...
    'Group_isPSF_all',...
    'Group_isPSS_all',...
    'Group_isSE_all',...
    'Group_isSF_all',...
    'Group_isSS_all'};
nfname  = length(fname);

for ifname=1:nfname
    X   = S.(psename).(fname{ifname});
    Y   = zeros(1,nGroup*(nGroup-1)/2);
    kk  = 0;
    for ii =1:nGroup-1
        for jj =ii+1:nGroup
            kk  = kk+1;
            Y(kk)       = (nfile - double(X(:,ii))'*double(X(:,jj))) / nfile;
        end
    end
    S.(psename).(['cluster_',fname{ifname}(1:(end-4))])   = linkage(Y);
end



% % k-means
%     warning('off')
% maxctrs    = 10;
% 
% X   = S.(psename).MPI_all;
% % X   = zeromask(X,~isnan(X));
% cidx   = nan(nfile,maxctrs);
% ESS    = zeros(1,maxctrs);
% for nctrs =1:maxctrs
%     disp(nctrs)
%     [cidx(:,nctrs),ctrs]    = kmeans(X, nctrs, 'start','uniform', 'rep',5000, 'disp','off','EmptyAction','drop');
%     
%     for ifile = 1:nfile
%         ESS(nctrs)  = ESS(nctrs) + sum( (X(ifile,:) - ctrs(cidx(ifile,nctrs),:)).^2 );
%     end
% end
% S.(psename).kmeans_cidx = cidx;
% S.(psename).kmeans_ESS  = ESS;

    warning('on')

    


save(Outputfile,'-struct','S');
disp(Outputfile)
indicator(0,0)

