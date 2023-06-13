function rdrive = rootdrive
% rootdrive.m fileのあるひとつ上の階層をrootdriveとする

rdrive  = mfilename('fullpath');
while(1)
    [rdrive,rdrive2]   = fileparts(rdrive);
    if(isempty(rdrive2))
        break;
        
    end
end
rdrive(end) = [];
% 
% 
% rdrives   = { 'C:\tkitom';...
%             'N:\tkitom';...
%             'F:\tkitom'};
% 
%             rdrive  = [];
% 
% for ii  = 1:length(rdrives)
%     if(exist(rdrives{ii}))
%         rdrive    = rdrives{ii}(1:2);
%     end
% end
% 
% if(isempty(rdrive))
%     error('rootdrive error: tkitom フォルダーが見つかりませんでした。')% tki driveが見つからなかったときにここに来ます。
% %     keyboard;
% end
