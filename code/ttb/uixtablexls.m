function [table,XLabel,YLabel,stats]=uixtablexls

% xlsfile = uigetfullfile('*.xls','Experiment Excel�t�@�C����I�����Ă��������B');
% xlsload(xlsfile,'XName','XData','YName','YData');
xlsload(-1,'XName','XData','YName','YData');
if(length(XData)~=length(YData))
    error('X��Y�̃f�[�^������v���Ă��܂���B')
end
if(isnumeric(XData))
    XData   = num2cellstr(XData);
end
if(isnumeric(YData))
    YData   = num2cellstr(YData);
end


XLabel  = sortxls(unique(XData));
YLabel  = sortxls(unique(YData));



tempXLabel  = '{';
for iLabel=1:length(XLabel)
    tempXLabel  = [tempXLabel,' ''',XLabel{iLabel},''''];
end
tempXLabel  = [tempXLabel,' }'];

tempYLabel  = '{';
for iLabel=1:length(YLabel)
    tempYLabel  = [tempYLabel,' ''',YLabel{iLabel},''''];
end
tempYLabel  = [tempYLabel,' }'];


temp    = inputdlg({'XLabel:','YLabel'},'X,Y�̃��x��',1,{tempXLabel,tempYLabel});
XLabel  = eval([temp{1},';']);
YLabel  = eval([temp{2},';']);


S.Name          = ['XTABLE (',XName,', ',YName,')'];
S.AnalysisType  = 'XTABLE';
S.XData         = XData;
S.XName         = XName;
S.YData         = YData;
S.YName         = YName;


% �N���X�W�v�\
[S.Table,S.XLabel,S.YLabel]  = xtable([XData,YData],XLabel,YLabel);

S.N = sum(sum(S.Table));

% �J�C���e�X�g
% ���ӓx�����[���̍s�Ɨ�������ăJ�C��挟����s���B
Table   = S.Table;
sumcol  = sum(Table,1);
sumrow  = sum(Table,2);
Table(:,sumcol<1) =[];
Table(sumrow<1,:) =[];

[S.p,S.chi2,S.df]    = chi2test(Table);


% Cramer's coefficient of association
S.V = sqrt(S.chi2 / (S.N * (min(size(Table))-1)) );


% �o��
outputpath  = getconfig(mfilename,'outputpath');
try
    if(~exist(outputpath,'dir'))
        outputpath  = pwd;
    end
catch
    outputpath  = pwd;
end

[outputfile,outputpath] = uiputfile(fullfile(outputpath,[S.Name,'.mat']),'�t�@�C���̕ۑ�');

if(isequal(outputpath,0))
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'outputpath',outputpath);
end



S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.']) 

table   = S.Table;
stats.p = S.p;
stats.chi2 = S.chi2;
stats.df    = S.df;


