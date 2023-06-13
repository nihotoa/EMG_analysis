function [p,chi2,df,E]    = chi2test(x,E)
% [p,chi2,df,E]    = chi2test(x,E)
% �J�C��挟��
% x: [n,m]�̍s�� ��{�I��n��m�͓]�u���Ă������e�����܂���B
% E(input): �����x�N�g���ŁA�C�ӂ̓K���x������s���ꍇ�ɓ��͂��܂��B��̏ꍇ�A�u�S�Ă̏����̊m�����������v�Ƃ����A�������̌�����s���܂��B 
%           E�͊��Ғl�i���v�������̍��v���ƈꏏ�j�ł��A�m���i�Ⴆ��[0.25 0.25 0.25 0.25]�j�ł��\���܂���B
% �Ȃ��A�C�F�[�c�̘A�����␳���s���������́A�v���O�����̃R�����g�A�E�g����Ă�����̂��g���Ă��������B�i�f�t�H���g�ł͎g��Ȃ��j
% 
% ��
% x=[72,23,16,49];
% E=[40 40 40 40];    % E=[1 1 1 1]; �ł��@E=[0.25 0.25 0.25 0.25];�ł��ꏏ�ł��B
% 
% [p,chi2,df,E]    = chi2test(x,E)
% 
% p =
%   2.2533e-012
% 
% chi2 =
%    49.2500
% 
% df =
%      1
% 
% E =
%     40    40    40    40
% 
%     
%     
% 
% �T�����̊��Ғl���S�̂̂Q�O%�ȏ�ł���A�������͂P�����̊��Ғl���P�ł�����ꍇ�A�J�C��挟��͕s�K�ł��B
% Fisher's exact test�̎g�p���������Ă��������B

if(nargin<2)
    E   = [];
end

[nrow,ncol] = size(x);

if(any([nrow,ncol]==1))
    df  = 1;    % �K���x���� [ref. pp181]
    
    if(isempty(E))
        N   = sum(sum(x));      % ����
        l   = max(nrow,ncol);   % �J�e�S���[��
        
        E   = ones(nrow,ncol) * N / l;    % ���Ғl
        disp('���Ғl�����͂���Ă��܂���B�u�A�������F���ׂĂ̏����̊m�����������v�̌�����s���܂�');
    else
        if(~all(size(x)==size(E)))
            error('Size of x and E must be same.')
        end
        
        N   = sum(sum(x));      % ����
        NE  = sum(sum(E));      % ���Ғl�̑���
        
        E   = E ./ NE .* N;     % E���m���̏ꍇ�ł����Ғl�ɕϊ�����B
        
    end
    
    chi2    = sum(sum((x - E).^2 ./ E));    % ��[4-1-8]
%     chi2    = sum(sum((abs(x - E)-0.5).^2 ./ E));    % ��[4-1-9] �C�F�[�c�̘A�����␳
    p       = 1-chi2cdf(chi2,df);
    
elseif(any([nrow,ncol]>=3))
    df  = (nrow-1)*(ncol-1);    % �Ή����Ȃ�3�����ȏ�̔䗦�̔�r [ref. pp192]
    
    if(~isempty(E))
        disp('�����Ԃ̔�r���s���܂��B���͂��ꂽ���Ғl�iE�j�͎g���܂���B');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % ���Ғl  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % ��[4-1-21]
    p       = 1-chi2cdf(chi2,df);
    
elseif(all([nrow,ncol]==2))
    df  = 1;    % �Ή����Ȃ�2�����̔䗦�̔�r(2x2) [ref. pp183]
    
    if(~isempty(E))
        disp('�����Ԃ̔�r���s���܂��B���͂��ꂽ���Ғl�iE�j�͎g���܂���B');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % ���Ғl  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % ��[4-1-14]
%     chi2    = sum(sum((abs(x - E)-0.5).^2 ./ E));    % ��[4-1-14] +�C�F�[�c�̘A�����␳
    p       = 1-chi2cdf(chi2,df);
    
else
    l   = max(nrow,ncol);   % �J�e�S���[��
    df  = l-1;    % �Ή����Ȃ�2�����̔䗦�̔�r(2xl(l>=3)) [ref. pp186]
    
    if(~isempty(E))
        disp('�����Ԃ̔�r���s���܂��B���͂��ꂽ���Ғl�iE�j�͎g���܂���B');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % ���Ғl  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % ��[4-1-17]
    p       = 1-chi2cdf(chi2,df);
    
end



    % 
% if((sum(sum(E<5)) / nrow*ncol)>=0.2 || any(sum(E<1)))
%     disp('�T�����̊��Ғl���S�̂̂Q�O%�ȏ�ł���A�������͂P�����̊��Ғl���P�ł����邽�߁A�J�C��挟��͕s�K�ł��BFisher''s exact test���g���܂��B')
%     p   = fisherexacttest(x);
%     chi2    = [];
% else

    
    % end
