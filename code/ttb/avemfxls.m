function avemfxls
% if(nargin<1)
%     mode    = 'binary';
% end
alpha   = 0.05;

xlsload(-1,'Data','XLabel','YLabel','XGroup','-cell');
temp    = Data;
Data    = nan(size(Data));
Data(~cellfun(@isempty,temp))   = [temp{:}];

% switch mode
%     case 'binary'
Value   = unique(Data(~isnan(Data)));
% Value   = uichoice(Value,'TrueValueとして用いる値を選択してください。');
nValue  = length(Value);
temp    = inputdlg(num2cellstr(Value),'Value Assignment',1,num2cellstr(Value));
tempData    = Data;

for iValue  = 1:nValue
    Data(tempData==Value(iValue))   = str2double(temp{iValue});
end

%     case 'parametric'
% %         Data    = Data;
%         temp    = {'parametric'};
% end

[nCell,nEMG]    = size(Data);
% % Data2           = zeromask(Data,~isnan(Data));
% 
% % MFMTX
% mtx     = zeros(nEMG);
% for iCell=1:nCell
%     mtx = mtx + Data2(iCell,:)' * Data2(iCell,:);
% end
% 
% % MFnValidMTX
% nvmtx   = zeros(nEMG);
% for iCell=1:nCell
%     nvmtx = nvmtx + double(~isnan(Data(iCell,:)))' * double(~isnan(Data(iCell,:)));
% end

% MFMTX, MFMTXor, MFnValidMTX, MFMTXx, MFMTXy
mtx     = zeros(nEMG);
mtxor   = zeros(nEMG);
nvmtx   = zeros(nEMG);
mtxx    = zeros(nEMG);
mtxy    = zeros(nEMG);

for ii=1:nEMG
    for jj=1:nEMG
        ind = and(~isnan(Data(:,ii)),~isnan(Data(:,jj)));
        mtx(ii,jj)      = sum(and(Data(ind,ii),Data(ind,jj)));
        mtxor(ii,jj)    = sum( or(Data(ind,ii),Data(ind,jj)));
        nvmtx(ii,jj)    = sum(double(ind));
        mtxx(ii,jj)     = sum(Data(ind,ii));
        mtxy(ii,jj)     = sum(Data(ind,jj));
    end
end

% MFMTXP
mtxp    = mtx ./ nvmtx;

% MFMTXPor
mtxpor  = mtx ./ mtxor;


% MFMTXPredRatio, MFMTXPred, MFMTXSurp
mtxpredratio    = (mtxx .* mtxy) ./ (nvmtx.^2);
mtxpred         = (mtxx .* mtxy) ./ nvmtx;
mtxsurp         = mtx - mtxpred;

% MFMTXPredLL, MFMTXPredUL, MFMTXSurpP, MFMTXSurpH
mtxpredLL       = zeros(nEMG);
mtxpredUL       = zeros(nEMG);
mtxsurpP        = zeros(nEMG);
mtxsurpH        = zeros(nEMG);
mtxsurpLH        = zeros(nEMG);
mtxsurpUH        = zeros(nEMG);
for ii=1:nEMG
    for jj=1:nEMG
        mtxpredLL(ii,jj)= binoinv(alpha,nvmtx(ii,jj),mtxpredratio(ii,jj));
        mtxpredUL(ii,jj)= binoinv(1-alpha,nvmtx(ii,jj),mtxpredratio(ii,jj));
        mtxsurpP(ii,jj) = 1 - binocdf(mtx(ii,jj),nvmtx(ii,jj),mtxpredratio(ii,jj));
        if(mtxsurpP(ii,jj)<alpha)
            if(mtxsurpP(ii,jj)<alpha/2)
                mtxsurpH(ii,jj) = 1;
            end
            mtxsurpUH(ii,jj) = 1;
        elseif(mtxsurpP(ii,jj)>1-alpha)
            if(mtxsurpP(ii,jj)>1-alpha/2)
                mtxsurpH(ii,jj) = 1;
            end
            mtxsurpLH(ii,jj) = 1;
        end
    end
end

% そもそもの期待値が0の物を省く
ind = mtxpredratio > 0;
mtxpredLL   = nanmask(mtxpredLL,ind);
mtxpredUL   = nanmask(mtxpredUL,ind);
mtxsurpP    = onemask(mtxsurpP,ind);
mtxsurpH    = zeromask(mtxsurpH,ind);
mtxsurpUH   = zeromask(mtxsurpUH,ind);
mtxsurpLH   = zeromask(mtxsurpLH,ind);

