function R  =t2r(T,N)
% convert t score to correlation coefficient
% R  =t2r(T,N)
% 
% Reference:
% �S���w�̂��߂̃f�[�^��̓e�N�j�J���u�b�N�@p224


[T,nshift] = shiftdim(T);

R   = sqrt((T.^2)/(T.^2+N-2));

R = shiftdim(R,-nshift);

% EOF