function y  = getdepth(timeinsec)

% select Electorode Depth(um).mat file
s   = topen;
XData   = [1:length(s.Data)]/s.SampleRate;

for ii=1:length(timeinsec)
    indicator(ii,length(timeinsec))
    [temp,ind]  = nearest(XData,timeinsec(ii));
    y(ii)   = s.Data(ind);
end
indicator(0,0)

% 
% 
% 
%     [temp,ind]  = nearest(XData,timeinsec);
%     y   = s.Data(ind);
