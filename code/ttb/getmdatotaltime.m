function Y   =getmdatotaltime(exp)
% totaltime   =getmdatotaltime(exp)

% written by TT 20100201

if nargin < 1
    exp = gcme;
end
if(~strcmp(class(exp),'mdaobject'))
    error('Input must be mdaobject')
end

Y   = get(exp,'TotalTime');
