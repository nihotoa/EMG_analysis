function [x,B]=integ(x,N)
% Nth order differentiation
%
% see also deriv
%
% written by Tomohiko Takei 20101230


B   = 1;

for ii=1:N
    B   = filter([1 -1],1,[B 0]);
end

A   = 1;

x   = filter(A,B,x);
