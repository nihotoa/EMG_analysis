function y  = optunwrap(x,a)

uwx = radrange(x,a);

y   = x;

y(nanstd(x,0,2)>nanstd(uwx,0,2),:)  = uwx(nanstd(x,0,2)>nanstd(uwx,0,2),:);


% if(nanstd(x)<=nanstd(uwx))
%     y   = x;
% else
%     y   = uwx;
% end