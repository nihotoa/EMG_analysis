function getspike_raster
global gsobj

fig = figure;
set(fig,'Name','GetSpike(Raster)',...
    'Numbertitle','Off',...
    'Pointer','arrow',...
    'Position',[93   102   613   393],...
    'Tag','gsraster',...
    'Toolbar','Figure');

h1   = subplot(3,1,1);
set(h1,'Tag','raster_axis');

h2   = subplot(3,1,2);
set(h2,'Tag','psth_axis');

h3   = subplot(3,1,3);
set(h3,'Tag','sta_axis');

gsobj.handles.gsraster     = fig;
gsobj.handles.raster       = h1;
gsobj.handles.psth         = h2;
gsobj.handles.sta          = h3;

