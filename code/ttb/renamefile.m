function renamefile


% Find out the data file(s)
inputdir    = getconfig(mfilename,'inputdir');
if(isempty(inputdir))
    inputdir    = pwd;
end
filename    = getconfig(mfilename,'filename');
if(isempty(filename))
    filename    = '*.*';
end
[filenames,inputdir] = uigetfile(fullfile(inputdir,filename),'rename files','MultiSelect','on');
if isequal(filenames,0) || isequal(inputdir,0)
    return;
else
    setconfig(mfilename,'inputdir',inputdir);
    if(~iscell(filenames))
        filenames   = {filenames};
    end
    setconfig(mfilename,'filename',filenames{1});
end



answer   = getconfig(mfilename,'answer');
if(isempty(answer))
    answer   = {'',''};
end
prompt={'Search Word:','Replace to:'};
name='rename files';
numlines=1;

answer=inputdlg(prompt,name,numlines,answer);

oldstring    = answer{1};
newstring    = answer{2};

filenames   = strfilt(filenames,oldstring);

nfiles  = length(filenames);

yesall  = false;

for ifile=1:nfiles
    filename    = filenames{ifile};
    newfilename = strreplace(filename,oldstring,newstring);
    
    if(yesall)
        movefile(fullfile(inputdir,filename),fullfile(inputdir,newfilename));
        disp(fullfile(inputdir,newfilename))
    else
        ButtonName=questdlg({['old: ',filename];['new: ',newfilename]}, ...
            'Rename file?', ...
            'Yes','Yes to all','Skip','Yes');
        switch ButtonName
            
            case 'Yes'
                movefile(fullfile(inputdir,filename),fullfile(inputdir,newfilename));
                
                disp(fullfile(inputdir,newfilename))
            case 'Yes to all'
                movefile(fullfile(inputdir,filename),fullfile(inputdir,newfilename));
                disp(fullfile(inputdir,newfilename))
                yesall  = true;
            case 'Skip'
            case 'Skip to all'
                disp('User pressed cancel.')
                return;
        end
    end
    
    
end
