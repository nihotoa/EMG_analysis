function [YData4,XData4,cfactor1]    = rescaleXData(XData,YData,cfactor)


nData   = length(XData);
dt      = XData(2) - XData(1);

nData1  = round((nData-1) * cfactor) + 1;
XData1  = linspace(XData(1),XData(end),nData1);
YData1  = interp1(XData,YData,XData1,'*spline');
dt1     = XData1(2)- XData(1);

cfactor1    = dt/dt1;

XData2  = XData1*cfactor1;
YData2  = YData1;
nData2  = length(XData1);


if(nData2>=nData)   % 拡大したとき（cfactor>=1.0）
    startX  = nearest(XData2,XData(1));
    stopX   = nearest(XData2,XData(end));
    ind     = (XData2>=startX & XData2<=stopX);
%     ind     = (XData2>=XData(1) & XData2<=XData(end));
    XData3  = XData2(ind);
    YData3  = YData2(ind);
else   % 縮小したとき（cfactor<1.0）
    XData3  = XData;
    YData3  = zeros(size(XData3));
    [startX,startind]   = nearest(XData3,XData2(1));
    stopX   = XData3(startind+nData2-1);
%     stopX   = nearest(XData3,XData2(end));
    ind     = (XData3>=startX & XData3<=stopX);
%     ind     = (XData3>=XData2(1) & XData3<=XData2(end));
    YData3(ind) = YData2;
end

% 最後にXDataをあわせる
YData4  = interp1(XData3,YData3,XData,'*spline');
XData4  = XData;


