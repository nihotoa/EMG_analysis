%% データをソートするためのファンクション,refine_rowsは、どの行に関してソートするか
function sorted_data = sort_timing(use_data,refine_rows)
    sort_data = transpose(use_data);
    sorted_data = transpose(sortrows(sort_data,refine_rows,'ascend'));
end
