function [Ofilename,Opathname]    = uicopy


[datas,files]   = topen;

if(iscell(datas))
    ndata  = length(datas);
    filename    = cell(ndata,1);
    pathname    = cell(ndata,1);
    for idata=1:ndata
        data    = datas{idata};
        file    = files{idata};
        if(idata>1)
            [tempP,tempF]   = fileparts(file);
            file    = fullfile(pathname{1},[tempF,'.mat']);
        end

        [filename{idata},pathname{idata}] = uiputfile(file,'ファイルの保存');
        save(fullfile(pathname{idata},filename{idata}),'-struct','data')
        disp([fullfile(pathname{idata},filename{idata}),' was copied.'])
    end
else
    data    = datas;
    file    = files;
    [filename,pathname] = uiputfile(file,'ファイルの保存');
    save(fullfile(pathname,filename),'-struct','data')
    disp([fullfile(pathname,filename),' was copied.'])
    
end


if nargout>0
    Ofilename   = filename;
    Opathname   = pathename;
end