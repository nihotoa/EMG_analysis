clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
last modification: 2022.11.17
edhitor:Naohito Ohta
function: conduct statistics analysis with using multi-way anova from multi variable
�y�������z
(�t�ː搶�����������R�[�h�ŉ�͂������A�]��ł������ʂ������Ȃ������̂ŁA�T�C�g���Q�l�ɂ���,������2���z�u���U���͂̃R�[�h����낤�Ǝv����)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set param
syn_num = 4;
disp('�yplease select ~(pre).mat�z')
pre_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPre  = load(pre_file,  'WDaySynergy');

disp('�yplease select ~(post).mat�z')
post_file = uigetfile('*.mat',...
         'Select One or More Files', ...
         'MultiSelect', 'on');
WHPost = load(post_file, 'WDaySynergy');

%% code section
for ii = 1:syn_num
    all_data = [WHPre.WDaySynergy{ii} WHPost.WDaySynergy{ii}];
    [muscle_num,day_num] = size(all_data); 
    all_average = (sum(reshape(all_data,[1,muscle_num * day_num])))/(muscle_num * day_num);
    %square sum(�����a)
    all_square_sum = sum(reshape((all_data - all_average).^2,[1,muscle_num * day_num]));
    % muscle_square_sum
    muscle_square = zeros(1,muscle_num);
    for jj = 1:muscle_num
            each_muscle_average = sum(all_data(jj,:))/day_num;
            muscle_square(jj) = (each_muscle_average - all_average)^2;
    end
    muscle_square_sum = sum(muscle_square * day_num);
    %pre/post square_sum
    [row,col] = size(WHPre.WDaySynergy{ii});
    pre_average = (sum(reshape(WHPre.WDaySynergy{ii},[1,row * col])))/(row * col);
    pre_square = (pre_average - all_average)^2;
    pre_data_num = row * col;
    
    [row,col] = size(WHPost.WDaySynergy{ii});
    post_average = (sum(reshape(WHPost.WDaySynergy{ii},[1,row * col])))/(row * col);
    post_square = (post_average - all_average)^2;
    post_data_num = row * col;
    
    pp_square_sum = (pre_square * pre_data_num) + (post_square * post_data_num);
    
end