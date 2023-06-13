function y  = buffermtx(x,N,P,DIM)
% BUFFER  信号ベクトルをデータフレーム行列にバッファリング
%  
%    Y = BUFFER(X,N) は、信号ベクトル X を長さ N の重ね合わせの無いデータ
%    セグメント (フレーム) に分割します。各データフレームは、行列出力 Y の 
%    1 つの列に対応し、最終的に N 行になります。
%  
%    Y = BUFFER(X,N,P) は、整数 P によって、出力行列の中で P サンプルオーバ
%    ラップさせるか、アンダラップさせるかを指定できます。
%    - P>0 の場合 (オーバラップ)、buffer は、一つのフレーム (列) に関して、
%      その最後の P サンプルを、つぎのフレームの最初の P サンプルとして、
%      同じものを繰り返して使います。
%    - P<0 の場合 (アンダラップ)、buffer は、一つのフレームの最後の要素から 
%      P サンプル分スキップしたものが、つぎのフレームの最初の要素になります。
%      これにより、バッファのフレームレートを減らします。
%    - P を省略した場合、P = 0 と仮定され、オーバラップやアンダラップを
%      適用しません。
%  
%    Y = BUFFER(X,N,P,OPT) は、オプションパラメータ OPT によって、オーバラップ
%    してバッファリングさせるか、アンダラップしてバッファリングさせるかを指定
%    できます。
%    - P>0 の場合 (オーバラップ)、OPT は長さ P (オーバラップさせる量と同じ長さ) 
%      の初期条件ベクトルを指定します。OPT を省略すると、初期条件は、zeros(P,1) 
%      になります。また、OPT に 'nodelay' を設定すると、初期条件をスキップして、
%      X の最初のサンプルデータ (X(1)) からバッファリングが始まります。
%    - P<0 の場合 (アンダラップ)、 OPT は、データ X の中でスキップする初期
%      データサンプルを示すスカラのオフセットです。このオフセットは、[0, -P] 
%      (P<0) の範囲に入ります。OPT が空行列か省略した場 合、オフセットは 0 です。
%  
%    Y = BUFFER(X, ...) は、一つの列に対応したデータフレームの行列を返します。
%    X のサンプルが (N-P) の倍数でない場合は、最後のフレームに 0 が付加されます。
%  
%    [Y,Z] = BUFFER(X, ...) は、Y にフル状態になったフレームのみを返します。
%    また、Z には残りのサンプル (一部のフレーム) が返されます。この際、出力 
%    Z の方向は、X と同じ方向 (列方向または行方向) になります。従って、X の
%    長さが (N-P) の倍数の場合、Z は空ベクトルになります。
%  
%    [Y,Z,OPT] = BUFFER(X, ...) は、オプション引数 OPT にオーバラッピングした
%    バッファの最後の P サンプルを返します。また、連続バッファリングでは常に
%    設定されます。
%  
%  
%    例:オーバラップによるバッファリング。
%        信号ベクトル X を長さ 8 のサンプルフレームに分割し、各フレームを 
%        4 サンプル毎オーバラップさせます。
%  
%        x = 01:18:00;                 % バッファリングする入力データ
%        y = buffer(x, 8, 4);      %オーバラップバッファ行列の算出
%  
%    例:アンダラップによるバッファリング。
%        信号ベクトル X を長さ 8 のサンプルフレームに分割し、各フレームを 
%        4 サンプル毎スキップします。部分的なバッファを別々に返します。
%  
%        x = 1:40;                 % バッファリングする入力データ
%        [y,z] = buffer(x, 8, -4);   % 最後のフレーム z の算出

% 20090203 written by TT       
       
if(nargin<4)
    DIM = [];
end

if(isempty(DIM))
    DIM = 1;
end


if(DIM==2)
    x   = x';
end

[nrow,ncol] = size(x);

for icol=1:ncol
    if(icol==1)
        y   = zeros([size(buffer(x(:,icol),N,P)),ncol]);
    end
    y(:,:,icol) = buffer(x(:,icol),N,P);
end

% if(DIM==2)
%     y   = y';
% end


