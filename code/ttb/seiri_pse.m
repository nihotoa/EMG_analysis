function y  = seiri_pse

xlsfile = uigetfullfile;
[num,txt,raw]   = xlsread(xlsfile, -1);

[num,txt,rowlabel] = xlsread(xlsfile, -1);
[num,txt,collabel] = xlsread(xlsfile, -1);

nrow    = length(rowlabel);
ncol    = size(collabel,2);
nraw    = size(raw,1);

y   = cell(nrow,ncol);


for iraw  =2:nraw
    expname = raw{iraw,2};
    EMGname = raw{iraw,4};
    ind     = findstr(EMGname,'l');
    EMGname = EMGname(ind(1)+1:ind(2)-1);
    pseind  = raw{iraw,8};
    
    irow    = find(strcmp(rowlabel(:,1),expname)&strcmp(rowlabel(:,2),EMGname));
    
    y(irow,1:7)   = raw(iraw,9:15);
    y(irow,(8+15*pseind):(23+15*pseind-1))   = raw(iraw,17:31);
end



