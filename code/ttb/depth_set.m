function C  = depth_set(D,cutoff)
% C  = depth_set(D,cutoff)

[maxD,maxI] = max(D);


downD   = D(1:maxI);
if(maxI<length(D))
    upD     = D(maxI+1:length(D));
else
    upD     = [];
end

downC       = makeset(downD,cutoff);
if(~isempty(upD))
    upC         = makeset(upD(end:-1:1),cutoff);
end

if(~isempty(upD))
    C           = [downC;upC+100];
else
    C           = downC;
end


function c  = makeset(d,cutoff)
d   = shiftdim(d);
n   = length(d);
c   = zeros(n,1);

[d,ind] = sort(d);  % 小さい順にソート　最後にsortrowsで戻す

kk  = 1;        %##set
A   = d(1);    % 基準値
for ii=1:n
    if(abs(A - d(ii))<=cutoff)
        c(ii) = kk;
    else
        kk  = kk + 1;   %##setの更新
        A   = d(ii);    %基準値の更新
        
        c(ii) = kk;
    end
end

c   = sortrows([c,ind],2);
c   = c(:,1);


% 
% d   = shiftdim(d);
% n   = length(d);
% x   = repmat(d',n,1);
% y   = repmat(d,1,n);
% 
% m   = (x-y);
% 
% t   = abs(m)<=cutoff;
% 
% tt  = unique(t,'rows');
% nn  = size(tt,1);
% ttt = tt;
% 
% for ii  =1:(nn-1)
%     for jj  =ii+1:nn
%         T1  = ttt(ii,:);
%         T2  = ttt(jj,:);
%         if(any(T1&T2))
%             ttt(ii,:)  = (T1|T2);
%             ttt(jj,:)  = ttt(ii,:);
%         end
%     end
% end
% ttt;
% ttt = unique(ttt,'rows');
% ttt = ttt([size(ttt,1):-1:1],:);
% 
% ind = [1:n];
% 
% for ii  =1:n
%     c(ii)   = find(ttt(:,ii)==1);
% end
% c   = c';