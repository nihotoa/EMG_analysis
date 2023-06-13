function xtalkchkxls

parentdir   = uigetdir(fullfile(datapath,'XTALKCHK'),'�e�t�H���_��I�����Ă�������');
files        = uiselect(dirmat(parentdir),[],'�ΏۂƂȂ�t�@�C����I�����Ă�������');
[p,f]       = fileparts(parentdir);
[outfile,outpath]     = uiputfile(fullfile(parentdir,[f,'.xls']), '�ۑ���̃t�@�C����I�����Ă�������');
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

