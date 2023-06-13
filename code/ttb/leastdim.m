function ind    =leastdim(x)

dims    = size(x);

ind     = find(dims>1,1,'first');