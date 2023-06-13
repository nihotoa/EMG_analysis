function [MonkeyPlusDays, Days, DaysN, path] = uiGetDays(monkeyName,tarName)
% select target files
%   Notes:
%   * this code was written by Naoki Uchida (Funato Lab., UEC)
%
%     monkeyName : 'Ya', 'Wa', 'Se'....first two characters of their name 
%
%        tarName : 'standard', 'scwew', 'Pdata'...what's kind of data
%
% MonkeyPlusDays : {'Ya170516', 'Ya170517'} cell array
%
%           Days : {'170516', '170517'} cell array
%
%          DaysN : [170516; 170517] vector
%

[Allfiles_String, path] = uigetfile('*.mat','Select One or More Files', 'MultiSelect', 'on');
MonkeyPlusDays = strrep(Allfiles_String, ['_' tarName '.mat'],'');
Days = strrep(MonkeyPlusDays,monkeyName,'');
if iscell(Days)
   DaysN =str2double(cell2mat(Days'));
else
   DaysN =str2double(Days);
end
end