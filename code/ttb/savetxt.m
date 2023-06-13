function savetxt(fullfilename,X)

if(nargin<2)
    X   = fullfilename;
    
    fullfilename    = getconfig(mfilename,'fullfilename');
    if(~exist(fullfilename,'file'))
        fullfilename    = fullfile(pwd,'*.*');
    end
    [filename,pathname] = uiputfile(fullfilename);
    if(isequal(filename,0)||isequal(pathname,0))
        disp('User pressed cancel')
        return;
    end
    
    fullfilename        = fullfile(pathname,filename);
    
    setconfig(mfilename,'fullfilename',fullfilename);
end

X   = squeeze(X);
if(~iscell(X) || dimens(X)>2)
    error('X have to be 1 or 2 dimentional cell array.');
end


fid = fopen(fullfilename,'w');


[nrow,ncol] = size(X);
for irow=1:nrow
    for icol=1:ncol
        if(ischar(X{irow,icol}))
            fprintf(fid,'''%s''',X{irow,icol});
        elseif(isnumeric(X{irow,icol}))
            fprintf(fid,'%g',X{irow,icol});
        end
        if(icol==ncol)
            fprintf(fid,'\n');
       else
            fprintf(fid,'\t');
        end
    end
 end

fclose(fid);

disp(fullfilename)

end

function y  = dimens(x)

y   = size(x);
y   = sum(y>1);


end
    
    