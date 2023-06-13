function    cohcl   = cohinv2(P,L)
% cohcl   = cohinv(P,L)
% input
%     P   probability ex 0.95
%     L   vector of number of disjoint segments ex [257 100 76]
% 
% Written by TT

dec     = 4;
nL  =length(L);

if(nL<2)
    c       =[0:10^(-dec):1];
    cnvpdf  =((L-1)*power(1-c,L-2));
    %     cnvpdf  =[0 diff(cnvcdf)];

else
    c       =[0:10^(-dec):1];
    cnvpdf  =((L(1)-1)*power(1-c,L(1)-2));
    %     cnvpdf  = [0 0.5 0.3 0.2 0 0 0 0 0 0 0];
    for ii=2:nL
        cpdf  =((L(ii)-1)*power(1-c,L(ii)-2));
        cnvpdf  = conv(cnvpdf,cpdf);
        indicator(ii,nL)
    end
    %     keyboard
end
% [cnvc(1:10);cnvcdf(1:10)]'
    sump    = sum(cnvpdf);
    cnvcdf  = cumsum(cnvpdf/sump);
    cnvc    = linspace(0,1,length(cnvcdf));

% cnvcdf  = round(cnvcdf*(10^dec))/(10^dec);
ind     = find(cnvcdf > P, 1, 'first');
disp(cnvcdf(ind))
cohcl   = cnvc(ind);