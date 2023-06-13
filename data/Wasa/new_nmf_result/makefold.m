%%
clear
%%
monkeyname = 'Wa';
xpdate = '181227';
EMG_numlist = [4,5,9,10,11];

mkdir([monkeyname xpdate])

cd([monkeyname xpdate])


for i=1:length(EMG_numlist)
    mkdir([monkeyname xpdate '_SRstim'])
%     mkdir([monkeyname xpdate '_ICMS1000'])
     mkdir([monkeyname 'xpdaICMS19-29'])
%     mkdir([monkeyname xpdate '_ICMS16-11_06'])
%     mkdir([monkeyname xpdate '_ICMS16-11_07'])
%     mkdir([monkeyname xpdate '_ICMS16-11_08'])
%     mkdir([monkeyname xpdate '_ICMS19-20_09'])
%     mkdir([monkeyname xpdate '_ICMS19-20_10'])
%     mkdir([monkeyname xpdate '_ICMS19-20_11'])
    mkdir([monkeyname xpdate '_EMGstim'])
    
    mkdir([monkeyname xpdate '_syn_result_' sprintf('%02d',EMG_numlist(i))])
    cd([monkeyname xpdate '_syn_result_' sprintf('%02d',EMG_numlist(i))])
    mkdir([monkeyname xpdate '_W'])
    mkdir([monkeyname xpdate '_H'])
    mkdir([monkeyname xpdate '_VAF'])
    mkdir([monkeyname xpdate '_r2'])
    cd ../
end
cd ../