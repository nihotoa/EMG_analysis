%% ‘½•ªg‚Á‚Ä‚È‚¢(get_EMG_file_num.m‚Æ“¯‚¶“à—eH)
for ii = 1:size(hFile.Entity,2)
    a{ii,1} = hFile.Entity(1,ii).Label;
end
b=string(a);
start_num = find(b=='emg 1');
end_num = find(b=='emg 32');