function errorlog(errormsg)

delete('errorlog.txt')
fid = fopen('errorlog.txt','a');
fclose(fid);
