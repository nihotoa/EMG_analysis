function mateditor

[S,filename]    = topen

save_flag   = true;
keyboard

if(save_flag)
    save(filename,'-struct','S')
    disp(filename)
end