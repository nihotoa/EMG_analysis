function [days] = get_days(InputDirs)
%{
explanation of this func:
Extract the numerical part from each element of InputDirs(cell array) and create a list of double array
%}

days = zeros(length(InputDirs), 1);
for ii = 1:length(InputDirs)
    ref_element = InputDirs{ii};
    number_part = regexp(ref_element, '\d+', 'match');
    day = str2double(number_part{1});
    days(ii) = day;
end
end