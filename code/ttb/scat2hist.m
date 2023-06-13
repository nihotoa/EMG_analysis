function [XData,YData,CData]    = scat2hist(x,y,dx,dy)

xind    = ceil(x./dx);
yind    = ceil(y./dy);

maxxind = max(xind);
minxind = min(xind);
maxyind = max(yind);
minyind = min(yind);

XDataind= minxind:maxxind;
YDataind= minyind:maxyind;
XData   = XDataind * dx - dx/2;
YData   = YDataind * dy - dy/2;

nXData  = length(XData);
nYData  = length(YData);

CData   = zeros(nYData,nXData);

for ix  =1:nXData
    for iy  =1:nYData
        CData(iy,ix)    = sum(xind==XDataind(ix) & yind==YDataind(iy));
    end
end

