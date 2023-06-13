
% disp(num2str(a))

for ii  =1:100
    a   = floor(rand(1,3)*9);
    st   = 0;
bo   = 0;
jj  = 0;

while (~bo)
    jj  = jj+1;
    b   = floor(rand(1,3)*9);
%     disp([num2str(jj),': ',num2str(b)])
    bo  = (all(b==a([1,2,3]))|all(b==a([1,3,2]))|all(b==a([2,1,3]))|all(b==a([2,3,1]))|all(b==a([3,1,2]))|all(b==a([3,2,1])));
    st  = all(b==a([1,2,3]));
    
end
trials(ii,1)  = jj;
trials(ii,2)  = double(bo);
trials(ii,3)  = double(st);

end
        
    