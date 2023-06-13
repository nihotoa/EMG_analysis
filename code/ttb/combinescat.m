function combinescat(XName,XW,XPreProcess,YName,YW,YPreProcess)

% combinescat(XName,XW,XPreProcess,YName,YW,YPreProcess)
%
% combinescat('TargetEMG(MPI-WS)',MPIs,'zscore',[],ones(size(MPIs))/length(MPIs),[])


% STA file�̌���
% ������STAfile���������܂��B
% ��������P�ʂƂ��āA���ꂼ��̃t�@�C���ŕ��ς������̂�
% ����ɕ��ς�����@�imethod1='file'�j�ƁA�S�Ẵt�@�C���Ɋ܂܂��tirial��
% �܂Ƃ߂ĕ��ς�����@(method2='trial')���I�ׂ܂��B
% �܂��A���ς���̂łȂ����v�������ꍇ��method2��'sum'�Ɠ��͂��Ă��������B
% 
% ����STA file�ɂ�����TrialsToUse��applyTrialsToUse(loaddata���ɍs��)�ɂ����
% �f�[�^�ɔ��f���ꂽ���ʍ폜����܂��B
% 
% ����
%   method1 'trial' or 'file'
%   method2 'average' or 'sum'
% 
% ��P�@������STA�t�@�C����Trial���܂Ƃ߂ĕ��ς������ꍇ
% combinesta('trial','average');
% �𑖂点��ƃG�N�X�v���[���������̂ŁA���ς������t�@�C����I�����A
% �E��box�Ɉړ����Ă��������B
% ���ׂđI���OK�������ƁA�������ɉ��Z���ς��J�n���܂��B
% 
% ���Z���ς��I������ƁA�o�̓t�H���_�Əo�̓t�@�C���𕷂����̂ŁA
% �㏑���ɒ��ӂ��ĕۑ����Ă��������B
% 
% ���ʂ́ADisplayData�Ŋm�F���邱�Ƃ��ł��܂��B
% 
% ��Q�@�eSTA�̕��ς����g�`���A����ɕ��ς������ꍇ
% combinesta('file','average');
% �𑖂点�āA���Ƃ͏�L�ƈꏏ�ł��B
% 
% 
% see also, sta, sta_btc, displaydata
%
% Written by Takei 2010/09/29

pathname    = getconfig(mfilename,'pathname');
try
    if(~exist(pathname,'dir')) 
        pathname            = pwd;
    end
catch
    pathname            = pwd;
end


fullfilenames   = matexplorer(pathname);

if(isempty(fullfilenames))
    disp('User pressed cancel')
    return;
end

nfiles  = length(fullfilenames);


for ifile=1:nfiles
    fullfilename    = fullfilenames{ifile};
    S               = load(fullfilename);
    
    if(ifile==1)
        XData       = zeros(size(S.XData));
        YData       = zeros(size(S.YData));
        
        if(isempty(XName))
            XName   = S.XName;
        end
        if(isempty(YName))
            YName   = S.YName;
        end
    end
    
    if(~isempty(XPreProcess))
        switch lower(XPreProcess)
            case 'zscore'
                XData = XData + zscore(S.XData).*XW(ifile);
            otherwise
                XData = XData + S.XData.*XW(ifile);
        end
    else
        XData = XData + S.XData.*XW(ifile);
    end
    
    if(~isempty(YPreProcess))
        switch lower(YPreProcess)
            case 'zscore'
                YData = YData + zscore(S.YData).*YW(ifile);
            otherwise
                YData = YData + S.YData.*YW(ifile);
        end
    else
        YData = YData + S.YData.*YW(ifile);
    end
end

S   = [];
method          = 'combinescat';
S.Name          = ['SCAT (',XName,', ',YName,',[',method,'])'];
S.AnalysisType  = 'SCAT';
S.method        = method;
S.XW            = XW;
S.YW            = YW;
S.XPreProcess   = XPreProcess;
S.YPreProcess   = YPreProcess;
S.ReferenceName = fullfilenames;
S.TargetName    = [];
S.XData         = XData;
S.XName         = XName;
S.YData         = YData;
S.YName         = YName;
S.N             = size(XData,1);
S.Xmean         = mean(XData);
S.Xstd          = std(XData);
S.Xmedian       = median(XData);
S.Ymean         = mean(YData);
S.Ystd          = std(YData);
S.Ymedian       = median(YData);




% ���֌W��
if(S.N<2)
    S.Pearson.R = 0;
    S.Pearson.P = 1;
    S.Spearman.R    = 0;
    S.Spearman.P    = 1;
    % ���`��A
    S.a   = nan(1,2);
    S.ahelp = '��A�����FY=a(1)*X+a(2)';
else
    [S.Pearson.R,S.Pearson.P]   = corr(S.XData,S.YData,'type','Pearson');
    [S.Spearman.R,S.Spearman.P]   = corr(S.XData,S.YData,'type','Spearman');
    % ���`��A
    S.a   = polyfit(XData,YData,1);
    S.ahelp = '��A�����FY=a(1)*X+a(2)';
end


% Output
pathname    = fileparts(fullfilenames{1});
filename    = S.Name;
pause(0.5)

[filename,pathname] = uiputfile(fullfile(pathname,[filename,'.mat']));
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    setconfig(mfilename,'pathname',pathname)
end


S.Name      = deext(filename);

save(fullfile(pathname,filename),'-struct','S');
disp(fullfile(pathname,filename))
