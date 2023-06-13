function Y  = errorlog(errormsg)
% MATLABデフォルトのユーザーフォルダに'errorlog.txt'ファイルを作成し、入力された文字列を書き込む。

workpath    = userpath;
if(isempty(workpath))
    workpath  = fullfile(matlabroot,'work');
end
if(strcmp(workpath(end),';'))
    workpath(end)=[];
end

filename    = fullfile(workpath,'errorlog.txt');

if(nargin>0)
    fid = fopen(filename,'a');
    fprintf(fid,'%s\t[%s]\r\n',errormsg,datestr(now));
    fclose(fid);
else
    edit(filename)
end

if(nargout>0)
    Y   = filename;
end