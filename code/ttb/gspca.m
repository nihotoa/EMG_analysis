function gspca
global gsobj

pcaxlim  = [-1 1.5];  % ms

data    = gsobj.scope.YData;
xdata   = gsobj.scope.XData;


% pcaxlimind(1)   = find(pcaxlim(1)==xdata);
% pcaxlimind(2)   = find(pcaxlim(2)==xdata);

[temp,pcaxlimind(1)]   = nearest(xdata,pcaxlim(1));
[temp,pcaxlimind(2)]   = nearest(xdata,pcaxlim(2));


addflag = gsobj.spike.addflag;

[gsobj.pca.pc,gsobj.pca.score] = princomp(double(data(:,[pcaxlimind(1):pcaxlimind(2)])));

if(~isfield(gsobj.handles,'pca') | ~ishandle(gsobj.handles.pca))
    getspike_pca;
end

gspca_xy;
gspca_plot;