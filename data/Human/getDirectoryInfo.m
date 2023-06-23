%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
input:directory path
output: directory name cell which is contained in designated directory(input directory)
[Japanese explanation]
入力:ディレクトリのpath
出力:入力ディレクトリに存在するディレクトリのpathのリスト(フツーのdirだと.と..をとってくるのでそれを省いた)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function directoryInfo = getDirectoryInfo(dir_path)
% get directory information
dirData = dir(dir_path);
infoIndex = 1;

% eliminate '.' & '..'directory
for i = 1:numel(dirData)
    item = dirData(i);
    if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..')
        directoryInfo{infoIndex} = item;
        infoIndex = infoIndex + 1;
    end
end
end

