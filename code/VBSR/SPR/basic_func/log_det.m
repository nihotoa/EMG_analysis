function	d = log_det(sxx)
% Log( det(sxx) ) for Positive definite matrix
% ��ʬ������Ͼ���������оι���

% Gauss �ξõ�ˡ�ˤ�뻰�ѹ������
[L,U]	= lu(sxx);
eig_val = abs( diag(U) );
eig_val = eig_val(eig_val > 0);
d		= sum( log( eig_val ) );

% ���쥹��ʬ�� : X ���������ΤȤ�������ʬ�����ᤤ
%R = chol(X) �ϡ�X ���������ΤȤ���R'*R = X �Ȥʤ�廰�ѹ��� R 

%U = chol(sxx);
%d = 2*sum(log(diag(U)));

