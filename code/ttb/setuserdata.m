function setuserdata(h,Y)
% setuserdata(h,Y)
% h   : object ID
% Y   : userdata put into h

try
    set(h,'UserData',Y);
catch
    error('UserData was not correctly set.')
end