if(~isempty(XGroup))
    gnames  = cell(size(unique(XGroup)));
    
    ii  =1;
    gnames{1}   = XGroup{1};
    for iEMG=2:nEMG
        if(~strcmp(gnames,XGroup{iEMG}))
            ii  = ii+1;
            gnames{ii}  = XGroup{iEMG};
        end
    end
    nGroup  = length(gnames);
    
    mtx2    = mtx;
    mtx2(logical(leftbottom(nEMG)))     = 0;
    mtx2(logical(eye(nEMG)))            = 0;
    
    nvmtx2  = nvmtx;
    nvmtx2(logical(leftbottom(nEMG)))   = 0;
    nvmtx2(logical(eye(nEMG)))          = 0;
    
    mtxor2  = mtxor;
    mtxor2(logical(leftbottom(nEMG)))   = 0;
    mtxor2(logical(eye(nEMG)))          = 0;
    
    mtxx2   = mtxx;
    mtxx2(logical(leftbottom(nEMG)))   = 0;
    mtxx2(logical(eye(nEMG)))          = 0;
    
    mtxy2   = mtxy;
    mtxy2(logical(leftbottom(nEMG)))   = 0;
    mtxy2(logical(eye(nEMG)))          = 0;
    
    
    mtxpred2= mtxpred;
    mtxpred2(logical(leftbottom(nEMG))) = 0;
    mtxpred2(logical(eye(nEMG)))        = 0;
    
    mtxsurp2= mtxsurp;
    mtxsurp2(logical(leftbottom(nEMG))) = 0;
    mtxsurp2(logical(eye(nEMG)))        = 0;
    
    
    % GMFMTX
    gmtx    = zeros(nGroup);
    gnvmtx  = zeros(nGroup);
    gmtxor  = zeros(nGroup);
    gmtxx   = zeros(nGroup);
    gmtxy   = zeros(nGroup);
    
    for iGroup =1:nGroup
        iind    = strcmp(XGroup,gnames{iGroup});
        for jGroup=1:nGroup
            jind    = strcmp(XGroup,gnames{jGroup});
            if(jGroup>=iGroup)
                gmtx(iGroup,jGroup)     = sum(sum(mtx2(iind,jind)));
                gnvmtx(iGroup,jGroup)   = sum(sum(nvmtx2(iind,jind)));
                gmtxor(iGroup,jGroup)   = sum(sum(mtxor2(iind,jind)));
                gmtxx(iGroup,jGroup)    = sum(sum(mtxx2(iind,jind)));
                gmtxy(iGroup,jGroup)    = sum(sum(mtxy2(iind,jind)));
            else
                gmtx(iGroup,jGroup)     = sum(sum(mtx2(jind,iind)));
                gnvmtx(iGroup,jGroup)   = sum(sum(nvmtx2(jind,iind)));
                gmtxor(iGroup,jGroup)   = sum(sum(mtxor2(jind,iind)));
                gmtxx(iGroup,jGroup)    = sum(sum(mtxx2(jind,iind)));
                gmtxy(iGroup,jGroup)    = sum(sum(mtxy2(jind,iind)));
            end
        end
    end
    
    %GMFMTXP
    gmtxp   = gmtx ./ gnvmtx;
    
    %GMFMTXPor
    gmtxpor = gmtx ./ gmtxor;
    
    
    % GMFMTXPredRatio, GMFMTXPred, GMFMTXSurp
    gmtxpredratio    = (gmtxx .* gmtxy) ./ (gnvmtx.^2);
    gmtxpred         = (gmtxx .* gmtxy) ./ gnvmtx;
    gmtxsurp         = gmtx - gmtxpred;
    
    % GMFMTXPredLL, GMFMTXPredUL, GMFMTXSurpP, GMFMTXSurpH
    gmtxpredLL       = zeros(nGroup);
    gmtxpredUL       = zeros(nGroup);
    gmtxsurpP        = zeros(nGroup);
    gmtxsurpH        = zeros(nGroup);
    gmtxsurpLH       = zeros(nGroup);
    gmtxsurpUH       = zeros(nGroup);
    
    for ii=1:nGroup
        for jj=1:nGroup
            gmtxpredLL(ii,jj)= binoinv(alpha,gnvmtx(ii,jj),gmtxpredratio(ii,jj));
            gmtxpredUL(ii,jj)= binoinv(1-alpha,gnvmtx(ii,jj),gmtxpredratio(ii,jj));
            gmtxsurpP(ii,jj) = 1 - binocdf(gmtx(ii,jj),gnvmtx(ii,jj),gmtxpredratio(ii,jj));
            if(gmtxsurpP(ii,jj)<alpha)
                if(gmtxsurpP(ii,jj)<alpha/2)
                    gmtxsurpH(ii,jj) = 1;
                end
                gmtxsurpUH(ii,jj) = 1;
            elseif(mtxsurpP(ii,jj)>1-alpha)
                if(gmtxsurpP(ii,jj)>1-alpha/2)
                    gmtxsurpH(ii,jj) = 1;
                end
                gmtxsurpLH(ii,jj) = 1;
            end
        end
    end
    
    % そもそもの期待値が0の物を省く
    ind = gmtxpredratio > 0;
    gmtxpredLL   = nanmask(gmtxpredLL,ind);
    gmtxpredUL   = nanmask(gmtxpredUL,ind);
    gmtxsurpP    = onemask(gmtxsurpP,ind);
    gmtxsurpH    = zeromask(gmtxsurpH,ind);
    gmtxsurpLH   = zeromask(gmtxsurpLH,ind);
    gmtxsurpUH   = zeromask(gmtxsurpUH,ind);

    
