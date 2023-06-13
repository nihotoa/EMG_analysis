function channelnames   =getchanname(titlestring)
% channelnames   =getchanname(exp)

% written by TT 20100201

% if nargin < 1
    exp = gcme;
% end
% if(~strcmp(class(exp),'mdaobject'))
%     error('Input must be mdaobject')
% end

channelnames   = experiment(exp,'channelnames');
channelnames   = uiselect(channelnames,1,titlestring);

