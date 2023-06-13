function setTrialsToUse(TrialsToUse)
% MDA��STA��̓t�@�C����TrialsToUse�����Ƃ���Z�b�g����
% �g����
% 1. MDA�Œʏ�ʂ�STA���s���B���̎���component parameters��Store Trials�Ƀ`�F�b�N������B
% 2. ��͂��s�������ƂɁATrialsToUse��ݒ肵�������̂�Analysis Browser�őI������B
% 3. MATLAB�̃R�}���h���C����
%     setTrialsToUse
%     �Ə����ăG���^�[�L�[�������B
% 4. ���̓{�b�N�X���o�Ă���̂ŁA�����ɐ��l������OK�������B
% 5. Analysis Browser��refresh�{�^�����N���b�N����B
% 
% ����őI��������͂�TrialsToUse���ݒ肳���B



if(nargin<1)
    TrialsToUse = false;
end


AnalysisObjects = gsma;
nAnalyses = length(AnalysisObjects);
if nAnalyses < 1
    error('No selected analysis.')
end


for ana = 1:nAnalyses
    analysisName = get(AnalysisObjects(ana), 'Name');
    FullName = get(AnalysisObjects(ana), 'FullName');
    AnalysesComponents = analyses(AnalysisObjects(ana), 'componentobjs');
    nAnalysesComponents = length(AnalysesComponents);
    if nAnalysesComponents == 0
        disp(['PeakAreas: No components to do: ' analysisName]);
        break;
    end

    if(~TrialsToUse)
        old_TrialsToUse  = get(AnalysesComponents(1), 'TrialsToUse');
        old_TrialsToUse  = ['[',num2str(old_TrialsToUse),']'];

        new_TrialsToUse  = inputdlg({'TrialsToUse'},[analysisName],1,{old_TrialsToUse});
        if(isempty(new_TrialsToUse))
            disp('User Pressed Cancel')
            break;
        end
        new_TrialsToUse  = str2num(new_TrialsToUse{1});
    else
        new_TrialsToUse  = TrialsToUse;
    end
    for i = 1:nAnalysesComponents
        set(AnalysesComponents(i), 'TrialsToUse',new_TrialsToUse);
    end
end
