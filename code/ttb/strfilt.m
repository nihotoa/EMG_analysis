function strs	= strfilt(strs,filtstr)

% strs	= strfilt(strs,filtstr)
% 
% 入力文字列から条件となる文字列を含む文字列のみを取り出す
% strs：入力文字列
% filtstr：条件となる文字列




if(isempty(filtstr))
    strs    = strs;
    return
end
    

filtstr = deblank(filtstr);
ii  =0;
while(any(filtstr))
    ii  = ii+1;
    [filts{ii},filtstr]  = strtok(filtstr);
end


if ischar(filts)
    filt    = filts;
    if(strcmp(filt(1),'~'))
        if(length(filt)~=1)
            ind = strfind(strs,filt(2:end));

            kk  = 0;
            S   = [];
            for ii=1:length(strs)
                if(isempty(ind{ii}))
                    kk  = kk + 1;
                    S{kk}   = strs{ii};
                end
            end
            strs    = S;
        else
            strs    = strs;
        end
    else

        ind = strfind(strs,filt);

        kk  = 0;
        S   = [];
        for ii=1:length(strs)
            if(~isempty(ind{ii}))
                kk  = kk + 1;
                S{kk}   = strs{ii};
            end
        end
        strs    = S;
    end

elseif iscell(filts)
    nfilt   = length(filts);

    for jj=1:nfilt
        filt    = filts{jj};
        if(strcmp(filt(1),'~'))
            if(length(filt)~=1)
                ind = strfind(strs,filt(2:end));

                kk  = 0;
                S   = [];
                for ii=1:length(strs)
                    if(isempty(ind{ii}))
                        kk  = kk + 1;
                        S{kk}   = strs{ii};
                    end
                end
                strs    = S;
            else
                strs    = strs;
            end
        else

            ind = strfind(strs,filt);

            kk  = 0;
            S   = [];
            for ii=1:length(strs)
                if(~isempty(ind{ii}))
                    kk  = kk + 1;
                    S{kk}   = strs{ii};
                end
            end
            strs    = S;
        end
    end

end