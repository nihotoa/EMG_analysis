function uiTrialsToUse(command)

if(nargin<1)
    command = 'edit';
end


switch command
    case 'edit'
        [S,f]   = topen;
        keyboard
        save(f,'-struct',S);
        
    case 'replace'
    case 'merge'
    case 'apply'
        [S,f]   = topen;
        S       = applyTrialsToUse(S);
        
        
        
        
end
fig = get(hAx,'Parent');
UD  = get(fig,'UserData');
parentpath  = UD.parentpath;
ind = UD.h==hAx;
S   = UD.Data{ind};

fullfilename    = fullfile(parentpath,[S.Name,'.mat']);
[filename,pathname] = uiputfile(fullfilename);

if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    fullfilename    = fullfile(pathname,filename);
    save(fullfilename,'-struct','S');
    disp(fullfilename)
end
end

