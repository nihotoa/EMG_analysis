%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CombineMatfile.m���Ŏg����֐�
%manual�ƐM���̏I�n�̎��ԕ΍��Ɋւ���L�q�{CAI�f�[�^�̏����ɂ��ď����Ă���(���Ȃ蒷���̂ł��̊֐��ɕ�����)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [TimeRange,sel_name] = AlignStart(fileList2,downHz,align_trig,All_CEMG,data_name) %data_name:CAI,CRAW,CLFP etc... %sel_dataname:sel_CAI,sel_CLFP etc...
    for ii = 1:length(fileList2) 
       load(fileList2(ii).name)
       %��TimeRange�ɂP���̃f�[�^��START��END�̎��Ԃ���(CAI_001���Q�Ƃ��Ă���)
       if ii==1 %�ŏ��̃t�@�C���̂ݓK�p(�ŏ��̃t�@�C����CTTL_003���Ȃ������Ƃ��́A���̓s�x�R�[�h������������)
           %align_time = CTTL_003_TimeBegin;%CTTL_003���ŏ��ɓ������^�C�~���O
           TimeBegin = eval([align_trig '_TimeBegin']); %�^�X�N�J�n�̃^�C�~���O         
           task_time = length(All_CEMG)/downHz; %�^�X�N����[s](�T���v�������T���v�����O���[�g�Ŋ���)
           TimeEnd = TimeBegin + task_time;%�^�X�N�̏I������
           TimeRange(1,1) = TimeBegin;
           TimeRange(1,2) = TimeEnd;
           trash_data_time = TimeBegin - eval([data_name '_001_TimeBegin;']); %�s�v�ȋ��[s]
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
               if eval([data_name '_001_TimeEnd']) > TimeRange(2) %�����Ȃ�Ί�����
                   e_EndTime =  eval([data_name '_001_TimeEnd']) - TimeRange(2);%�^�X�N�I�������̕΍�[s]
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
                ��if���̏�����A����͐��藧���Ȃ�(�͂�)
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

