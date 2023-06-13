function r = regression(X, y, noconst)
% �d���`��A(�ŏ�����A)�̏��ʌv�Z
% syntax: r = regression(X, y, noconst)
% Input:
%  y - target values (N x 1 vector)
%  X - explanatory variables (N x p matrix)
%  nonconst - include constant term
%             y = ��0 + �� * X
% Output: 
%  r.beta0      .. �ؕ� ��0
%  r.SE_b0      .. beta0 �W���덷
%  r.beta       .. ��A�W�� ��
%  r.SE_b       .. b �W���덷
%  r.meanX      .. X ����
%  r.meany      .. y ����
%  r.Syy        .. y ���U
%  r.yhat       .. ���_�l
%  r.sq_err     .. �c�������a
%  r.cs_err     .. ���R�x�C���ςݎc�������a����
%  r.cvyhat     .. LOO�������藝�_�l
%  r.cs_cve     .. LOO��������c�������a����
%  r.det_coeff  .. �d���֌W��(����W��)
%  r.cor_coeff  .. ���R�x�C���ς݌���W��
%  r.crv_coeff  .. ���R�x�C���ς݌������茈��W��
%  r.par_coeff  .. �Α��֌W��

% version 1.0, 09:13, 23-May-2004, created by m.tada

% also see linregr
if nargin == 0
    help(mfilename);
    return;
end
y = y(:);
[my, ny] = size(y);
[mX, nX] = size(X);
if mX ~= my,
   if nX == my,
      X = X';
   else
      error('Dimensions of y and X don''t match.');
   end
end

if nargin < 3
   X = [ones(my, ny), X];
   x = X(:, 2:end);
else
   x = X;
end

n    = length(y);
m_X  = mean(X);
m_y  = mean(y);
b    = X \ y; % nothing to do with money
yhat = X * b;
Syy  = (y - m_y)' * (y - m_y);
s2   = (y - yhat)' * (y - yhat);
s2c  = s2 / (length(y) - length(b));
se   = sqrt(diag(inv(X'*X))) .* sqrt(s2);
[yyR, iiR, yiR] = detmat( corrcoef([x, y]) );

% Crossvalidation using 'leave one out' method
pi = zeros(n, 1);
for i = 1:n
    xi    = [X(1:i-1,:) ; X(i+1:n,:)]; % drop ith sample
    yi    = [y(1:i-1) ; y(i+1:n)];
    bi    = xi \ yi;
    pi(i) = X(i, :) * bi;
end
rcv = (pi - y)' * (pi - y) / (length(y) - length(b));

if nargin < 3
    r.beta0 = b(1);
    r.SEb0  = se(1);
    r.beta  = b(2:end)';
    r.SEb   = se(2:end)';
    r.meanX = m_X(2:end);
else
    r.beta0 = 0;
    r.SE_b0 = 0;
    r.beta  = b';
    r.SE_b  = se';
    r.meanX = m_X;
end
r.meany     = m_y;
r.Syy       = Syy;
r.yhat      = yhat;
r.sq_err    = s2;
r.cs_err    = s2c;
r.cvyhat    = pi;
r.cs_cve    = rcv;
r.det_coeff = 1 - s2/Syy;
r.cor_coeff = 1 - s2c/( Syy/(length(y)-1) );
r.crv_coeff = 1 - rcv/( Syy/(length(y)-1) );
r.par_coeff = - yiR ./ sqrt(yyR * iiR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [yyR, iiR, yiR] = detmat(cM)
% cofactor determinants �� partial corrcoeff
n  = size(cM, 1);
dM = zeros(n);
for i = 1:n
    for j = i:n
        cm = cM;
        cm(i,:) = [];
        cm(:,j) = [];
        dM(i,j) = (-1)^(i+j) * det(cm);
    end
end
yyR  = dM(n, n);
iiR  = diag(dM(1:n-1,1:n-1));
yiR  = dM(1:n-1, n);
