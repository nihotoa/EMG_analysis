function convert_electrode_depth_btc

ExpPath     = uigetdir(matpath);
Expnames    = dirdir(ExpPath);
Expnames    = uiselect(Expnames);

inputfile   = 'Electrode Depth.mat';
outputfile  = 'Electrode Depth(um).mat';


nExp    = length(Expnames);
for iExp = 1:nExp
    try
    Expname     = fullfile(ExpPath,Expnames{iExp});
    
    s           = load(fullfile(Expname,inputfile));
    if(isfield(s,'Unit'))
        if(strcmp(s.Unit,'mV'))
            cfactor = 0.152587890625;
            s.Data  = int16(s.Data/cfactor);
        end
    end
    s.Data      = convert_electrode_depth(s.Data);
    
    save(fullfile(Expname,outputfile),'-struct','s');
    clear s
    disp(['Converted:  ',fullfile(Expname,inputfile),' --> ',fullfile(Expname,outputfile)]);
    catch
        disp(['***** Error occured in  ',fullfile(Expname,inputfile)]);
  
    end
end