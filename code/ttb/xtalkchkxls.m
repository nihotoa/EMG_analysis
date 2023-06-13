function xtalkchkxls

parentdir   = uigetdir(fullfile(datapath,'XTALKCHK'),'親フォルダを選択してください');
files        = uiselect(dirmat(parentdir),[],'対象となるファイルを選択してください');
[p,f]       = fileparts(parentdir);
[outfile,outpath]     = uiputfile(fullfile(parentdir,[f,'.xls']), '保存先のファイルを選択してください');
outfile     = fullfile(outpath,outfile);     
nfile   = length(files);
disp(outfile)
warning('off');
for ifile   =1:nfile
    clear A
    file    = files{ifile};
    S   = load(fullfile(parentdir,file));
    A(:,1)  = S.ChanNames;
    A(:,2)=num2cell(double(S.isxtalkA));
    A(:,3)=num2cell(double(S.isxtalkB));
    xlswrite(outfile,A,file);
    disp(fullfile(parentdir,file));
end
warning('on');    

