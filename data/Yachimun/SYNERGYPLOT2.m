
clear
%% set parameter 

monkeyname = 'Ya';
EMG_Hz = 11000;%freq[Hz]
timfoldpath = uigetdir; %please select /Users/uchida/Documents/MATLAB/data/Yachimun/AllSuccessTiming

%please select
%/Users/uchida/Documents/MATLAB/data/Yachimun/AllSuccessTiming/Y17*_SUC_tim_per.mat
Tar_list = uigetfile('Multiselect','on')';
S = size(Tar_list);
Ld = S(1,1);  %the number of day

% make target days list
for ii = 1:Ld
    day = Tar_list{ii,1};
    day = strrep(day,monkeyname,'');
    day = strrep(day,'_SUC_tim_per.mat','');
    Tar_list{ii,1} = day;
end

%% get timing data

cd(timfoldpath)
    cell_timw = cell(Ld,1);
    cell_tim_A = cell(Ld,1);
    tim_ave = zeros(Ld,5);
    file_num_list = cell(Ld,1);
    count = zeros(Ld,1);
    for ii = 1:Ld
        day = Tar_list{ii,1};
        load([monkeyname day '_SUC_tim_per.mat'],'file_num','SUC_Timing_A');
        cell_timw{ii,1} = SUC_Timing_A;
         A_con = SUC_Timing_A;
        %timing
        tim_A = zeros(length(SUC_Timing_A(:,1)),6);
        tim_A(:,1) = A_con(:,1) - (A_con(:,4) - A_con(:,1)) .* 0.5;
        tim_A(:,2) = A_con(:,1);
        tim_A(:,3) = A_con(:,2);
        tim_A(:,4) = A_con(:,3);
        tim_A(:,5) = A_con(:,4);
        tim_A(:,6) = A_con(:,4) + (A_con(:,4) - A_con(:,1)) .* 0.3;
        cell_tim_A{ii,1} = tim_A;
        if tim_A(1,1)<0
            count(ii) = 1; 
        end
        
        %time range
        tim_R = SUC_Timing_A;
        tim_R(:,1) = (A_con(:,4) - A_con(:,1)) .* 0.5;
        tim_R(:,2) = A_con(:,2) - A_con(:,1);
        tim_R(:,3) = A_con(:,3) - A_con(:,2);
        tim_R(:,4) = A_con(:,4) - A_con(:,3);
        tim_R(:,5) = (A_con(:,4) - A_con(:,1)) .* 0.3;
        tim_ave(ii,:) = mean(tim_R);
        
        %file list
        file_num_list{ii,1} = file_num;
    end
cd ../
    timw = cell2mat(cell_timw);
    timw_con = timw;  
    timw(:,1) = (timw_con(:,4) - timw_con(:,1)) .* 0.5;
    timw(:,2) = timw_con(:,2) - timw_con(:,1);
    timw(:,3) = timw_con(:,3) - timw_con(:,2);
    timw(:,4) = timw_con(:,4) - timw_con(:,3);
    timw(:,5) = (timw_con(:,4) - timw_con(:,1)) .* 0.3;
    timw_ave = mean(timw);
    
    %% plot time range 
figure;
x_days = str2num(cell2mat(Tar_list))';
plot(sum(tim_ave(:,2:4),2)./(EMG_Hz/1000));
%     xlim([x_days(1) x_days(end)]);
ylim([0 15000])
    
     %% plot each trig all 
     DAY_AVE = cell(Ld,1);
for i = 1:Ld
    DAY_AVE{i,1} = synergyplot_func(monkeyname,sprintf('%d',x_days(i)),file_num_list{i},cell_tim_A{i},timw_ave);
    close all
end
    