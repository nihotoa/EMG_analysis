function [alignedDATA, slct]=AlignDatasets(DATA,tarLength,direction)
% switch direction
%    case 'row'%-----------
%       dim = 2;
%    case 'column'%|||||||||||
%       dim = 1;
% end

if iscell(DATA)
   CELLsize = size(DATA);
   alignedDATA = cell(length(DATA),1);
   slct = cell(length(DATA),1);
   if min(CELLsize)==1
      targetNum = length(DATA);
      for tar = 1:targetNum
         [alignedDATA{tar}, slct{tar}] = AlignMatrixData(DATA{tar},tarLength,direction);
      end
   end
else
   [alignedDATA, slct] = AlignMatrixData(DATA,tarLength,direction);
end

end
function [alignedDATA, slct]=AlignMatrixData(DATA,tarLength,direction)
% DATAsize = size(DATA);
% alignedDATA = zeros(tarLength, DATAsize(3-dim));
slct.val = [0 0 0];
slct.note = 'val = [''equal'', ''data < tar'', ''data > tar'']';
% Transpose DATA matrix only 'row' direction data
switch direction
   case 'row'%-----------
      DATA = DATA';
%       dim = 2;
   case 'column'%|||||||||||
%       dim = 1;
end
if length(DATA(:,1)) == tarLength
   slct.val(1) = slct.val(1)+1;
   alignedDATA = DATA;
elseif length(DATA(:,1))<tarLength 
   slct.val(2) = slct.val(2)+1;
   alignedDATA = interpft(DATA,tarLength,1);
else
   slct.val(3) = slct.val(3)+1;
   alignedDATA = resample(DATA,tarLength,length(DATA(:,1)));
end
% RE-Transpose alignedDATA matrix only 'row' direction data
switch direction
   case 'row'%-----------
      alignedDATA = alignedDATA';
   case 'column'%|||||||||||
end
end