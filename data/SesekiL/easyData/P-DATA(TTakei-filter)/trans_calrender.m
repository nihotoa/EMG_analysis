function [calender_day] = trans_calrender(exp_day)
%TRANS_CALRENDER 
% function: return datatime object
% input => double (ex.) 20220801
% return: type => data time
    exp_day = string(exp_day); %string型へ変換
    temp = char(exp_day);
    if length(temp) == 8
        %年月日に分ける
        year = str2double(string(temp(1:4)));
        month = str2double(string(temp(5:6)));
        day = str2double(string(temp(7:8)));
    elseif length(temp) == 6
        %年月日に分ける
        year = str2double('20' + string(temp(1:2)));
        month = str2double(string(temp(3:4)));
        day = str2double(string(temp(5:6)));
    end
    
    % change to calender type
    calender_day = datetime(year,month,day);
end

