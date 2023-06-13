function avecoh_btc

OutputDir   = uigetdir(fullfile(datapath,'AVECOH'),'�܂��A�o�͐�̃t�H���_��I�����Ă��������B');
[fullfilenames,Avefilename,ParentPath]  = loadfullAveSets;

Avefilename = Avefilename(1:end-4); %�g���q�̏���

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

