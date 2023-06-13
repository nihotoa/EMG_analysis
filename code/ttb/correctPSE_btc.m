function correctPSE_btc



warning('off');


ParentDir   = uigetdir(fullfile(datapath,'STA'),'�e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(Tarfiles,1,'�ΏۂƂ���file��I�����Ă�������');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};

        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

        for ii=1:length(Tarfiles)
            try
                tic;
                
                Tarfile = Tarfiles{ii};
                
                InputFile_hdr  = fullfile(ParentDir,InputDir,Tarfile);
                InputFile_dat  = fullfile(ParentDir,InputDir,['._',Tarfile]);

%                 disp(['a:',num2str(toc)]);
                Tar_hdr = load(InputFile_hdr);
                Tar_dat = load(InputFile_dat);
%                 disp(['b:',num2str(toc)]);
                [Tar_hdr,Tar_dat]   = correctPSE(Tar_hdr,Tar_dat);
%                 disp(['c:',num2str(toc)]);
                
                save(InputFile_hdr,'-struct','Tar_hdr')
                save(InputFile_dat,'-struct','Tar_dat')
%                 disp(['d:',num2str(toc)]);
                clear('Tar_hdr','Tar_dat')
%                 mpack
%                 disp(['e:',num2str(toc)]);
                disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',InputFile_hdr])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})];
                disp(errormsg)
                errorlog(errormsg);
            end
            %                 indicator(ii,length(Tarfiles))
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

warning('on');


function [Tar_hdr,Tar_dat]   = correctPSE(Tar_hdr,Tar_dat)

items   = {'subYData',...
    'adjYData',...
    'adjTrialData'};
nitems  = length(items);
for iitem =1:nitems
    item    = items{iitem};
    if(isfield(Tar_hdr,item))
        Tar_hdr = rmfield(Tar_hdr,item);
    end
end

items   = {'adjTrialData'};
nitems  = length(items);
for iitem =1:nitems
    item    = items{iitem};
    if(isfield(Tar_dat,item))
        Tar_dat = rmfield(Tar_dat,item);
    end
end

