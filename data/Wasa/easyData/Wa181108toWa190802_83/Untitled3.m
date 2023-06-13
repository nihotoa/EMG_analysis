rectifiedArea           = [];
rectifiedArea = nan(length(chans),size(t_index2,1),length(obj));
rectifiedArea(1,j,1)                    = trapz(ttplot(t_index2(j,1):t_index2(j,2)),sEMG(t_index2(j,1):t_index2(j,2)));
rectifiedArea                               = rectifiedArea/EMG_SampleRate;
relrectifiedArea                            = (rectifiedArea./rectifiedTime);  
%%