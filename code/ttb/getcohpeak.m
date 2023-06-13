function y=getcohpeak

a=getprop('maxclust');

a=sortrowsxls(a,1);

n=length(a);
y=zeros(n,2);
for ii=1:n
    
    if(isempty(a{ii,2}));
        y(ii,:) = [0 0];
    else
        y(ii,:) = a{ii,2};
    end
end