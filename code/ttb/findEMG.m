function EMGs=findEMG(EMGs)

EMGs    = parseEMG(EMGs);
for iEMG=length(EMGs):-1:1
    if(isempty(EMGs{iEMG}))
        EMGs(iEMG)=[];
    end
end
EMGs    = unique(EMGs);