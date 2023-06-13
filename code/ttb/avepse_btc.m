function avepse_btc(Name,psename,EMGind)

OutputDir   = uigetdir(fullfile(datapath,'AVEPSE'),'出力フォルダを選択してください。');



OutputFile  = fullfile(OutputDir,['AVEPSE(',Name,')']);
if(exist(OutputFile,'file'))
    S   = load(OutputFile);
    if(isfield(S,'psename'))
        S   = rmfield(S,'psename');
    end
end

S.(psename).Name      = ['AVEPSE(',Name,')'];
S.(psename).AnalysisType  = 'AVEPSE';


[y,nDir,nFile]  = getprop(['double(S.',psename,'.isXtalk)'],...                 %2
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).onset*1000'],...       %3
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).offset*1000'],...      %4
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).duration*1000'],...    %5
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).peaktime*1000'],...    %6
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).peak'],...             %7
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).mean'],...             %8
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).peakd'],...            %9
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).meand'],...            %10
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).PPI'],...              %11
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).MPI'],...              %12
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).API'],...              %13
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).PWHM_onset*1000'],...  %14
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).PWHM_offset*1000'],... %15
    ['S.',psename,'.peaks(S.',psename,'.maxsigpeakindTW).PWHM_duration*1000']); %16

[nrow,ncol] = size(y);

for irow =1:nrow
    for icol =2:ncol
        if(isempty(y{irow,icol}))
            y{irow,icol}   = NaN;
        end
    end
end


FileNames       = reshape(y(:,1),nFile,nDir)';
S.(psename).CellNames        = cell(nDir,1);
S.(psename).EMGNames        = cell(1,nFile);
for iDir =1:nDir
    [temp,S.(psename).CellNames{iDir}]   = fileparts(FileNames{iDir,1});
end
for iFile =1:nFile
    [temp,S.(psename).EMGNames{iFile}] = fileparts(FileNames{1,iFile});
    S.(psename).EMGNames{iFile}             = parseEMG(S.(psename).EMGNames{iFile});
end



S.(psename).onset         = reshape([y{:,3}],nFile,nDir)';
S.(psename).onset_est     = zeros(size(S.(psename).onset));
S.(psename).offset        = reshape([y{:,4}],nFile,nDir)';
S.(psename).duration      = reshape([y{:,5}],nFile,nDir)';
S.(psename).peaktime      = reshape([y{:,6}],nFile,nDir)';
S.(psename).peak          = reshape([y{:,7}],nFile,nDir)';
S.(psename).mean          = reshape([y{:,8}],nFile,nDir)';
S.(psename).peakd         = reshape([y{:,9}],nFile,nDir)';
S.(psename).meand         = reshape([y{:,10}],nFile,nDir)';
S.(psename).PPI           = reshape([y{:,11}],nFile,nDir)';
S.(psename).MPI           = reshape([y{:,12}],nFile,nDir)';
S.(psename).API           = reshape([y{:,13}],nFile,nDir)';
S.(psename).PWHM_onset    = reshape([y{:,14}],nFile,nDir)';
S.(psename).PWHM_offset   = reshape([y{:,15}],nFile,nDir)';
S.(psename).PWHM_duration = reshape([y{:,16}],nFile,nDir)';

S.(psename).isXtalk       = logical(reshape([y{:,2}],nFile,nDir)');


CRonsets    = EMGind.onset*1000;
CRPWHM      = EMGind.pwhm*1000;


S.(psename).isAny   = false(nDir,nFile);
S.(psename).isAnyF  = S.(psename).isAny;
S.(psename).isAnyS  = S.(psename).isAny;
S.(psename).isPSE   = S.(psename).isAny;
S.(psename).isPSF   = S.(psename).isAny;
S.(psename).isPSS   = S.(psename).isAny;
S.(psename).isSE    = S.(psename).isAny;
S.(psename).isSF    = S.(psename).isAny;
S.(psename).isSS    = S.(psename).isAny;

for iDir =1:nDir
    for iFile   = 1:nFile
        EMG = S.(psename).EMGNames{iFile};
        CRonset = CRonsets(EMGind.Type(strmatch(parseEMG(EMG),EMGind.Name)));

        onset       = S.(psename).onset(iDir,iFile);
        MPI         = S.(psename).MPI(iDir,iFile);
        PWHM        = S.(psename).PWHM_duration(iDir,iFile);
        
        S.(psename).onset_est(iDir,iFile)   = onset - CRonset;
        if(~isnan(onset))
            S.(psename).isAny(iDir,iFile)   = true;
        else
            S.(psename).isAny(iDir,iFile)   = false;
        end
        if(~isnan(onset) && MPI > 0)
            S.(psename).isAnyF(iDir,iFile)   = true;
        else
            S.(psename).isAnyF(iDir,iFile)   = false;
        end
        if(~isnan(onset) && MPI < 0)
            S.(psename).isAnyS(iDir,iFile)   = true;
        else
            S.(psename).isAnyS(iDir,iFile)   = false;
        end

        if(isnan(onset))
            S.(psename).isPSE(iDir,iFile)   = false;
            S.(psename).isSE(iDir,iFile)    = false;
        elseif(onset >= CRonset && PWHM < CRPWHM)
            S.(psename).isPSE(iDir,iFile)   = true;
            S.(psename).isSE(iDir,iFile)    = false;
        elseif(onset < CRonset || PWHM >= CRPWHM)
            S.(psename).isPSE(iDir,iFile)   = false;
            S.(psename).isSE(iDir,iFile)    = true;
        end

        if(isnan(onset))
            S.(psename).isPSF(iDir,iFile)   = false;
            S.(psename).isSF(iDir,iFile)    = false;
        elseif(onset >= CRonset && PWHM < CRPWHM && MPI > 0)
            S.(psename).isPSF(iDir,iFile)   = true;
            S.(psename).isSF(iDir,iFile)    = false;
        elseif((onset < CRonset || PWHM >= CRPWHM) && MPI > 0)
            S.(psename).isPSF(iDir,iFile)   = false;
            S.(psename).isSF(iDir,iFile)    = true;
        end
        
        if(isnan(onset))
            S.(psename).isPSS(iDir,iFile)   = false;
            S.(psename).isSS(iDir,iFile)    = false;
        elseif(onset >= CRonset && PWHM < CRPWHM && MPI < 0)
            S.(psename).isPSS(iDir,iFile)   = true;
            S.(psename).isSS(iDir,iFile)    = false;
        elseif((onset < CRonset || PWHM >= CRPWHM) && MPI < 0)
            S.(psename).isPSS(iDir,iFile)   = false;
            S.(psename).isSS(iDir,iFile)    = true;
        end

    end

end

S.(psename).nCell       = nDir;
S.(psename).nCell_Any   = sum(any(S.(psename).isAny,2));
S.(psename).nCell_AnyF   = sum(any(S.(psename).isAnyF,2));
S.(psename).nCell_AnyS   = sum(any(S.(psename).isAnyS,2));
S.(psename).nCell_PSE   = sum(any(S.(psename).isPSE,2));
S.(psename).nCell_PSF   = sum(any(S.(psename).isPSF,2));
S.(psename).nCell_PSS   = sum(any(S.(psename).isPSS,2));
S.(psename).nCell_SE   = sum(any(S.(psename).isSE,2));
S.(psename).nCell_SF   = sum(any(S.(psename).isSF,2));
S.(psename).nCell_SS   = sum(any(S.(psename).isSS,2));


save(OutputFile,'-struct','S')