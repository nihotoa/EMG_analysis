function uilinkagexls(n_obs_th,n_par_th,mode,pdist_method,linkage_method)
% uilinkagexls(n_obs_th,n_par_th,mode)
%         n_obs_th;    % ��@muscle field ������ȏ��cell���g��
%         n_par_th;    % ��@����ȏ��cell����A�E�g�v�b�geffect���󂯂�muscle���g���B
% ex. uilinkagexls(1,1)

% xlsfile = uigetfullfile('*.xls','Experiment Excel�t�@�C����I�����Ă��������B');
% xlsload(xlsfile,'XName','XData','YName','YData');
if(nargin<1)
    n_obs_th    = 0;
    n_par_th    = 0;
    mode        = 'nonparametric';
    pdist_method    = 'cosine';
    linkage_method  = 'average';
elseif(nargin<2)
    n_par_th    = 0;
    mode        = 'nonparametric';
    pdist_method    = 'cosine';
    linkage_method  = 'average';
elseif(nargin<3)
    mode        = 'nonparametric';
    pdist_method    = 'cosine';
    linkage_method  = 'average';
elseif(nargin<4)
    pdist_method    = 'cosine';
    linkage_method  = 'average';
elseif(nargin<5)
    linkage_method  = 'average';
end

xlsload(-1,'Label','Data');
switch mode
    case 'nonparametric'
        Value   = unique(Data);
        % Value   = uichoice(Value,'TrueValue�Ƃ��ėp����l��I�����Ă��������B');
        nValue  = length(Value);
        temp    = inputdlg(num2cellstr(Value),'Value Assignment',1,num2cellstr(Value));
        tempData    = Data;
        
        for iValue  = 1:nValue
            Data(tempData==Value(iValue))   = str2double(temp{iValue});
        end

    case 'parametric'
%         Data    = Data;
        temp    = {'parametric'};
end


S.Name          = 'LINKAGE';
S.AnalysisType  = 'LINKAGE';
S.Data          = Data;
S.Label         = Label;
S.n_obs_th      = n_obs_th;    % ��@muscle field ������ȏ��cell���g��
S.n_par_th      = n_par_th;    % ��@����ȏ��cell����A�E�g�v�b�geffect���󂯂�muscle���g���B

sigobs          = sum(double(Data~=0),2)>=S.n_obs_th;
Data            = Data(sigobs,:);
sigpar          = sum(double(Data~=0),1)>=S.n_par_th;

S.Data2         = Data(:,sigpar);
S.Label2        = S.Label(sigpar);

S.pdist_method  = pdist_method;% 'correlation' 'cosine' 'euclidean'
S.linkage_method    = linkage_method;

switch pdist_method
    case 'andor'
        S.pdist = andor(S.Data2');
    otherwise
        S.pdist = pdist(S.Data2',S.pdist_method);
end
keyboard

S.linkage       = linkage(S.pdist,S.linkage_method);
% dendrogram(S.linkage,'Labels',S.Label2)
% �o��
S.Name          = ['LINKAGE (',[temp{:}],...
    ',[',S.pdist_method,',',S.linkage_method,'],',...
    'th=[',num2str(n_obs_th),',',num2str(n_par_th),'],'...
    'n=[',num2str(size(S.Data2,1)),',',num2str(size(S.Data2,2)),']).mat'];
[outputfile,outputpath] = uiputfile(fullfile(datapath,'LINKAGE',S.Name),'�t�@�C���̕ۑ�');

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.'])
end

function Y  = andor(X)
nn  = size(X,1);
Y   = zeros(1,nn*(nn-1)./2);
keyboard
kk  = 0;
for ii=1:nn
    for jj=(ii+1):nn
        kk  = kk+1;
        Y(kk)   = sum(and(X(ii,:),X(jj,:))) ./ sum(or(X(ii,:),X(jj,:)));
    end
end

Y   = 1-Y;
end


% function Y = coincidence(X)
% % A��1�ł���ώ@��B�ł�1�ł���m��
% 
% [nn,NN] = size(X);
% Y   = zeros(1,nn);
% kk  = 0;
% for ii=1:nn
%     for jj  = ii+1:nn
%         kk  = kk + 1;
% %         Y(kk)    = 1 - (X(ii,:)* X(jj,:)') / NN;
%         Y(kk)    = NN - (X(ii,:)* X(jj,:)');
%         
%         Y(kk)    = NN - (X(ii,:)* X(jj,:)');
%     end
% end
% end