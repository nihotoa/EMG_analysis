function y  = convert_electrode_depth(x)

[x,nshifts] = shiftdim(x);


% convert du -> um
y   = edepth(x);

% unwrap y
dy  = diff([0;y],1,1);
dy(dy>9000)     = dy(dy>9000) - 10000;
dy(dy<-9000)    = dy(dy<-9000) + 10000;
y   = cumsum(dy);

% smoothing y
y   = round(smoothing(y,999,@rectwin));

y   = shiftdim(y,-nshifts);


