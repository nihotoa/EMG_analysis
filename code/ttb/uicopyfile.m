function uicopyfile(newfilenames)
% uicopyfile
%
% optional uicopyfile(newfilenames[stringcellarray])
%  
% ex uicopyfile({'calibration.txt'})

if(nargin<1)
    newfilenames = {[]};
else
    if(~iscell(newfilenames))
        newfilenames    = {newfilenames};
    end
end


srcpathname     = getconfig(mfilename,'srcpathname');
if(isempty(srcpathname))
    srcpathname = pwd;
end

srcfilename     = getconfig(mfilename,'srcfilename');
if(isempty(srcfilename))
    srcfilename = '*.*';
end


[srcfilenames, srcpathname] = uigetfile(fullfile(srcpathname,srcfilename), 'Sourceファイルを選択してください','MultiSelect','on');
if(isequal(srcfilenames,0) || isequal(srcpathname,0))
    disp('User pressed cancel')
    return;
end
if(~iscell(srcfilenames))
    srcfilenames    = {srcfilenames};
end

setconfig(mfilename,'srcpathname',srcpathname);
setconfig(mfilename,'srcfilename',srcfilenames{1});



despathname = uigetdir(fileparts(srcpathname), 'Destinationフォルダの親フォルダを選択してください');
desdirs     = uiselect(dirdir(despathname),[],'Destinationフォルダを選択してください（複数選択可）');



% srcfullfilename = fullfile(srcpathname,srcfilename);
% 
% ndir    = length(desdirs);
% desfulldirs = cell(1,ndir);
% for ii  = 1:ndir
%     desfulldirs{ii} = fullfile(despathname,desdirs{ii});
% end
% 
% ync  = questdlg({'Source:',srcfullfilename,'|','V','Destination:',desfulldirs{1},'  :',[' ',num2str(length(desdirs)),' folders'],'  :',desfulldirs{end}},'確認');
% if(~strcmpi(ync,'yes'))
%         return;
% end
% 
% ii  =1;
% dirname = desdirs{1};
% filename    = srcfilename;
% while 1
%     evalstr = inputdlg({'使える変数=dirname,filename,num2str(ii)'},'保存するファイル名の入力',1,{['''',srcfilename,'''']});
%     evalstr = evalstr{:};
%     try
%     eval(['desfilename =',evalstr,';']);
%     ync = questdlg({'このファイル名でいいですか？（ii=1での例）',' ',[' ',desfilename]},'確認');
%     if(strcmpi(ync,'yes'))
%         break;
%     end
%     catch
%         msgbox({'指定した文字列は無効でした。',evalstr});
%     end
% end
    
    
nfile   = length(srcfilenames);
ndir    = length(desdirs);

for idir =1:ndir
    desdir  = desdirs{idir};
    
    for ifile =1:nfile
        srcfilename = srcfilenames{ifile};
        
        if(isempty(newfilenames{1}))
            newfilename = srcfilename;
        else
            if(isempty(newfilenames{ifile}))
                newfilename = srcfilename;
            else
                newfilename = newfilenames{ifile};
            end
        end
           
        tf = copyfile(fullfile(srcpathname,srcfilename), fullfile(despathname,desdir,newfilename));
        
        if(tf)
            disp(fullfile(despathname,desdir,newfilename));
        else
            disp(['***** error occurred: ',fullfile(despathname,desdir,newfilename)]);
        end
    end
end