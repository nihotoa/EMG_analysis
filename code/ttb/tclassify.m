function tclassify
d   =[
4105 
3672 
2778 
2458 
];
cutoff  = 150;

d   = shiftdim(d);
n   = length(d);
x   = repmat(d',n,1);
y   = repmat(d,1,n);

m   = (x-y);

t   = abs(m)<=cutoff;

tt  = unique(t,'rows');
nn  = size(tt,1);
ttt = tt;

for ii  =1:(nn-1)
    for jj  =ii+1:nn
        T1  = ttt(ii,:);
        T2  = ttt(jj,:);
        if(any(T1&T2))
            ttt(ii,:)  = (T1|T2);
            ttt(jj,:)  = ttt(ii,:);
        end
    end
end
ttt;
ttt = unique(ttt,'rows');
ttt = ttt([size(ttt,1):-1:1],:);

ind = [1:n];

for ii  =1:n
    c(ii)   = find(ttt(:,ii)==1);
end
c   = c'
    

% for ii  =1:size(ttt,1)
% %     keyboard
%     c{ii}   = ind(ttt(ii,:));
% end
% for ii  =length(c):-1:1
%     disp(c{ii})
% end