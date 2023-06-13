function	idiff = setdiff2(inew,iold)
% Fast calculation of set difference 'setdiff' for interger index
% idiff = setdiff2(inew,iold)
% --- Input
% inew , iold : Integer index array
% --- Output
% idiff : index in 'inew' which is not included in 'iold'
%
% inew �̗v�f�� iold �̗v�f�łȂ��l�� idiff �ɏo��
% inew , iold , idiff �͐���
%
% Ver 1.0 written by M. Sato  2003-3-15

inew  = inew(:);
iold  = iold(:);

N	  = max([inew ; iold]);

jflag = zeros(N,1);
imask = ones(N,1);

jflag(inew) = 1; 	% inew �̃C���f�b�N�X�� 1 �̃t���O�𗧂Ă�
imask(iold) = 0;	% iold �̃C���f�b�N�X�� 0 �̃}�X�N

jflag = jflag.*imask; 

idiff = find(jflag==1);