%     % GMFnValidMTX
%     gnvmtx  = zeros(nGroup);
%     for iGroup =1:nGroup
%         iind    = strcmp(XGroup,gnames{iGroup});
%         for jGroup=1:nGroup
%             jind    = strcmp(XGroup,gnames{jGroup});
%             if(jGroup>=iGroup)
%                 gnvmtx(iGroup,jGroup) = sum(sum(nvmtx2(iind,jind)));
%             else
%                 gnvmtx(iGroup,jGroup) = sum(sum(nvmtx2(jind,iind)));
%             end
%         end
%     end
%     
%     % GMFMTXor
%     gmtxor  = zeros(nGroup);
%     for iGroup =1:nGroup
%         iind    = strcmp(XGroup,gnames{iGroup});
%         for jGroup=1:nGroup
%             jind    = strcmp(XGroup,gnames{jGroup});
%             if(jGroup>=iGroup)
%                 gmtxor(iGroup,jGroup) = sum(sum(mtxor2(iind,jind)));
%             else
%                 gmtxor(iGroup,jGroup) = sum(sum(mtxor2(jind,iind)));
%             end
%         end
%     end
%     
%     %GMFMTXP
%     gmtxp   = gmtx ./ gnvmtx;
%     
%     %GMFMTXPor
%     gmtxpor = gmtx ./ gmtxor;
%     
%     % GMFMTXPred
%     gmtxpred = zeros(nGroup);
%     for iGroup =1:nGroup
%         iind    = strcmp(XGroup,gnames{iGroup});
%         for jGroup=1:nGroup
%             jind    = strcmp(XGroup,gnames{jGroup});
%             if(jGroup>=iGroup)
%                 gmtxpred(iGroup,jGroup) = sum(sum(mtxpred2(iind,jind)));
%             else
%                 gmtxpred(iGroup,jGroup) = sum(sum(mtxpred2(jind,iind)));
%             end
%         end
%     end
%     
%     % GMFMTXSurp
%     gmtxsurp = zeros(nGroup);
%     for iGroup =1:nGroup
%         iind    = strcmp(XGroup,gnames{iGroup});
%         for jGroup=1:nGroup
%             jind    = strcmp(XGroup,gnames{jGroup});
%             if(jGroup>=iGroup)
%                 gmtxsurp(iGroup,jGroup) = sum(sum(mtxsurp2(iind,jind)));
%             else
%                 gmtxsurp(iGroup,jGroup) = sum(sum(mtxsurp2(jind,iind)));
%             end
%         end
%     end
%     
% %     % diag
% %     gd       = diag(gmtx);
end


