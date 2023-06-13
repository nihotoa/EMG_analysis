function [RES] = XCORR(PRE,POST)
LoadData('Seseki')
load('SesekiL_standard_28_leverOn_AveAll.mat')
end
function [Result] = calEXcorr(T,TarN)
S = size(T.data);
Result = cell(TarN,1); 
R = zeros(TarN,S(2));

for M = 1:TarN
   for d = 1:S(2)
      for m = 1:TarN
         AltE = corrcoef(T.data{1,d}(M,:)',T.AVEPre4(m,:)');
         R(m,d) = AltE(1,2);
      end   
   end
   Result{M} = R;
end
end