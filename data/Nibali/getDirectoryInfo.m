%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
input:directory path
output: directory name cell which is contained in designated directory(input directory)
[Japanese explanation]
入力:dir_path: 中に入っているフォルダを確認したいフォルダのpath
    day_names_prefix: 取り出したいフォルダの含んでいる文字列 (ex.) day_names_prefix = [pre, post]
    output_type: ('name'にすると)，built-in関数のdirによる出力であるstruct構造ではなくて，dir.nameのcell配列で出力を返す
出力:type:cell 入力ディレクトリに存在するディレクトリのpathのリスト(フツーのdirだと.と..をとってくるのでそれを省いた)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function directoryInfo = getDirectoryInfo(dir_path, day_names_prefix, output_type)
% get directory information
dirData = dir(dir_path);
infoIndex = 1;

% eliminate '.' & '..'directory
for i = 1:numel(dirData)
    item = dirData(i);
    if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..') && contains(item.name, day_names_prefix)
        switch nargin
            case 2 %dir_pathだけの時
                directoryInfo{infoIndex} = item;
                infoIndex = infoIndex + 1;
            case 3 %output_typeがある時
                if strcmp(output_type, 'name')
                    directoryInfo{infoIndex, 1} = item.name;
                    infoIndex = infoIndex + 1;
                end
        end
    end
end
end

