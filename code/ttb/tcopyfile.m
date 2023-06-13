function tcopyfile
% [NUMERIC,TXT]	= xlsread('L:\tkitom\Documents and  Settings\tkitom\My Documents\Research\Experiment\Precision_grip_coherence\LFPEMGcoherence.xls',-1);
% origfiles	= uigetallfile('L:\tkitom\data\tcohtrig');
% destination = uigetdir('L:\tkitom\data\tcohtrig');
%
% jj  = 0;
% souces  = [];
% for ii=1:length(TXT)
%     temp	= strfilt(origfiles,TXT(ii,:));
%     if(~isempty(temp{1}))
%         jj  = jj + 1;
%         souces{jj}  = temp{1};
%     end
% end
%
% if(~isempty(souces))
% copyfile
% end

xlsfile         = uigetfullfile;
[NUMERIC,TXT]	= xlsread(xlsfile,-1);
source      = uigetdir(datapath,'ソースフォルダを選択');
destination = uigetdir(source,'保存先フォルダを選択');

files       = what(source);
files       = files.mat;

[nrow,ncol] = size(TXT);
for irow    = 1:nrow
    filt{irow}  = [];
    for icol    =1:ncol
        filt{irow}  = [filt{irow},' ',TXT{irow,icol}];
    end
end
% keyboard

nfilt  = length(filt);
TXT =[];
kk  =0;
for ii  =1:nfilt

    selectedfiles     = strfilt(files,filt{ii});
    nselectedfiles      = length(selectedfiles);
    for jj  =1:nselectedfiles
        kk  = kk+1;
        TXT{kk} = selectedfiles{jj};
    end
end

nfiles  = length(TXT)

disp(num2str(nfiles))

n   =0;
for ii=1:nfiles
    %     [source,'\*',TXT{ii,1},'*_',TXT{ii,2},'*']
    n   = n + copyfile(fullfile(source,TXT{ii}),destination,'f');
    indicator(ii,nfiles)
end
disp([num2str(n),' out of ',num2str(nfiles)])
indicator(0,0)
