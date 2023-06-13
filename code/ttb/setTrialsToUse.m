function setTrialsToUse(TrialsToUse)
% MDAのSTA解析ファイルにTrialsToUseをあとからセットする
% 使い方
% 1. MDAで通常通りSTAを行う。この時にcomponent parametersでStore Trialsにチェックを入れる。
% 2. 解析を行ったあとに、TrialsToUseを設定したいものをAnalysis Browserで選択する。
% 3. MATLABのコマンドラインに
%     setTrialsToUse
%     と書いてエンターキーをおす。
% 4. 入力ボックスが出てくるので、ここに数値を入れてOKをおす。
% 5. Analysis Browserのrefreshボタンをクリックする。
% 
% これで選択した解析のTrialsToUseが設定される。



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
