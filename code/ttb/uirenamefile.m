function uirenamefile(targetstr,replacestr)

% uirenamefile(targetstr,replacestr)
% targetstr,replacestr string


pathname = uigetdir(matpath, '親フォルダを選択してください');
dirs     = uiselect(dirdir(pathname),[],'対象とするフォルダを選択してください（複数選択可）');
% filenames   = uiselect(dirfile(fullfile(pathname,dirs{1})),[],'対象とするファイルを選択してください');

ndir    = length(dirs);
% nfile   = length(filenames);
nstr    = length(targetstr);

for idir =1:ndir
    dirname = dirs{idir};
    disp([num2str(idir),'/',num2str(ndir),'',dirname]);
    
    filenames   = dirmat(fullfile(pathname,dirs{idir}));
    filenames   = strfilt(filenames,targetstr);
    nfile   = length(filenames);
    
    for ifile=1:nfile
        filename        = filenames{ifile};
        try
            fullfilename    = fullfile(pathname,dirname,filename);

            while(1)
                
                ind = strfind(filename,targetstr);
                if(~isempty(ind))
                    nfilename   = length(filename);

                    if(ind(1)==1)
                        filename  = [replacestr,filename(nstr+1:end)];
                    elseif(ind(1)+nstr-1==nfilename)
                        filename  = [filename(1:ind(1)-1),replacestr];
                    else
                        filename  = [filename(1:ind(1)-1),replacestr,filename(ind(1)+nstr:end)];
                    end
                else
                    break;
                end

            end
            outfullfilename = fullfile(pathname,dirname,filename);
            if(exist(fullfilename,'file'))
                
                S   = load(fullfilename);
                
                if(isfield(S,'Name'))
                S.Name  = deext(filename);
                end
                
                save(outfullfilename,'-struct','S');
                
                
                if(~strcmp(targetstr,replacestr))
                    delete(fullfilename);
                end
                    disp([num2str(ifile),'/',num2str(nfile),': ',outfullfilename]);
                
            end
        catch
            disp(['*** error occurred in ',fullfile(pathname,dirname,filename)])
        end
    end
end