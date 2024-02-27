function EMGs = get_EMG_name(TargetName)
%{
explanation of this func:
removing the string common to all elements from the 'TargetName' (cell array)
& retrun it as 'EMGs'
%}

% finding common string
% (since the process contents are connected by '-', find common string by concatenating the first '-' and the following)
ref_name = TargetName{1};
ref_name_components = strsplit(ref_name, '-');
ref_name_components{1} = strrep(ref_name_components{1}, ref_name_components{1}, '');
temp = join(ref_name_components, '-');
common_string = temp{1};

EMGs = cell(length(TargetName), 1);
% delete common strings from all elements
for ii = 1:length(TargetName)
    EMGs{ii} = strrep(TargetName{ii}, common_string, '');
end
end

