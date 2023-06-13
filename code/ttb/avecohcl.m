function cl = avecohcl(alpha,L)
%function [signif,X,pp]=avecohcl(alpha,L)
%L is a vector of the number of sections in each coherence which enters the
%average calculation
%alpha is the desired P value (e.g. 0.05)
%signif will return the significance limit for the averaged coherence
%X and pp are optional return arguments to give the full distribution of
%the averaged coherence

nL      = length(L);

ncohVec = 10000;
cohVec  = linspace(0,1,ncohVec+1);
cohVec(1)   = [];

pdf1   = cohpdf(cohVec,L(1));

for iL  = 2:nL
    pdf2    = cohpdf(cohVec,L(iL));
    pdf1    = conv(pdf1,pdf2);      % length‚Í ncohVec*2-1
    pdf1    = downsamplepdf(pdf1);  % length‚Í ncohVec
end

cdf = cumsum(pdf1);

ind = find(cdf>=(1-alpha),1,'first');

cl  = cohVec(ind);
end


function pdf    = cohpdf(cohVec,L)

cdf = 1 - cohclinv(cohVec,L);
pdf = [cdf(1),diff(cdf)];
end

function pdf2   = downsamplepdf(pdf1)

npdf1   = length(pdf1);
pdf2    = zeros(1,(npdf1+1)/2);
pdf2(1) = pdf1(1);
pdf2(2:end) = pdf1(2:2:end-1) + pdf1(3:2:end);
end