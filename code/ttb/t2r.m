function R  =t2r(T,N)
% convert t score to correlation coefficient
% R  =t2r(T,N)
% 
% Reference:
% 心理学のためのデータ解析テクニカルブック　p224


[T,nshift] = shiftdim(T);

R   = sqrt((T.^2)/(T.^2+N-2));

R = shiftdim(R,-nshift);

% EOF