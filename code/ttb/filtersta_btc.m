function filtersta_btc(filter_type,filter_order,filter_opt,filter_direction)
% filtersta_btc('FIR',100,[],'normal')
% filtersta_btc('butter',2,{'stop',[55 65]},'normal')
% filtersta_btc('cheby2',2,{'stop',[55 65],80},'normal')

warning('off');


ParentDir   = uigetdir(fullfile(datapath,'STA'),'�e�t�H���_��I�����Ă��������B');
% InputDirs   = dir(ParentDir);
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'�ΏۂƂ���file��I�����Ă�������');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(Tarfiles)
                try
                    Tarfile         = Tarfiles{ii};
                    InputFile_hdr   = fullfile(ParentDir,InputDir,Tarfile);
                    InputFile_dat   = fullfile(ParentDir,InputDir,['._',Tarfile]);
                    
                    
                    Tar_hdr = load(InputFile_hdr);
                    Tar_dat = load(InputFile_dat);
                    [Tar_hdr,Tar_dat]   = filterSTA(Tar_hdr,Tar_dat,filter_type,filter_order,filter_opt,filter_direction);
                    
                    OutputFile_hdr  = fullfile(ParentDir,InputDir,[Tar_hdr.Name,'.mat']);
                    OutputFile_dat  = fullfile(ParentDir,InputDir,[Tar_dat.Name,'.mat']);
                    
                    save(OutputFile_hdr,'-struct','Tar_hdr')
                    save(OutputFile_dat,'-struct','Tar_dat')
                    
                    clear('Tar_*')

                    disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile_hdr])
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