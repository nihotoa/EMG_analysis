function y  = xtalkcheck

% EMGname         = {'FDI','ADP','3DI','2DI','AbPB','BRD','ED23','ECR','EDC','ECU','AbPL','4DI','AbDM','FCR','FDS','FDPr','FDPu','FCU','PL','Biceps','Triceps'};
EMGname         = {'FDI','2DI','3DI','4DI','ADP','AbPB','AbDM','FDS','FDPr','FDPu','PL','FCR','FCU','AbPL','ED23','EDC','ECR','ECU','BRD','Biceps','Triceps'};


filename        = uigetfullfile('*.xls','Pick a exel file.');
pathname        = fileparts(filename);
[temp1,temp2,x] = xlsread(filename,-1);


ExpName = [x(:,4);x(:,4)];
Chan1   = [x(:,5);x(:,6)];
Chan2   = [x(:,6);x(:,5)];
absrmax = [x(:,9);x(:,9)];
Option  = [x(:,7);x(:,7)];

nEMG    = length(EMGname);
nn  = length(ExpName);

for ii  = 1:nn
    eval(['y.',ExpName{ii},'=zeros(',num2str(nEMG),');']);
end



for ii  = 1:nn
    col = strmatch(Chan1{ii},EMGname);
    row = strmatch(Chan2{ii},EMGname);
    
    if(col~=0 & row~=0)
        eval(['y.',ExpName{ii},'(',num2str(col),',',num2str(row),')=absrmax{',num2str(ii),'};']);
    end
end


EXPname = fieldnames(y);
nEXP    = length(EXPname);

for ii=1:nEXP
    data(:,:)   = getfield(y,EXPname{ii});
    fig = figure('Name',EXPname{ii},...
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

