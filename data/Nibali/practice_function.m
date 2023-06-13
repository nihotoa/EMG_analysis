%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%関数の使い方の確認のために作った関数
%分かったこと:
%関数を実行するファイルと関数を定義しているファイルが同じ場合は、関数を使える
%関数が定義されているファイルと関数を実行するファイルが異なる場合は、定義した関数がないというエラーが出て実行できない(ただし、定義された関数が一つしかない場合は、ファイル名と関数名が等しいので、他ファイルからでも実行できる)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% num_list = [3,5,4,3,34,2,24,43];
% [sum_num] = practice_function1(num_list);
% a = 1;

function [sum_num] = practice_function1(num_list)
    sum_num = 0;
    for ii = num_list
        sum_num = sum_num + ii;
    end
end

function [average_num] = practice_function2(num_list)
    for ii = num_list
        
    end
end