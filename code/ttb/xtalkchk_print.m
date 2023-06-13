function [matrix,row,matrixlabel]  = xtalkchk

summaryfig_flag     = 0;
eachfig_flag        = 0;
xlswrite_flag       = 1;

xlsfile             = 'Eito_matrix.xls';

% EMGname         = {'FDI','ADP','3DI','2DI','AbPB','BRD','ED23','ECR','EDC','ECU','AbPL','4DI','AbDM','FCR','FDS','FDPr','FDPu','FCU','PL','Biceps','Triceps'};
% EMGname         = {'FDI','2DI','3DI','4DI','ADP','AbPB','AbDM','FDS','FDPr','FDPu','PL','FCR','FCU','AbPL','ED23','EDC','ECR','ECU','BRD','Biceps','Triceps'};
% EMGname         = {'FDI-highpass','2DI-highpass','3DI-highpass','4DI-highpass','ADP-highpass','AbPB-highpass','AbDM-highpass','FDS-highpass','FDPr-highpass','FDPu-highpass','PL-highpass','FCR-highpass','FCU-highpass','AbPL-highpass','ED23-highpass','EDC-highpass','ECR-highpass','ECU-highpass','BRD-highpass','Biceps-highpass','Triceps-highpass'};
% EMGname         = {'2DI-highpass','3DI-highpass','4DI-highpass','ADP-highpass','AbDM-highpass','AbPB-highpass','AbPL-highpass','BRD-highpass','Biceps-highpass','ECR-highpass','ECU-highpass','ED23-highpass','EDC-highpass','FCR-highpass','FCU-highpass','FDI-highpass','FDPr-highpass','FDPu-highpass','FDS-highpass','PL-highpass','Triceps-highpass'};
EMGname         = {'2DI','3DI','4DI','ADP','AbDM','AbPB','AbPL','BRD','Biceps','ECR','ECU','ED23','EDC','FCR','FCU','FDI','FDPr','FDPu','FDS','PL','Triceps'};

matrixlabel     = EMGname;

