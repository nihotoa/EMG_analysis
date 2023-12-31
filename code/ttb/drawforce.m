function [index,thumb] = drawforce
% 
% ifiles   = {'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00907\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FCR-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDI-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01105\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PT-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00907\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02401\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...BB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PT-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01105\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...FDI-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbDM-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01101\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat'};
% tfiles   = {'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00907\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FCR-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDI-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01105\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00903\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PT-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00907\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...ADP-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDS-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDPr-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02401\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00101\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...BB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00301\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PT-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...PL-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01105\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01108\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...FDI-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbDM-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT00201\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...BRD-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01101\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...AbPB-subsample(uV)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT01114\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
%     'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat'};

ifiles   = {'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat'};
tfiles   = {'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT02405\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00203\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat',...
    'L:\tkitom\MDAdata\Analyses\STA\AobaT00302\STA (Grip Onset (success valid), smoothed Thumb Torque(N)).mat'};


% files   = {'L:\tkitom\MDAdata\Analyses\STA\AobaT00907\STA (Grip Onset (success valid), smoothed Index Torque(N)).mat'};

for ii = 1:length(ifiles)
indexS   = load(ifiles{ii});
thumbS   = load(ifiles{ii});


index(ii,:)     = indexS.YData;
thumb(ii,:)     = thumbS.YData;

indicator(ii,length(ifiles))
end
index   = mean(index,1);
thumb   = mean(thumb,1);
indicator(0,0)





