function uicoincidencexls(n_obs_th,n_par_th)
% uilinkagexls(n_obs_th,n_par_th)
%         n_obs_th;    % ��@muscle field ������ȏ��cell���g��
%         n_par_th;    % ��@����ȏ��cell����A�E�g�v�b�geffect���󂯂�muscle���g���B
% ex. uilinkagexls(1,1)

if(nargin<1)
    n_obs_th    = 0;
    n_par_th    = 0;
elseif(nargin<2)
    n_par_th    = 0;
end

xlsload(-1,'Label','Data');
        Value   = unique(Data);
        % Value   = uichoice(Value,'TrueValue�Ƃ��ėp����l��I�����Ă��������B');
        nValue  = length(Value);
        temp    = inputdlg(num2cellstr(Value),'Value Assignment',1,num2cellstr(Value));
        tempData    = Data;
        
        for iValue  = 1:nValue
            Data(tempData==Value(iValue))   = str2double(temp{iValue});
        end


S.Name          = 'COINCIDENCE';
S.AnalysisType  = 'COINCIDENCE';
S.Data          = Data;
S.Label         = Label;
S.n_obs_th      = n_obs_th;    % ��@muscle field ������ȏ��cell���g��
S.n_par_th      = n_par_th;    % ��@����ȏ��cell����A�E�g�v�b�geffect���󂯂�muscle���g���B

sigobs          = sum(double(Data~=0),2)>=S.n_obs_th;
Data            = Data(sigobs,:);
sigpar          = sum(double(Data~=0),1)>=S.n_par_th;

S.Data2         = Data(:,sigpar);
S.Label2        = S.Label(sigpar);

[S.p,S.n,S.n_pred,S.n_surp] = coincidence(S.Data2);

% �o��
S.Name          = ['COINCIDENCE (',...
    'th=[',num2str(n_obs_th),',',num2str(n_par_th),'],'...
    'n=[',num2str(size(S.Data2,1)),',',num2str(size(S.Data2,2)),']).mat'];
[outputfile,outputpath] = uiputfile(fullfile(datapath,'COINCIDENCE',S.Name),'�t�@�C���̕ۑ�');

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.'])



function [p,n,n_pred,n_surp] = coincidence(X)
% p:    X(ii)��1�ł���ꍇ�ɁAX(jj)��1�ł���m��
% n:    X(ii)&&X(jj)�ł���x��


[nn,NN] = size(X);
p   = nan(NN);
n   = nan(NN);
n_pred  = nan(NN);
n_surp  = nan(NN);

for ii=1:NN
    for jj  = 1:NN
        n(ii,jj)  = (X(:,ii)'* X(:,jj));
        p(ii,jj)  = n(ii,jj) / sum(X(:,ii));
        n_pred(ii,jj)   = sum(X(:,ii)) * sum(X(:,jj)) / nn;
        n_surp(ii,jj)   = n(ii,jj)-n_pred(ii,jj);
    end
end
