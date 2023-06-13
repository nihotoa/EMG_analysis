function copyrenamefile
string  = 'AobaT00101';
try
    S   = loadconfig(mfilename);
    if(isempty(S))
        S.sourcepath    = rootdrive;
        S.outputpath    = rootdrive;
        S.string        = 'takei';
    end
    while(1)
        [sourcefile, sourcepath]    = getfile(S.sourcepath);
        if(~iscell(sourcefile))
            disp('Cancelled')
            return
        end
        nfiles  = length(sourcefile);

        outputpath  = uigetdir(S.outputpath, 'Pick a Directory');

        string      = getstring(S.string);
        string      =string{1};
        % define output filenames
        outputfile  = cell(size(sourcefile));
        if(isempty(string))
            outputfile      = sourcefile;
        else
            for ii=1:nfiles
                outputfile{ii}  = [string,'_',sourcefile{ii}];
            end
        end

        % confirm status
        currdir =pwd;
        cd([matlabroot,'\toolbox\matlab\uitools'])
        YN  = questdlg({['Source:  ',sourcepath],...
            ['Output:  ',outputpath],...
            ' ',...
            ['Create ',num2str(nfiles),' files...'],...
            outputfile{:}},...
            'Confirm status');
        cd(currdir)
        switch YN
            case 'Yes'
                break
            case 'No'
            case 'Cancel'
                return
        end
    end
    
    
    
    
    S.sourcepath    = sourcepath;
    S.outputpath    = outputpath;
    S.string        = string;
    saveconfig(mfilename,S)
    
    for ii=1:nfiles
        [SUCCESS(ii),MESSAGE{ii},MESSAGEID{ii}] = copyfile(fullfile(sourcepath,sourcefile{ii}),fullfile(outputpath,outputfile{ii}));
    end
    if(nfiles==sum(SUCCESS))
        disp('All files have been successfully created.')
    else
        disp({'Some files could not be created.',outputfile{~SUCCESS}})
    end
catch
    keyboard
end





% ---------------------------------------------
function [sourcefile, sourcepath]    = getfile(sourcepath)
sourcepath  = uigetdir(sourcepath, 'Pick a Directory');
sourcefile  = what(sourcepath);
sourcefile  = uiselect(sourcefile.mat,1,'Select Files.');

% ---------------------------------------------
function newstring = getstring(exstring)
prompt = {'String:'};
dlg_title = 'Enter header string:';
num_lines = 1;
def = {exstring};
newstring = inputdlg(prompt,dlg_title,num_lines,def);