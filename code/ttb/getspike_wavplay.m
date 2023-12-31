function getspike_wavplay
global gsobj

h       = gsobj.handles.unit;
XData   = gsobj.unit.XData;
XLim    = get(h,'XLim');
ind     = (XData >= XLim(1) & XData <= XLim(2) );
totaltime   = diff(XLim);

data    = gsobj.unit.Data(ind);
sr      = gsobj.unit.SampleRate;

if(strcmp(class(data),'double'))    %%%%% doubleの場合は-1〜1の範囲に収まるようにノーマライズ
    maxdata = max(data);
    mindata = min(data);
    
    maxdata = max(abs(maxdata),abs(mindata));
    
    data    = data./maxdata;            
    
end

button = questdlg(['Total', num2str(totaltime) ,' seconds.'],'Play?');
% keyboard
if(button=='Yes')

    wavplay(data,sr,'async');
end
