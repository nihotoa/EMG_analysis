function x  = bufferfcn(h,P,DIM,x,varargin)

N   = ceil((numel(x)+P)./20000*60*20);

x   = buffermtx(x,N,P,DIM);

nBuffer = size(x,2);

for iBuffer=1:nBuffer
    x(:,iBuffer,:)  = h(x,varargin{:});
end

x   =ibuffermtx(x,P,DIM);





