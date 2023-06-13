function msgwin(X)
% セルアレイであるXをカレントフォルダの'msg.txt'ファイル（ない場合は作成）に保存して、そのファイルを表示します。

fid = fopen('message.txt','w');

[nr,nc] = size(X);

for ii=1:nr
    for jj=1:nc
        x   = X{ii,jj};
        if(ischar(x))
            fprintf(fid,'%s\t',x);
        elseif(isnumeric(x))
            fprintf(fid,'%f\t',x);
        else
            fprintf(fid,'\t',x);
        end
    end
    fprintf(fid,'\n');
end
fclose(fid);

web('message.txt','-notoolbar','-noaddressbox');
