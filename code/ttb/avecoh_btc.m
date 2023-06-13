function avecoh_btc

OutputDir   = uigetdir(fullfile(datapath,'AVECOH'),'まず、出力先のフォルダを選択してください。');
[fullfilenames,Avefilename,ParentPath]  = loadfullAveSets;

Avefilename = Avefilename(1:end-4); %拡張子の除去

[ParentPath,ChildPath2,ext] = fileparts(ParentPath);
if(~isempty(ext))
    ChildPath2  = [ChildPath2,ext];
end

[ParentPath,ChildPath1,ext] = fileparts(ParentPath);
if(~isempty(ext))
    ChildPath1  = [ChildPath1,ext];
end

Name    = ['AVE',ChildPath1,' (',Avefilename,',',ChildPath2,')'];

S   = avecoh(fullfilenames,Name);
% disp(num2str(S.Cxy))
% disp(num2str(S.Cyx))

% save

save(fullfile(OutputDir,[Name,'.mat']),'-struct','S');
disp([fullfile(OutputDir,[Name,'.mat']),'was created'])

