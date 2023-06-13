function [y,c]=getmaxclust

a=getprop('maxclust','maxclustpeakmean','maxclustpeak','maxclustpeakfreq');

a=sortrowsxls(a,1);

disp(a{1,1})
n=length(a);
y=zeros(n,5);
c=cell(n,1);
for ii=1:n
    c(ii)   = a(ii);
    if(isempty(a{ii,2}));
        y(ii,:) = [0 0 0 0 0];
    else
        y(ii,:) = [a{ii,2},a{ii,3},a{ii,4},a{ii,5}];
    end
end