function d  = homepath

[s,homedrive]   = dos('set HOMEDRIVE');
ind             = strfind(homedrive,'=');
homedrive       = homedrive(ind+1:end-1);

[s,homepath]    = dos('set HOMEPATH');
ind             = strfind(homepath,'=');
homepath        = homepath(ind+1:end-1);

d       = [homedrive, homepath, '\'];
