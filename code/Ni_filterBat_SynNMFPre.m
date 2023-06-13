ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'??????????Experiment???I???????????????B');

if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};

Tarfiles    = sortxls(dirmat(fullfile(ParentDir,InputDir)));

Tarfiles    = uiselect(Tarfiles,1,'Target?t?@?C?????I???????????????i?????I?????j?B');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end
% 
% OutputParentDir = getconfig(mfilename,'OutputParentDir');
% try
%     if(~exist(OutputParentDir,'dir'))
%         OutputParentDir = pwd;
%     end
% catch
%     OutputParentDir = pwd;
% end
% 
% OutputParentDir      = uigetdir(OutputParentDir,'?o???t?H???_???I???????????????B?K?v?????????????????????B');
% if(OutputParentDir==0)
%     disp('User pressed cancel.')
%     return;
% else
%     setconfig(mfilename,'OutputParentDir',OutputParentDir);
% end

for jj=1:length(InputDirs)
    try
    InputDir    = InputDirs{jj};
   
     for kk =1:length(Tarfiles)
         
         Tar         = loaddata(fullfile(ParentDir,InputDir,Tarfiles{kk}));
          OutputDir   = fullfile(ParentDir,InputDir);
%          mkdir(OutputDir)

%          Tar  = makeContinuousChannel([Tar.Name,''''''''], 'derivative', Tar, 3);
         %plot(Tar.Data)
         %saveas(gcf,'pre-data.png')
         %close all
         
         %median center subtraction
         %Tar   = makeContinuousChannel([Tar.Name,'-medC'],'medCenter',Tar);
         
         %highpass filtering
         Tar   = Ni_makeContinuousChannel([Tar.Name,'-hp50Hz'],'butter',Tar,'high',6,50,'both');
         
         %plot(Tar.Data)
         %saveas(gcf,'disp1.png')
         %close all
         
%          Tar  = makeContinuousChannel([Tar.Name,'-lp1000Hz'], 'butter', Tar, 'low',6,1000);
         %full wave rectification
         Tar  = Ni_makeContinuousChannel([Tar.Name,'-rect'],'rectify',Tar);
         
         %plot(Tar.Data)
         %saveas(gcf,'disp2.png')
         %close all
         
         %lowpass filtering
         Tar  = Ni_makeContinuousChannel([Tar.Name,'-lp20Hz'], 'butter', Tar, 'low',6,20,'both');
%          Tar  = Ni_makeContinuousChannel([Tar.Name,'-lp5Hz'], 'butter', Tar, 'low',6,5);
         
         %plot(Tar.Data)
         %saveas(gcf,'disp3.png')
         %close all
         
         % norlisation relative to the mean
         %Tar = Ni_makeContinuousChannel([Tar.Name,'-norm'],'meanNorm',Tar);
         %linear smoothing
         %Tar  = Ni_makeContinuousChannel([Tar.Name,'-lnsmth100'], 'linear smoothing', Tar,0.02);
         
         
         %down sampling at 100Hz
         Tar  = Ni_makeContinuousChannel([Tar.Name,'-ds100Hz'], 'resample', Tar, 100,0);
         
         %plot(Tar.Data)
         %saveas(gcf,'disp4.png')
         %close all
        
         
      save(fullfile(OutputDir,[Tar.Name,'.mat']),'-struct','Tar');disp(fullfile(OutputDir,Tar.Name));     
     %   TarMuscles(kk,1) = cellstr(Tar.Name); 
     end
     catch
      disp(['****** Error occured in ',InputDirs{jj}]) ; 
    end
    
end
    

%             

% S=topen;
% XData=((1:length(S.Data))-1)/S.SampleRate;
% fig    = figure;
% h     = nan(1,6);


% h(1)   = subplot(6,1,1,'parent',fig);
% plot(h(1),XData,S.Data); title(h(1),S.Name)

% %highpass filtering
% S   = Ni_makeContinuousChannel([S.Name,'-hp30Hz'],'butter',S,'high',2,30);
% h(2)    = subplot(6,1,2,'parent',fig);
% plot(h(2),XData,S.Data); title(h(2),S.Name)

% %rectify
% S  = Ni_makeContinuousChannel([S.Name,'-rect'],'rectify',S);
% h(3)    = subplot(6,1,3,'parent',fig);
% plot(h(3),XData,S.Data); title(h(3),S.Name)
% 
% % detrend (substract baseline)
% S   = Ni_makeContinuousChannel([S.Name,'-detrend'],'detrend',S,'constant');
% h(4)    = subplot(6,1,4,'parent',fig);
% plot(h(4),XData,S.Data); title(h(4),S.Name)
% % 
% %lowpass filtering
% S  = Ni_makeContinuousChannel([S.Name,'-lp20Hz'], 'butter', S, 'low',2,20);
% h(4)    = subplot(6,1,4,'parent',fig);
% plot(h(4),XData,S.Data); title(h(4),S.Name)


% % linear smoothing 100ms 100Hz version
% S  = Ni_makeContinuousChannel([S.Name,'-ls100ms'],'linear smoothing',S,0.1);
% h(5)    = subplot(6,1,5,'parent',fig);
% plot(h(5),XData,S.Data); title(h(5),S.Name)
% 

% % downsampling
% S  = Ni_makeContinuousChannel([S.Name,'-ds100Hz'], 'resample', S, 100,0);
% XData=((1:length(S.Data))-1)/S.SampleRate;
% h(6)    = subplot(6,1,6,'parent',fig);
% plot(h(6),XData,S.Data); title(h(6),S.Name)

% linkaxes(h,'xy')
% 
%            save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));