S.Name      = 'AVEMF';
S.AnalysisType  = 'AVEMF';
S.alpha     = alpha;
S.CellName  = YLabel;
S.EMGName   = XLabel;
S.nCell     = nCell;
S.nEMG      = nEMG; % S.diag      = d;
S.MF        = Data;
S.MFnValidMTX   = nvmtx;
S.MFMTXx    = mtxx;
S.MFMTXy    = mtxy;
S.MFMTX     = mtx;
S.MFMTXor   = mtxor;
S.MFMTXP    = mtxp;
S.MFMTXPor  = mtxpor;
S.MFMTXPredRatio    = mtxpredratio;
S.MFMTXPred = mtxpred;
S.MFMTXSurp = mtxsurp;
S.MFMTXPredLL   = mtxpredLL;
S.MFMTXPredUL   = mtxpredUL;
S.MFMTXSurpP    = mtxsurpP;
S.MFMTXSurpH    = mtxsurpH;
S.MFMTXSurpLH   = mtxsurpLH;
S.MFMTXSurpUH   = mtxsurpUH;

if(~isempty(XGroup))
    S.GroupName = gnames;
    S.nGroup    = nGroup;      % S.Groupdiag = gd;
    S.GroupMFnValidMTX   = gnvmtx;
    S.GroupMFMTXx   = gmtxx;
    S.GroupMFMTXy   = gmtxy;
    S.GroupMFMTX    = gmtx;    % S.GroupMFMTXexc = gmtxexc;
    S.GroupMFMTXor  = gmtxor;
    S.GroupMFMTXP   = gmtxp;    % S.GroupMFMTXexcP= gmtxexcp;
    S.GroupMFMTXPor = gmtxpor;
    S.GroupMFMTXPredRatio = gmtxpredratio;
    S.GroupMFMTXPred = gmtxpred;
    S.GroupMFMTXSurp = gmtxsurp;
    S.GroupMFMTXPredLL   = gmtxpredLL;
    S.GroupMFMTXPredUL   = gmtxpredUL;
    S.GroupMFMTXSurpP    = gmtxsurpP;
    S.GroupMFMTXSurpH    = gmtxsurpH;
    S.GroupMFMTXSurpLH   = gmtxsurpLH;
    S.GroupMFMTXSurpUH   = gmtxsurpUH;

end

% 出力
S.Name          = ['AVEMF (',[temp{:}],...
    'n=[',num2str(size(S.MF,1)),',',num2str(size(S.MF,2)),']).mat'];
[outputfile,outputpath] = uiputfile(fullfile(datapath,'AVEMF',S.Name),'ファイルの保存');

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.'])




%
%     % GData
%     nGroup  = length(gnames);
%     GData   = nan(nCell,nGroup);
%     for iCell=1:nCell
%         for iGroup=1:nGroup
%             ind = strcmp(XGroup,gnames{iGroup});
%             GData(iCell,iGroup) = sum(Data2(iCell,ind));
%         end
%     end
%     LGData  = double(logical(GData));
%
%     % GMFMTX
%     gmtx     = zeros(nGroup);
%     for iCell=1:nCell
%         gmtx = gmtx + LGData(iCell,:)' * LGData(iCell,:);
%     end
%
%     % GMFMTXexc
%     gmtxexc = gmtx;
%     gmtxexc(logical(eye(nGroup)))    = sum(GData>1);
%
% %     % GMFnValidMTX
% %     gmtx     = zeros(nGroup);
%
%
%
%     % Gdiag
%     gd       = diag(gmtx);
%     gdmtx    = repmat(gd,1,nGroup);
%
%     % GMFMTXP
%     gmtxp   = gmtx ./ gdmtx;
%     gmtxexcp= gmtxexc ./ gdmtx;
%
%     % GMFMTXPor
%     gmtxor  = zeros(nGroup);
%     for ii=1:nGroup
%         for jj=1:nGroup
%             gmtxor(ii,jj)   = sum(or(GData(:,ii),GData(:,jj)));
%         end
%     end
%
%
%     % GMFMTXPor
%     gmtxpor  = zeros(nGroup);
%     for ii=1:nGroup
%         for jj=1:nGroup
%             gmtxpor(ii,jj)   = sum(and(GData(:,ii),GData(:,jj))) ./ sum(or(GData(:,ii),GData(:,jj)));
%         end
%     end
%
%     % MFMTXPred, MFMTXSurp
%     gmtxpred = (gdmtx .* gdmtx') ./ nCell;
%     gmtxsurp = gmtx - gmtxpred;
% end
