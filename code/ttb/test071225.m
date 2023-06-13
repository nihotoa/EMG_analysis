fid	=fopen('test071225.txt','r');
hedda   =textscan(fid,'%s',2);
suuchi	=textscan(fid,'%d%d');
hutta	=textscan(fid,'%s');
fclose(fid);