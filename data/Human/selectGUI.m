%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by : Naohito Ohta
Last Modification : 2023.03.27
【function】
使用するデータをGUIで選択するための関数．
(頻繁に使うので関数化した)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fileNames,pathName] = selectGUI(patient_name,restrict_name)
select_dir = [pwd '/' patient_name];
% ファイルを選択する
switch nargin
    case 1
        disp('please select .csv file (which is used to analyze)')
        [fileNames, pathName] = uigetfile('*.csv',select_dir,'MultiSelect','on');
    case 2
        %restrict_name → GUIで選べるmatファイルを限定する 'EMG'/'Marker'
        if strcmp(restrict_name, 'none')
            [fileNames, pathName] = uigetfile('*.mat',select_dir,'MultiSelect','on');
        else
%             disp(['please select .mat file of ' restrict_name ' (which is used to analyze)'])
            [fileNames, pathName] = uigetfile(select_dir,'MultiSelect','on');
        end
end
end

