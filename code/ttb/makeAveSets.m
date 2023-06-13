function makeAveSets


xlsfilename    = uigetfullfile('*.xls','Pick a Analysis file and Select 5 colums.');
[temp1,temp2,List] = xlsread(xlsfilename,-1);
if(size(List,2)~=2)
    errordlg({'invalid selection';'select [ExpSetsName, EMGName]'})
    return;
end
nList           = size(List,1);
[Outputfile,Outputpath] = uiputfile(fullfile(datapath,'AveSets','AveSets(conditions).txt'),'出力するファイル名を選んでください。');

fid = fopen(fullfile(Outputpath,Outputfile),'w');
for iList   =1:nList
    str     = sprintf('%s:%s',List{iList,1},List{iList,2});
    fprintf(fid,'%s\n',str);
end
fclose(fid);