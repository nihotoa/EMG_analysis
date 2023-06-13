function varargout  = sortrowsxls(X,col)
%   SORTXLS   �����܂��͍~���Ƀ\�[�g
%   
%   �x�N�g���̏ꍇ�ASORTXLS(X) �́AX �̗v�f�������Ƀ\�[�g���܂��B
%   �s��̏ꍇ�ASORTXLS(X) �́AX �̊e��P�ʂɁA�v�f�̏��������̂���\�[�g
%   ���܂��B
%   N-�����z��̏ꍇ�ASORTXLS(X) �́A������1�łȂ��ŏ��̎����ɑ΂��āA�\�[�g
%   ���܂��BX �������̃Z���z��̏ꍇ�ASORTXLS(X) �́AExcel�́u���בւ��v�Ɠ�������
%   �ɕ������\�[�g���܂��B
%  
%   Y = SORTXLS(X,DIM,MODE) �́A2�̃I�v�V�����̃p�����[�^�������܂��B
%   DIM �́A�\�[�g�̂��߂̎�����I�����܂��B
%   MODE �́A�\�[�g�̕�����I�����܂��B
%        'ascend' �́A�����ɂȂ�܂��B
%        'descend' �́A�~���ɂȂ�܂��B
%   ���ʂ́AY �ɂȂ�AX �Ɠ����`���ƃ^�C�v�������܂��B
%  
%   [Y,I] = SORTXLS(X,DIM,MODE) �́A�C���f�b�N�X�s�� I ���o�͂��܂��B
%   X ���x�N�g���̏ꍇ�AY = X(I) �ƂȂ�܂��B
%   X �� m �s n ��̍s��� DIM=1 �̏ꍇ�A
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end 
%   �ƂȂ�܂��B
%  
%   X �����f���̏ꍇ�A�v�f�� ABS(X) �Ń\�[�g����܂��B��v����l�ɂ��ẮA
%   ����� ANGLE(X) ���g���ă\�[�g����܂��B
%  
%   �����l���������݂���ꍇ�A�I���W�i���̗v�f�̏��Ԃ��A�\�[�g���ꂽ���ʂ�
%   �����f����A�����l�̗v�f�̃C���f�b�N�X���A�C���f�b�N�X�s��̒��ɏ�����
%   �o�͂���܂��B
%  
%   ���F X = [3 7 5
%               0 4 2] �̏ꍇ�A
%  
%   sort(X,1) �́A[0 4 2  �ɂȂ�Asort(X,2) �́A[3 5 7  �ɂȂ�܂��B
%                  3 7 5]                        0 2 4] 
%  
%   �Q�l issorted, sortrows, min, max, mean, median
% 
%     ���̑��̃f�B���N�g���ɂ��铯�����O�̃I�I�[�o�[���[�h���ꂽ�֐��A�܂��̓��\�b�h
%        help cell/sort.m
% 
%     �Q�ƃy�[�W��Help browser�ɂ���܂�
%        doc sort

%   081021 by TT


error(nargchk(1,2,nargin,'struct'));
error(nargchk(0,2,nargout,'struct'));

if(nargin==1)
    col   = 1;
end

x   = X(:,col);

if(isnumeric(x))
    [Y,I] = sort(x);
elseif(iscell(x))
    xx  = lower(x);
    [Y,I] = sort(xx);
end

y   = X(I,:);


varargout{1}    = y;
if(nargout==2)
    varargout{2}    = I;
end


