function Y  = getuserdata(h)
% Y  = getuserdata(h)
% h   : object ID
% Y   : userdata of h

Y   = [];
try
    Y   = get(h,'UserData');
catch
    error('Input is not object ID')
    Y   = [];
end