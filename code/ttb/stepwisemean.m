function [swmean, Y, order]  = stepwisemean(X,nperms)
% STEPWISEMEAN   配列のStep-wise法による平均値
%   
%   STEPWISEMEAN(X) は X の要素のStep-wiseに要素を増やした平均値を出力します。
%   X はベクトルでなくてはなりません。
%   
%   STEPWISEMEAN(X,N) は X を N回ランダムに並べ替えてStep-wise平均を求めます。
%   出力の行は N 回の並べ替えを、列はStep-wiseした個数を表します。
%   
%   [SWMEAN, Y, ORDER]  = STEPWISEMEAN(X,...)は、ORDERに並べ替えに用いたインデックスの配列を
%   YにORDERどおりに並べ替えたXの値を返します。
%   
%   
%   例:
%   
%     X = [0 1 2 3 4 5]
%  
%   の場合、
%   
%   [swmean,Y,order]  = stepwisemean(X) は
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
%   を返します。
%   
%   
%   [swmean,Y,order]  = stepwisemean(X,2)は、たとえば
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
%   を返します。
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

rand('state',0);% ランダムで選ぶけど、いつも同じセットが出るようにしているということ

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
