%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CombineMatfile.m内で使われる関数
%manualと信号の終始の時間偏差に関する記述＋CAIデータの処理について書いてある(かなり長いのでこの関数に分けた)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [TimeRange,sel_name] = AlignStart(fileList2,downHz,align_trig,All_CEMG,data_name) %data_name:CAI,CRAW,CLFP etc... %sel_dataname:sel_CAI,sel_CLFP etc...
    for ii = 1:length(fileList2) 
       load(fileList2(ii).name)
       %↓TimeRangeに１日のデータのSTARTとENDの時間を代入(CAI_001を参照している)
       if ii==1 %最初のファイルのみ適用(最初のファイルにCTTL_003がなかったときは、その都度コードを書き換える)
           %align_time = CTTL_003_TimeBegin;%CTTL_003が最初に入ったタイミング
           TimeBegin = eval([align_trig '_TimeBegin']); %タスク開始のタイミング         
           task_time = length(All_CEMG)/downHz; %タスク時間[s](サンプル数をサンプリングレートで割る)
           TimeEnd = TimeBegin + task_time;%タスクの終了時刻
           TimeRange(1,1) = TimeBegin;
           TimeRange(1,2) = TimeEnd;
           trash_data_time = TimeBegin - eval([data_name '_001_TimeBegin;']); %不要な区間[s]
           for jj=1:1
               eval([data_name '_' sprintf('%03d',jj) '= cast(' data_name '_' sprintf('%03d',jj) ',"double");']);
               eval([data_name '_' sprintf('%03d',jj) '= resample(' data_name '_' sprintf('%03d',jj) ',downHz,' data_name '_001_KHz*1000);']);
               trash_sample=round(trash_data_time*downHz);
               eval([data_name '_001 =' data_name '_001(trash_sample+1:end);'])             
               eval(['sel_name{jj,ii} = ' data_name '_' sprintf('%03d',jj) ';'])
               %eval(['sel_data_name{jj,ii} = data_name' sprintf('%03d',jj) ';'])
           end
       else
           if TimeRange(1)<eval([data_name '_001_TimeBegin']) && TimeRange(2)>eval([data_name '_001_TimeEnd'])
               for jj=1:1
                  eval([data_name '_' sprintf('%03d',jj) '= cast(' data_name '_' sprintf('%03d',jj) ',"double");']);
                  eval([data_name '_' sprintf('%03d',jj) '= resample(' data_name '_' sprintf('%03d',jj) ',downHz,' data_name '_001_KHz*1000);']);        
                  eval(['sel_name{jj,ii} =' data_name '_' sprintf('%03d',jj) ';'])
               end
           else
               if eval([data_name '_001_TimeEnd']) > TimeRange(2) %こうなれば嬉しい
                   e_EndTime =  eval([data_name '_001_TimeEnd']) - TimeRange(2);%タスク終了時刻の偏差[s]
                   e_EndFrame = round(downHz * e_EndTime);
                   for jj=1:1
                       if isempty(CAI_001)
                           continue;
                       end
                       eval([data_name '_' sprintf('%03d',jj) '= cast(' data_name '_' sprintf('%03d',jj) ',"double");']);
                       eval([data_name '_' sprintf('%03d',jj) '= resample(' data_name '_' sprintf('%03d',jj) ',downHz,' data_name '_001_KHz*1000);']);  
                       eval([data_name '_001 =' data_name '_001(1:end-e_EndFrame);'])
                       eval(['sel_name{jj,ii} =' data_name '_' sprintf('%03d',jj) ';'])
                   end  
               %{
                ↓if文の条件上、これは成り立たない(はず)
               elseif eval([data_name '_001_TimeEnd']) < TimeRange(2) 
                   TimeRange(2) = data_name_001_TimeEnd;
                   for jj=1:1
                      eval([data_name '_' sprintf('%03d',jj) '= cast(' data_name '_' sprintf('%03d',jj) ',"double");']);
                      eval([data_name '_' sprintf('%03d',jj) '= resample(' data_name '_' sprintf('%03d',jj) ',downHz,' data_name '_001_KHz*1000);']);        
                      eval(['sel_name{jj,ii} =' data_name '_' sprintf('%03d',jj) ';'])
                   end
               %}
               end
           end
       end
    end
end

