function [swmean, Y, order]  = stepwisemean(X,nperms)
% STEPWISEMEAN   �z���Step-wise�@�ɂ�镽�ϒl
%   
%   STEPWISEMEAN(X) �� X �̗v�f��Step-wise�ɗv�f�𑝂₵�����ϒl���o�͂��܂��B
%   X �̓x�N�g���łȂ��Ă͂Ȃ�܂���B
%   
%   STEPWISEMEAN(X,N) �� X �� N�񃉃��_���ɕ��בւ���Step-wise���ς����߂܂��B
%   �o�͂̍s�� N ��̕��בւ����A���Step-wise��������\���܂��B
%   
%   [SWMEAN, Y, ORDER]  = STEPWISEMEAN(X,...)�́AORDER�ɕ��בւ��ɗp�����C���f�b�N�X�̔z���
%   Y��ORDER�ǂ���ɕ��בւ���X�̒l��Ԃ��܂��B
%   
%   
%   ��:
%   
%     X = [0 1 2 3 4 5]
%  
%   �̏ꍇ�A
%   
%   [swmean,Y,order]  = stepwisemean(X) ��
% 
%   swmean =
%          0    0.5000    1.0000    1.5000    2.0000    2.5000
% 
%    Y =
%          0     1     2     3     4     5
% 
%    order =
%          1     2     3     4     5     6  
%          
%   ��Ԃ��܂��B
%   
%   
%   [swmean,Y,order]  = stepwisemean(X,2)�́A���Ƃ���
%   
%   swmean =
%         1.0000    2.0000    2.0000    2.7500    3.0000    2.5000
%         1.0000    2.0000    1.3333    2.0000    2.6000    2.5000
% 
%   Y =
%         1     3     2     5     4     0
%         1     3     0     4     5     2
%   
%   order =
%         2     4     3     6     5     1
%         2     4     1     5     6     3
%      
%   ��Ԃ��܂��B
% 
%   see also mean, cumsum.
  
% written by Takei 2010-02-21  
  

if(nargin<2)
    nperms = [];
end

X   = shiftdim(X)';
nX      = length(X);


if(~isempty(nperms))
Y       = nan(nperms,nX);
order   = nan(nperms,nX);

rand('state',0);% �����_���őI�Ԃ��ǁA���������Z�b�g���o��悤�ɂ��Ă���Ƃ�������

for iperm=1:nperms
    order(iperm,:)  = randperm(nX);
    Y(iperm,:)  = X(order(iperm,:));
end

swmean  = cumsum(Y,2) ./ repmat(1:nX,nperms,1);

else
    Y       = X;
    order   = 1:nX;
    
    swmean  = cumsum(Y,2) ./ (1:nX);
end
