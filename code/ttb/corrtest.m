function [h,p,r,t,df]    = corrtest(X1,X2)


% Reference:
% �S���w�̂��߂̃f�[�^��̓e�N�j�J���u�b�N�@p224


alpha    = 0.05;
r   = corr(X1,X2);
n   = length(X1);
df  = n-2;

t   = (r*(sqrt(n-2)))/(sqrt(1-r.^2));

%�@��������Ȃ̂ŁA���̒l��t�������l���āA�Б�0.025�������ōl����
p   = 2*(1 - tcdf(abs(t),df));

h   = p<alpha;