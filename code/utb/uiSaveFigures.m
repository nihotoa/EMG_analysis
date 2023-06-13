function [] = uiSaveFigures(saveType)
%this code can save '-.fig' figures you had already saved
%If you would like to save some figures as '.fig' files automatically, you
%can use 'SaveFig.m' function in 'utb' folder. 

%Naoki Uchida, 4th, Dec, 2020

TarFig = uigetfile('*.fig','Select One or More Files', 'MultiSelect', 'on');
if ~isempty(saveType)
    for figN = 1:length(TarFig)
        f = openfig(TarFig{figN});
        SaveFig(f,strrep(TarFig{figN},'.fig',''), saveType)
    end
else
    disp('error : pleaase set the save type (ex:''png'')')
end
end