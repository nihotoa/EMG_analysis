function	idiff = setdiff2(inew,iold)
% Fast calculation of set difference 'setdiff' for interger index
% idiff = setdiff2(inew,iold)
% --- Input
% inew , iold : Integer index array
% --- Output
% idiff : index in 'inew' which is not included in 'iold'
%
% inew の要素で iold の要素でない値を idiff に出力
% inew , iold , idiff は整数
%
% Ver 1.0 written by M. Sato  2003-3-15

inew  = inew(:);
iold  = iold(:);

N	  = max([inew ; iold]);

jflag = zeros(N,1);
imask = ones(N,1);

jflag(inew) = 1; 	% inew のインデックスに 1 のフラグを立てる
imask(iold) = 0;	% iold のインデックスに 0 のマスク

jflag = jflag.*imask; 

idiff = find(jflag==1);
