function    cohcdf  = cohcdf(coh,L)
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
deltac  = cnvc(2) - cnvc(1);
coh     = round(coh / deltac) * deltac;
[y,ind] = min(abs(cnvc - coh));
cohcdf  = cnvcdf(ind);