function varargout  = sortrowsxls(X,col)
%   SORTXLS   昇順または降順にソート
%   
%   ベクトルの場合、SORTXLS(X) は、X の要素を昇順にソートします。
%   行列の場合、SORTXLS(X) は、X の各列単位に、要素の小さいものからソート
%   します。
%   N-次元配列の場合、SORTXLS(X) は、次元が1でない最初の次元に対して、ソート
%   します。X が文字のセル配列の場合、SORTXLS(X) は、Excelの「並べ替え」と同じ順番
%   に文字をソートします。
%  
%   Y = SORTXLS(X,DIM,MODE) は、2つのオプションのパラメータをもちます。
%   DIM は、ソートのための次元を選択します。
%   MODE は、ソートの方向を選択します。
%        'ascend' は、昇順になります。
%        'descend' は、降順になります。
%   結果は、Y になり、X と同じ形式とタイプをもちます。
%  
%   [Y,I] = SORTXLS(X,DIM,MODE) は、インデックス行列 I も出力します。
%   X がベクトルの場合、Y = X(I) となります。
%   X が m 行 n 列の行列で DIM=1 の場合、
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end 
%   となります。
%  
%   X が複素数の場合、要素は ABS(X) でソートされます。一致する値については、
%   さらに ANGLE(X) を使ってソートされます。
%  
%   同じ値が複数存在する場合、オリジナルの要素の順番が、ソートされた結果に
%   も反映され、同じ値の要素のインデックスが、インデックス行列の中に昇順に
%   出力されます。
%  
%   例題： X = [3 7 5
%               0 4 2] の場合、
%  
%   sort(X,1) は、[0 4 2  になり、sort(X,2) は、[3 5 7  になります。
%                  3 7 5]                        0 2 4] 
%  
%   参考 issorted, sortrows, min, max, mean, median
% 
%     その他のディレクトリにある同じ名前のオオーバーロードされた関数、またはメソッド
%        help cell/sort.m
% 
%     参照ページはHelp browserにあります
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


