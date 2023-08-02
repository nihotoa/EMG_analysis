function task_names = MakeTaskFoldersCell(task_num, common_string)
switch nargin
    case 1
        common_string = 'Task';
end
%MakeTaskFoldersCell 指定されたタスク数分のタスク名の入ったcell配列を作成{'Task01', 'Task02', ...}
%input: type -> double taskの個数
%output: type -> cell task名の入ったcell配列
task_names = cell(task_num, 1);
for ii = 1:task_num
    task_names{ii} = [common_string sprintf('%02d', ii)];
end
end

