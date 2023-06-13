function [p,chi2,df,E]    = chi2test(x,E)
% [p,chi2,df,E]    = chi2test(x,E)
% カイ二乗検定
% x: [n,m]の行列 基本的にnとmは転置しても何も影響しません。
% E(input): ｘがベクトルで、任意の適合度検定を行う場合に入力します。空の場合、「全ての条件の確率が等しい」という帰無仮説の検定を行います。 
%           Eは期待値（合計数がｘの合計数と一緒）でも、確率（例えば[0.25 0.25 0.25 0.25]）でも構いません。
% なお、イェーツの連続性補正を行いたい時は、プログラムのコメントアウトされているものを使ってください。（デフォルトでは使わない）
% 
% 例
% x=[72,23,16,49];
% E=[40 40 40 40];    % E=[1 1 1 1]; でも　E=[0.25 0.25 0.25 0.25];でも一緒です。
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
% ５未満の期待値が全体の２０%以上である、もしくは１未満の期待値が１つでもある場合、カイ二乗検定は不適です。
% Fisher's exact testの使用を検討してください。

if(nargin<2)
    E   = [];
end

[nrow,ncol] = size(x);

if(any([nrow,ncol]==1))
    df  = 1;    % 適合度検定 [ref. pp181]
    
    if(isempty(E))
        N   = sum(sum(x));      % 総数
        l   = max(nrow,ncol);   % カテゴリー数
        
        E   = ones(nrow,ncol) * N / l;    % 期待値
        disp('期待値が入力されていません。「帰無仮説：すべての条件の確率が等しい」の検定を行います');
    else
        if(~all(size(x)==size(E)))
            error('Size of x and E must be same.')
        end
        
        N   = sum(sum(x));      % 総数
        NE  = sum(sum(E));      % 期待値の総数
        
        E   = E ./ NE .* N;     % Eが確率の場合でも期待値に変換する。
        
    end
    
    chi2    = sum(sum((x - E).^2 ./ E));    % 式[4-1-8]
%     chi2    = sum(sum((abs(x - E)-0.5).^2 ./ E));    % 式[4-1-9] イェーツの連続性補正
    p       = 1-chi2cdf(chi2,df);
    
elseif(any([nrow,ncol]>=3))
    df  = (nrow-1)*(ncol-1);    % 対応がない3条件以上の比率の比較 [ref. pp192]
    
    if(~isempty(E))
        disp('条件間の比較を行います。入力された期待値（E）は使いません。');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % 期待値  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % 式[4-1-21]
    p       = 1-chi2cdf(chi2,df);
    
elseif(all([nrow,ncol]==2))
    df  = 1;    % 対応がない2条件の比率の比較(2x2) [ref. pp183]
    
    if(~isempty(E))
        disp('条件間の比較を行います。入力された期待値（E）は使いません。');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % 期待値  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % 式[4-1-14]
%     chi2    = sum(sum((abs(x - E)-0.5).^2 ./ E));    % 式[4-1-14] +イェーツの連続性補正
    p       = 1-chi2cdf(chi2,df);
    
else
    l   = max(nrow,ncol);   % カテゴリー数
    df  = l-1;    % 対応がない2条件の比率の比較(2xl(l>=3)) [ref. pp186]
    
    if(~isempty(E))
        disp('条件間の比較を行います。入力された期待値（E）は使いません。');
    end
    
    Nrow    = sum(x,2);
    Ncol    = sum(x,1);
    N       = sum(Nrow);
    E       = Nrow*Ncol / N;    % 期待値  
    
    chi2    = sum(sum((x - E).^2 ./ E));    % 式[4-1-17]
    p       = 1-chi2cdf(chi2,df);
    
end



    % 
% if((sum(sum(E<5)) / nrow*ncol)>=0.2 || any(sum(E<1)))
%     disp('５未満の期待値が全体の２０%以上である、もしくは１未満の期待値が１つでもあるため、カイ二乗検定は不適です。Fisher''s exact testを使います。')
%     p   = fisherexacttest(x);
%     chi2    = [];
% else

    
    % end
