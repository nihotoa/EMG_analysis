function mfxls_btc(psename)


% xlsfile = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
% xlsload(xlsfile,'-cell','MDAfile','suffix','EMG','PSEtypes','PPI','MPI','API');
xlsload(-1,'-cell','CellName','EMG','PSEtypes','PPI','MPI','API');

% 
% % uiwait(msgbox('[MDAfile, suffix, EMG]','modal'));
% [temp1,temp2,TarList]  = xlsread(Listfilename,-1,'[MDAfile, suffix, EMG]'); % Unit-EMG pair Name
% 
% % uiwait(msgbox('[PSEtype]','modal'));
% [PSEtypes,temp1,temp2]  = xlsread(Listfilename,-1,'[PSEtype]'); % PSEtype Name
% 
% % uiwait(msgbox('[PPI, MPI, API]','modal'));
% [temp1,temp2,PIs]  = xlsread(Listfilename,-1,'[PPI, MPI, API]'); % PPI MPI API Name

OutputDir   = uigetdir(fullfile(datapath,'MF'),'出力先フォルダを選択してください。');

TarList = cell(size(CellName));
nList   = size(CellName,1);
nEMG    = 0;
% PSEtypes    = cell2mat(PSEtypes);
PPIList = zeros(nList,1);
MPIList = zeros(nList,1);
APIList = zeros(nList,1);



for iList=1:nList
%     if(isempty(suffix))
%         TarList{iList}    = MDAfile{iList};
%     else
%         TarList{iList}    = [MDAfile{iList},num2str(suffix{iList},'%0.2d')];
%     end
    TarList{iList}  = CellName{iList};
    if(strcmp(EMG{iList},EMG{1}) && nEMG==0 && iList~=1)
        nEMG    = iList - 1;
    end
    if(isempty(PPI{iList}) || isnan(PPI{iList}))
        PPIList(iList)      = 0;
    else
        PPIList(iList)      = PPI{iList};
    end
    if(isempty(MPI{iList}) || isnan(MPI{iList}))
        MPIList(iList)      = 0;
    else
        MPIList(iList)      = MPI{iList};
    end
    if(isempty(API{iList}) || isnan(API{iList}))
        APIList(iList)      = 0;
    else
        APIList(iList)      = API{iList};
    end
end

EMGs          = EMG(1:nEMG)';
nDir          = nList ./ nEMG;
EMGind        = EMGprop(EMGs);


isAny         = false(1,nEMG);
isAnyF        = isAny;
isAnyS        = isAny;
isPSE         = isAny;
isPSF         = isAny;  % 1
isPSS         = isAny;  % 2
isSE          = isAny;
isSF          = isAny;  % 3
isSS          = isAny;  % 4
MPIs           = zeros(1,nEMG);
PPIs           = MPIs;
APIs           = MPIs;


for iDir=1:nDir
    ind         = ((iDir-1)*nEMG+1):iDir*nEMG;
    InputDir    = TarList{ind(1)};
    Outputfile  = fullfile(OutputDir,[InputDir,'.mat']);

    try

        if(exist(Outputfile,'file'))
            S   = load(Outputfile);
        else
            S   = [];
        end
        
        PSEtype     = PSEtypes(ind)';
        PSEtype2    = zeros(size(PSEtype));
        PSEtype2(strcmp(PSEtype,'PSF')) = 1;
        PSEtype2(strcmp(PSEtype,'PSS')) = 1;
        PSEtype2(strcmp(PSEtype,'SF'))  = 1;
        PSEtype2(strcmp(PSEtype,'SS'))  = 1;
        
        for iEMG=1:nEMG
            isAny       = ~strcmp(PSEtype,'none');
            isAnyF      = strcmp(PSEtype,'PSF') | strcmp(PSEtype,'SF');
            isAnyS      = strcmp(PSEtype,'PSS') | strcmp(PSEtype,'SS');
            isPSE       = strcmp(PSEtype,'PSF') | strcmp(PSEtype,'PSS');
            isPSF       = strcmp(PSEtype,'PSF');
            isPSS       = strcmp(PSEtype,'PSS');
            isSE        = strcmp(PSEtype,'SF')  | strcmp(PSEtype,'SS');
            isSF        = strcmp(PSEtype,'SF');
            isSS        = strcmp(PSEtype,'SS');

            MPIs        = MPIList(ind)' .* double(isPSE);
            PPIs        = PPIList(ind)' .* double(isPSE);
            APIs        = APIList(ind)' .* double(isPSE);
        end

        S.Name          = InputDir;
        S.AnalysisType  = 'MF';
        S.EMGName       = EMGs;
        S.(psename).PSEtype     =PSEtype;
        S.(psename).PSEtype2     =PSEtype2;
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


        nGroup  = length(unique(EMGind.GroupName));

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
        errormsg    = ['****** Error occured in ',InputDir];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end