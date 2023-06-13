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


[srcfilenames, srcpathname] = uigetfile(fullfile(srcpathname,srcfilename), 'Source�t�@�C����I�����Ă�������','MultiSelect','on');
if(isequal(srcfilenames,0) || isequal(srcpathname,0))
    disp('User pressed cancel')
    return;
end
if(~iscell(srcfilenames))
    srcfilenames    = {srcfilenames};
end

setconfig(mfilename,'srcpathname',srcpathname);
setconfig(mfilename,'srcfilename',srcfilenames{1});



despathname = uigetdir(fileparts(srcpathname), 'Destination�t�H���_�̐e�t�H���_��I�����Ă�������');
desdirs     = uiselect(dirdir(despathname),[],'Destination�t�H���_��I�����Ă��������i�����I���j');



% srcfullfilename = fullfile(srcpathname,srcfilename);
% 
% ndir    = length(desdirs);
% desfulldirs = cell(1,ndir);
% for ii  = 1:ndir
%     desfulldirs{ii} = fullfile(despathname,desdirs{ii});
% end
% 
% ync  = questdlg({'Source:',srcfullfilename,'|','V','Destination:',desfulldirs{1},'  :',[' ',num2str(length(desdirs)),' folders'],'  :',desfulldirs{end}},'�m�F');
% if(~strcmpi(ync,'yes'))
%         return;
% end
% 
% ii  =1;
% dirname = desdirs{1};
% filename    = srcfilename;
% while 1
%     evalstr = inputdlg({'�g����ϐ�=dirname,filename,num2str(ii)'},'�ۑ�����t�@�C�����̓���',1,{['''',srcfilename,'''']});
%     evalstr = evalstr{:};
%     try
%     eval(['desfilename =',evalstr,';']);
%     ync = questdlg({'���̃t�@�C�����ł����ł����H�iii=1�ł̗�j',' ',[' ',desfilename]},'�m�F');
%     if(strcmpi(ync,'yes'))
%         break;
%     end
%     catch
%         msgbox({'�w�肵��������͖����ł����B',evalstr});
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