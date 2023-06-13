function mfieldxls(Type)

if(nargin<1)
    Type    = 'MFIELD';
end

xlsload(-1,'Name','Label','Data');


S.Name          = Name;
S.AnalysisType  = 'MFIELD';
S.Label         = shiftdim(Label);
S.Data          = shiftdim(Data);
S.Type          = Type;



OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end

OutputFile  = getconfig(mfilename,'OutputFile');
try
    if(isempty(OutputFile))
        OutputFile   = [Type,'.mat'];
    end
catch
    OutputFile   = [Type,'.mat'];
end

pause(0.5)
[OutputFile, OutputDir] = uiputfile(fullfile(OutputDir,OutputFile), 'ƒtƒ@ƒCƒ‹‚Ì•Û‘¶');
if isequal(OutputFile,0) || isequal(OutputDir,0)
    keyboard
    disp('User pressed cancel')
    return;
else
    setconfig(mfilename,'OutputFile',OutputFile);
    setconfig(mfilename,'OutputDir',OutputDir);
end

Outputfullfile  = fullfile(OutputDir,OutputFile);
save(Outputfullfile,'-struct','S');
disp(Outputfullfile)

end