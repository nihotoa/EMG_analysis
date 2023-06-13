function    cl  = tcl(alpha,L,dec)
nL  =length(L);

if(nL<2)
    cl      = 1 - power(alpha,1/(L-1));

else
    %     c       =[0:10^(-dec):1];
    %     cnvcdf    =betainc(c,1,L(1)-1);
    %     cnvpdf  =[0 diff(cnvcdf)];
    c       = [0:0.1:1];
    cnvpdf  = [0 0.5 0.3 0.2 0 0 0 0 0 0 0];
    for ii=2:nL
%         ccdf    = betainc(c,1,L(ii)-1);
%         cpdf    = [0 diff(ccdf)];
        cpdf    = [0 0.5 0.3 0.2 0 0 0 0 0 0 0];
        
        cnvpdf  = conv(cnvpdf,cpdf);
%         cnvcdf  = cumsum(cnvpdf);
%         cnvc    = linspace(0,1,length(cnvcdf));
        
%         cnvcdf  = cnvcdf([1:2:length(cnvcdf)]);
%         keyboard




    end
    cnvcdf  = cumsum(cnvpdf);
    cnvc    = linspace(0,1,length(cnvcdf));
    keyboard
end
