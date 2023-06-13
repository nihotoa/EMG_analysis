function [ext,body] = extension(string)
try
    if(class(string)~='char')
        disp('error: not char')
        return;
    else
        ext     = string(strfind(string,'.')+1:length(string));
        body    = string(1:strfind(string,'.')-1);
    end
catch
    warning('Input must be *.*')
    ext     = [];
    body    = [];
end
