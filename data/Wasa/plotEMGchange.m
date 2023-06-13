ParentDir = pwd; 
ParentDir   = uigetdir(ParentDir,'Wasa');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end