filename        = uigetfullfile('*.xls','Pick a exel file.');
pathname        = fileparts(filename);
% ind             = strfind(filename,'\');
% nind    = length(ind);

% for ii  =nind:-1:1
%     filename    = [filename(1:ind(ii)),'\',filename(ind(ii)+1:end)];
% end
% keyboard
[temp1,temp2,x] = xlsread(filename,-1);

clear temp1 temp2

ExpName = [x(:,4);x(:,4)];
Chan1   = [x(:,5);x(:,6)];
Chan2   = [x(:,6);x(:,5)];
r       = [x(:,8);x(:,8)];
absrmax = [x(:,10);x(:,10)];
Option  = [x(:,7);x(:,7)];
EXPname = sort(unique(ExpName));

% EXPname = {'EitoT001';'EitoT002';'EitoT003';'EitoT004';'EitoT005';'EitoT006';'EitoT007';'EitoT008';'EitoT009';'EitoT010';...
%     ;'EitoT011';'EitoT012';'EitoT013';'EitoT014';'EitoT015';'EitoT016';'EitoT017';'EitoT018';'EitoT019';'EitoT020';...
%     ;'EitoT021';...'EitoT022';'EitoT023';'EitoT024';'EitoT025';'EitoT026';'EitoT027';...
%     ;'EitoC001';'EitoC002';'EitoC003';'EitoC004';'EitoC005';'EitoC006';'EitoC007';'EitoC008';'EitoC009';'EitoC010';...
%     ;'EitoC011';'EitoC012';'EitoC013';'EitoC014';'EitoC015';'EitoC016';'EitoC017';'EitoC018';'EitoC019';'EitoC020';...
%     ;'EitoC021';'EitoC022';'EitoC023';'EitoC024';'EitoC025';'EitoC026';'EitoC027';'EitoC028';'EitoC029';'EitoC030';...
%     ;'EitoC031';'EitoC032'};

EXPname = {'EitoT001';'EitoT002';'EitoT004';'EitoT005';'EitoT006';'EitoT007';'EitoT008';'EitoT009';'EitoT010';...
    ;'EitoT011';'EitoT012';'EitoT013';'EitoT014';'EitoT015';'EitoT016';'EitoT017';'EitoT018';'EitoT019';...
    ;'EitoT021';'EitoT023';'EitoT024';'EitoT025';'EitoT026';'EitoT027'};
% keyboard

nEMG    = length(EMGname);
nList   = length(ExpName);
nEXP    = length(EXPname);

kk      = 0;
for ii  = 1:nEMG
    for jj  = 1:nEMG
        if(ii < jj)
            kk  = kk + 1;
            EMGpair{kk} = [EMGname{ii},'-',EMGname{jj}];
        end
    end
end
nEMGpair    =  kk;

for ii  = 1:nList
    eval(['matrix.',ExpName{ii},'=zeros(',num2str(nEMG),');']);
    eval(['row=zeros(',num2str(nEXP),',',num2str(nEMGpair),');']);
end


jj  = 0;
for ii  = 1:nList
    icol    = strmatch(Chan1{ii},EMGname);
    irow    = strmatch(Chan2{ii},EMGname);
    iExp    = strmatch(ExpName{ii},EXPname);
    if(icol~=0 & irow~=0)
%         eval(['matrix.',ExpName{ii},'(',num2str(icol),',',num2str(irow),'
%         )=absrmax{',num2str(ii),'};']);
         eval(['matrix.',ExpName{ii},'(',num2str(icol),',',num2str(irow),')=abs(',num2str(r{ii}),');']);
    end
    if(icol < irow)
        jj  = jj + 1;
        ind = (icol - 1) * nEMG - (icol + 1) * icol / 2 + irow;
%         eval(['row(',num2str(iExp),',',num2str(ind),')=absrmax{',num2str(ii),'};']);
        eval(['row(',num2str(iExp),',',num2str(ind),')=abs(',num2str(r{ii}),');']);
    end
end

% EXPname = fieldnames(y);
% nEXP    = length(EXPname);

if summaryfig_flag  == 1
    fig     = figure('Name','xtalk_check',...
        'NumberTitle','Off',...
        'FileName','xtalk_check',...
        'Position',[309 410 1000 700]);
    imagesc(row,[0,0.5]);% shading flat

    h   =gca;
    title(h,'xtalk check')
    set(h,'CLim',[0,0.5],...'XDir','Normal',...
        'XAxisLocation','Top',...
        'XTick',[1:nEMGpair],...
        'XTickLabel',EMGpair,...'YDir','Reverse',...
        'YAxisLocation','Left',...
        'YTick',[1:nEXP],...
        'YTickLabel',EXPname);
    colorbar
end

if eachfig_flag  == 1
    for ii=1:nEXP
        data    = getfield(matrix,EXPname{ii});
        fig     = figure('Name',EXPname{ii},...
            'NumberTitle','Off',...
            'FileName',EXPname{ii},...
            'Position',[309 410 1000 700]);
        imagesc(data,[0,0.5]);% shading flat

        h   =gca;
        title(h,EXPname{ii})
        set(h,'CLim',[0,0.5],...'XDir','Normal',...
            'XAxisLocation','Top',...
            'XTick',[1:nEMG],...
            'XTickLabel',EMGname,...'YDir','Reverse',...
            'YAxisLocation','Left',...
            'YTick',[1:nEMG],...
            'YTickLabel',EMGname);
        colorbar
        saveas(fig,fullfile(pathname,EXPname{ii}),'fig')
        disp([fullfile(pathname,EXPname{ii}),' was saved.'])


    end
end

if xlswrite_flag  == 1
    for ii=1:nEXP
        warning('off')
        data    = getfield(matrix,EXPname{ii});
        
        outdata = cell(nEMG+1,nEMG+1);
        outdata(1,2:(nEMG+1)) = matrixlabel;
        outdata(2:(nEMG+1),1) = matrixlabel;
        outdata(2:(nEMG+1),2:(nEMG+1))  = num2cell(data);
        
        
        xlswrite(fullfile(pathname,xlsfile),outdata,EXPname{ii});
        warning('on')
    end
end
