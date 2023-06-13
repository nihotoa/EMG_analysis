function mtx    = sortmtx(mtx,index,DIM)
if nargin<3
    DIM =[];
end

logical_flag    = islogical(mtx);
index = shiftdim(index-min(index)+1);

if(isempty(DIM))    % �s���������
    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end)';

    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end)';

elseif(DIM==1)  % �s��ێ����ė�����ɐ���
    mtx = sortrows([index,mtx],1);
    mtx = mtx(:,2:end);

elseif(DIM==2)  % ���ێ����čs�����ɐ���
    mtx = sortrows([index,mtx'],1);
    mtx = mtx(:,2:end)';
end

if(logical_flag)
    mtx = logical(mtx);
end

    
