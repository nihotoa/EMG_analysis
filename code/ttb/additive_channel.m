function additive_channel


XName{1}   = 'Field 1-subsample';
XName{2}   = 'Field 2-subsample';
YName     = 'Field 3-subsample';

equation    = 'Y    = X{1} - X{2};';


ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = dir(ParentDir);
InputDirs   = uiselect({InputDirs.name});

for jj=1:length(InputDirs)
    try
    PATH    = fullfile(ParentDir,InputDirs{jj});
    disp(PATH)

    for ii=1:length(XName)
        s           = load(fullfile(PATH,[XName{ii},'.mat']));
        X{ii}       = s.Data;
    end
    
    if issamesize(X{:})
        eval(equation);
    else
        return
    end
    
    outputfile  = fullfile(PATH,[YName,'.mat']);
    s.Data      = Y;
    s.Name      = YName;
        save(outputfile,'-struct','s')
        disp(outputfile)
    catch
        disp(['****** Error occured in ',InputDirs{jj}])
    end
        
end
beep

