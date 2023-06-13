function [result, index] = nearest(vector, values)
% function [result, index] = NEAREST(vector, values)
% Returns the value in the vector that is nearest the values requested
% Values in the vector must be sorted in either descending or ascending order


if numel(values)==1
    [result,index]  = local_nearest(vector,values);
else
    [m,n]   = size(values);
    values  = reshape(values,m*n,1);
    result  = nan(m*n,1);
    index   = nan(m*n,1);
    
    for ii=1:m*n
        [result(ii),index(ii)]  = local_nearest(vector,values(ii));
        indicator(ii,m*n)
    end
    result  = reshape(result,m,n);
    index   = reshape(index,m,n);

end

end

function [result,index]  = local_nearest(vector,value)

result = [];
index = [];
if isempty(vector) || isempty(value)
   return
end

if length(vector) == 1
   result = vector;
   index = 1;
   return
end

if vector(end) > vector(1)
   if value > vector(end)
      result = vector(end);
      index = length(vector);
      return
   end
   
   if value < vector(1)
      result = vector(1);
      index = 1;
      return
   end
else
   if value < vector(end)
      result = vector(end);
      index = length(vector);
      return
   end
   
   if value > vector(1)
      result = vector(1);
      index = 1;
      return
   end
end


[lnValue, index] = min(abs(vector - value));
result = vector(index);
end


% 
% [m,n]   = size(values);
% values  = reshape(values,m*n,1);
% [vector,nshifts]    = shiftdim(vector);
% vector  = vector';
% 
% edges   = conv2(vector,[0.5 0.5],'same');
% edges(end)  = inf;
% edges   = [-inf, edges];
% 
% [temp,index]    = histc(values,edges);
% 
% 
% 
% % [InValue,index]     = min(abs(repmat(vector,m*n,1)-repmat(values,1,length(vector))),[],2);
% result  = reshape(vector(index),m,n);
% index   = reshape(index,m,n);
% 
% 
% 
% % [m,n]   = size(values);
% % values  = reshape(values,m*n,1);
% % 
% % [vector,nshifts]    = shiftdim(vector);
% % vector  = vector';
% % 
% % [InValue,index]     = min(abs(repmat(vector,m*n,1)-repmat(values,1,length(vector))),[],2);
% % result  = reshape(vector(index),m,n);
% % index   = reshape(index,m,n);