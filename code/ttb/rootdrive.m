function rdrive = rootdrive
% rootdrive.m file�̂���ЂƂ�̊K�w��rootdrive�Ƃ���

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
%     error('rootdrive error: tkitom �t�H���_�[��������܂���ł����B')% tki drive��������Ȃ������Ƃ��ɂ����ɗ��܂��B
% %     keyboard;
% end
