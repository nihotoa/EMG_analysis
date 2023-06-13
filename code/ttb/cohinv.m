function    cohcl   = cohinv(P,L)
% cohcl   = cohinv(P,L)
% input
%     P   probability ex 0.95
%     L   vector of number of disjoint segments ex [257 100 76]
% 
% Written by TT

dec     = 4;
nL  =length(L);

if(nL<2)
    cnvc    =[0:10^(-dec):1];
    cnvcdf  =betainc(cnvc,1,L(1)-1);
    %     cnvpdf  =[0 diff(cnvcdf)];

else
    c       =[0:10^(-dec):1];
    cnvcdf    =betainc(c,1,L(1)-1);
    cnvpdf  =[0 diff(cnvcdf)];
    %     cnvpdf  = [0 0.5 0.3 0.2 0 0 0 0 0 0 0];

    for ii=2:nL
        ccdf    = betainc(c,1,L(ii)-1);
        cpdf    = [0 diff(ccdf)];
        %     cpdf    = [0 0.5 0.3 0.2 0 0 0 0 0 0 0];

        cnvpdf  = conv(cnvpdf,cpdf);
        cnvcdf  = cumsum(cnvpdf);
        cnvcdf  = cnvcdf(1:2:length(cnvcdf));
        cnvpdf  =[0 diff(cnvcdf)];
        %         keyboard
    end
    cnvcdf  = cumsum(cnvpdf);
    cnvc    = linspace(0,1,length(cnvcdf));
    %     keyboard
end
% [cnvc(1:10);cnvcdf(1:10)]'
cnvcdf  = round(cnvcdf*(10^dec))/(10^dec);
ind     = find(cnvcdf > P, 1, 'first');
cnvcdf(ind);
cohcl   = cnvc(ind);