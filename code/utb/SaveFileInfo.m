function [] = SaveFileInfo(monkeyname,tarsessions,tarfiles, taskname)
%This function make information file at the beginning of the EMG analysis.
%
%1. make excel sheet to make the list of 'tarsessions' and tarfiles. 
%   example... tarsession:170420, tarfiles:{[2,5]}

%2. copy data from excel sheet to matlab variables. At this time you have
%to make tarfiles as cell array. If not, MATLAB never permit the paste of
%excel data.

%3.after makinig 'tarsessions' and 'tarfiles' you can run this code.

% have a nice jouny of analysis 
% Naoki Uchida , funato lab, Dec, 2020
%% set param
monkey_name = 'F' ;
tarsessions = 170516;
tarfiles = {2 4};
%% code section
for tarN = 1:length(tarsessions)
    fileInfo.monkeyname = monkeyname;
    fileInfo.xpdate = tarsessions(tarN);
    fileInfo.file_num = [tarfiles(1),tarfiles(2)];
    save([monkeyname num2str(tarsessions(tarN)) '_' taskname '.mat'],'fileInfo')
end
end

