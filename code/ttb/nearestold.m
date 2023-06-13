function [result, index] = nearest(vector, value)
% function [result, index] = NEAREST(vector, value)
% Returns the value in the vector that is nearest the value requested
% Values in the vector must be sorted in either descending or ascending order

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