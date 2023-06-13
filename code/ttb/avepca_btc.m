function avepca_btc(Name)

InputDir    = uigetdir(fullfile(datapath,'EMGPCA'),'EMGPCAデータが入っているフォルダを選択してください。');
files       = uiselect(deext(dirmat(InputDir)),1,'平均する対象となるファイルを選択してください');
OutputDir   = InputDir;
Outputfile  = fullfile(OutputDir,['AVEPCA(',Name,').mat']);
nfile       = length(files);
if(exist(Outputfile,'file'))
    S       = load(Outputfile);
end


for ifile=1:nfile
    s   = load(fullfile(InputDir,files{ifile}));
    if(ifile==1)
        S   = s;
        S.EMGName   = s.Name;
        S.Name      = ['AVEPCA(',Name,')'];
        S.AnalysisType  = 'AVEPCA';
        S.fileName  = files;
        S.nfiles    = nfile;
    else
        S.coeff     = cat(3,S.coeff,s.coeff);
        S.latent    = [S.latent,s.latent];
        S.explained = [S.explained,s.explained];
        
            
    end
    S.coeff_sd  = std(S.coeff,1,3);
    S.coeff     = mean(S.coeff,3);
    S.latent_sd  = std(S.latent,1,2);
    S.latent     = mean(S.latent,2);
    S.explained_sd  = std(cumsum(S.explained,1),1,2);
    S.explained     = mean(S.explained,2);

end

save(Outputfile,'-struct','S');
disp(Outputfile)

