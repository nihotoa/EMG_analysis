%% �f�[�^���\�[�g���邽�߂̃t�@���N�V����,refine_rows�́A�ǂ̍s�Ɋւ��ă\�[�g���邩
function sorted_data = sort_timing(use_data,refine_rows)
    sort_data = transpose(use_data);
    sorted_data = transpose(sortrows(sort_data,refine_rows,'ascend'));
end
