%input1:data input2:num
% this function return input2 largetst values from input1 data
function [value] = max_sp(data,num)
sorted_data = sort(data, 'descend');
value = sorted_data(num,:);
end

