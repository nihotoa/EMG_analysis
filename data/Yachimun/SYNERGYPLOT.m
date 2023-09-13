%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
pre_operate:(MoveFile.m) or SYNERGYPLOT.m
post_operate: dispNMF_W(path: /Users/naohitoohta/Desktop/EMG_analysis/data/Yachimun/new_nmf_result/dispNMF_W.m)
%めちゃめちゃ冗長
階層移りすぎ,変える必要のあるパラメータが，中で使う関数に散らばりすぎ．
ロードする変数が指定されていない．筋肉名や筋肉の数を自分で指定する必要がある
/Users/naohitoohta/Desktop/EMG_analysis/data/Yachimun/new_nmf_result/dispNMF_W.m
機能はしている
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set param
monkeyname = 'F';
%28
type = '_filtNO5';% _filt5 means'both' direction filtering used 'filtfilt' function
days = [...
        %pre-surgery
%          170405; ...
%          170406; ...
%          170410; ...
%          170411; ...
%          170412; ...
%          170413; ...
%          170414; ...
%          170419; ...
%          170420; ...
% %          170421; ...
%          170424; ...
%          170425; ...
% %          170426; ...
%          170501; ...
% %          170502; ...
%          170508; ...
%          170509; ...
% %           170510; ...
%          170511; ...
%          170512; ...
%          170515; ...
         170516; ...
         170517; ...
         170524; ...
         170526; ...
%          170529; ...
% % %         170605	; ...%post-surgery()
% %         170606	; ...
% %         170607	; ...
% %         170608	; ...
% %         170612	; ...
% %         170613	; ...
% %         170614	; ...
% %         170615	; ...
% %         170616	; ...
% % % %         170619	; ...
%          170620	; ...
%          170621	; ...
%          170622	; ...
%          170623	; ...
%         170627	; ...
        170628	; ...
        170629	; ...
         170630	; ...
         170703	; ...
         170704	; ...
% %          170705	; ...
         170706	; ...
         170707	; ...
         170710	; ...
         170711	; ...
         170712	; ...
         170713	; ...
         170714	; ...
         170718	; ...
         170719	; ...
         170720	; ...
        170725	; ...
        170726	; ...
% %         170801	; ...
        170802	; ...
        170803	; ...
        170804	; ...
        170807	; ...
        170808	; ...
        170809	; ...
        170810	; ...
        170815	; ...
% % %         170816	; ...
        170817	; ...
        170818	; ...
         170822	; ...
        170823	; ...
        170824	; ...
        170825	; ...
        170829	; ...
        170830	; ...
        170831	; ...
        170901	; ...
        170904	; ...
        170905	; ...
        170906	; ...
        170907	; ...
        170908	; ...
        170911	; ...
        170913	; ...
        170914	; ...
        170925  ; ...
        170926  ; ...
        170927  ; ...
        170929   ...
         ];
     
     Ld = length(days);
     

for ii = 1:Ld
    fold_name = [monkeyname sprintf('%d',days(ii))];
    synergyplot_func(fold_name);
end
