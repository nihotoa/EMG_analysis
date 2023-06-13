%% setting
monkeyname = 'Se';

% EMGname = 'ECR';
cd(tarPath_pre)
switch monkeyname
   case 'Ya'
      RepName = {'Lever1 on'; 'Lever1 off'; 'Lever2 on'; 'Lever2 off'};
%       EMGs = {'BRD','ECR','ECU','ED23','EDCdist','EDCprox','FCR','FCU','FDP','FDSdist','FDSprox','PL'};
      EMGs = {'Synergy1','Synergy2','Synergy3','Synergy4'};
   case 'Se'
      RepName = {'Lever1 on'; 'Lever1 off'; 'Photo on'; 'Photo off'};
%       EMGs = {'BRD','Deltoid','ECR','ECU','ED23','ED45','EDC','FCR','FCU','FDP','FDS','PL'};
      EMGs = {'Synergy1','Synergy2','Synergy3','Synergy4'};
end
[tarFig,tarPath] = uigetfile('*.fig',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
for m = 1:length(EMGs)
   count = 1;
   for tar = 4*(m-1)+1:4*m
      replace_title = [RepName{count} ' ' EMGs{m}];
      RepTitle(tarFig{tar},tarPath,replace_title);
      count = count + 1;
   end
end