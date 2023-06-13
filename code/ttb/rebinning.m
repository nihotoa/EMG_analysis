function [result, index] = rebinning(vector, values)


 [m,n]   = size(values);
values  = reshape(values,m*n,1);
[vector,nshifts]    = shiftdim(vector);
vector  = vector';

edges   = conv2([-inf vector inf],[0.5 0.5],'same');

[temp,index]    = histc(values,edges);


result  = reshape(vector(index),m,n);
index   = reshape(index,m,n);