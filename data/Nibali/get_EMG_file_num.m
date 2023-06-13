%% Copy_of_sample_data_walkthroughで使われる関数,EMG1のデータ行をSTART_NUMにEMG32のデータ行をEND_NUMに代入して返す
function [start_num,end_num] = get_EMG_file_num(hFile)
    for ii = 1:size(hFile.Entity,2)
        a{ii,1} = hFile.Entity(1,ii).Label;
    end
    b=string(a);
    start_num = find(b=='emg 1');
    end_num = find(b=='emg 32');
end

