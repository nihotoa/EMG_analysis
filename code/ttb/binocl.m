function cl	= binocl(L,P,alpha)
% function cl	= binocl(L,P,alpha)

cl  = find((1-binocdf(1:L,L,P))<alpha,1);