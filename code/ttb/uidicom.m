function info   = uidicom

[filename, pathname]    = uigetfile('*.dcm');
info    = dicominfo(fullfile(pathname, filename));
I       = dicomread(info);
imtool(I,[])
