function mtx    = sortmtx(mtx,index,DIM)
if nargin<3
    DIM =[];
end

logical_flag    = islogical(mtx);
index = shiftdim(index-min(index)+1);

if(isempty(DIM))    % s‚à—ñ‚à®—ñ
    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end)';

    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end)';

elseif(DIM==1)  % s‚ð•ÛŽ‚µ‚Ä—ñ•ûŒü‚É®—ñ
    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end);

elseif(DIM==2)  % —ñ‚ð•ÛŽ‚µ‚Äs•ûŒü‚É®—ñ
    mtx = sortrows([index,mtx'],1);
    mtx = mtx(:,2:end)';
end

if(logical_flag)
    mtx = logical(mtx);
end

    
