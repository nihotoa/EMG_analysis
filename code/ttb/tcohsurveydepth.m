function tcohsurveyDepth_btc(Pathname)

Datapath    = matpath;
rootpath    = fullfile(datapath,'tcohsurvey');
Outputpath     = fullfile(rootpath,Pathname);
mkdir(Outputpath);
% 

maxtrial    = 50;


Expnames    = {'EitoT004',...
    'EitoT005',...
    'EitoT009',...
    'EitoT010'};
 


trigfiles    = {'Grip Onset (svwostim)(down-0-1000)';...
    'Grip Onset (svwostim)(down-250-1250)';...
    'Grip Onset (svwostim)(down-500-1500)';...
    'Grip Onset (svwostim)(down-750-1750)';...
    'Grip Onset (svwostim)(down-1000-2000)';...
    'Grip Onset (svwostim)(down-1250-2250)';...
    'Grip Onset (svwostim)(down-1500-2500)';...
    'Grip Onset (svwostim)(down-1750-2750)';...
    'Grip Onset (svwostim)(down-2000-3000)';...
    'Grip Onset (svwostim)(down-2250-3250)';...
    'Grip Onset (svwostim)(down-2500-3500)';...
    'Grip Onset (svwostim)(down-2750-3750)';...
    'Grip Onset (svwostim)(down-3000-4000)'};
% trigfiles    = {'Grip Onset (svwostim)(all-0-1000)';...
%     'Grip Onset (svwostim)(all-500-1500)';...
%     'Grip Onset (svwostim)(all-1000-2000)';...
%     'Grip Onset (svwostim)(all-1500-2500)';...
%     'Grip Onset (svwostim)(all-2000-3000)';...
%     'Grip Onset (svwostim)(all-2500-3500)';...
%     'Grip Onset (svwostim)(all-3000-4000)'};
% trigfiles    = {'Grip Onset (svwostim)(down-0-1000)'};

% trigfile    = 'CentT Off (success valid)';


channames = {'Field 1-subsample','FDI-subsample';...
    'Field 1-subsample','ADP-subsample';...
    'Field 1-subsample','3DI-subsample';...
    'Field 1-subsample','2DI-subsample';...
    'Field 1-subsample','AbPB-subsample';...
    'Field 1-subsample','BRD-subsample';...
    'Field 1-subsample','ED23-subsample';...
    'Field 1-subsample','ECR-subsample';...
    'Field 1-subsample','EDC-subsample';...
    'Field 1-subsample','ECU-subsample';...
    'Field 1-subsample','AbPL-subsample';...
    'Field 1-subsample','4DI-subsample';...
    'Field 1-subsample','AbDM-subsample';...
    'Field 1-subsample','FCR-subsample';...
    'Field 1-subsample','FDS-subsample';...
    'Field 1-subsample','FDPr-subsample';...
    'Field 1-subsample','FDPu-subsample';...
    'Field 1-subsample','FCU-subsample';...
    'Field 1-subsample','PL-subsample';...
    'Field 1-subsample','Biceps-subsample';...
    'Field 1-subsample','Triceps-subsample'};

% channames = {'Field 1-subsample','FDI-subsample'};


nExp    = length(Expnames);
nchan    = size(channames,1);
nTrig   = length(trigfiles);

for iExp = 1:nExp
    Expname = Expnames{iExp};
    
    
    disp([Expname,'(',num2str(iExp),'/',num2str(nExp),') '])
    
    for ichan    = 1:nchan

        Reffile = channames{ichan,1};
        Tarfile = channames{ichan,2};
        Ref     = load(fullfile(Datapath,Expname,Reffile));
        Tar     = load(fullfile(Datapath,Expname,Tarfile));

        for iTrig   =1:nTrig

            trigfile    = trigfiles{iTrig};
            trig        = load(fullfile(Datapath,Expname,trigfile));
            Outputfile  = fullfile(Outputpath,[Expname,'_',Reffile,'_',Tarfile,'_',trigfile]);
            try
                
                [f,cl]  = tcohtrig(Ref, Tar, trig,  [0 0.512], 128, maxtrial);
                save(Outputfile,'f','cl')
                disp([' L--(',num2str(ichan),'/',num2str(nchan),') ',Outputfile,' was created.'])
            catch
                disp([' L--(',num2str(ichan),'/',num2str(nchan),') ***** Error occured in ',Outputfile,'.'])
            end

        end
    end
end