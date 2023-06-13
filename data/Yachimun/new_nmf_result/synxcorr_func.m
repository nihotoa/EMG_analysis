
function [R,r_pre] = synxcorr_func(postHt,preHt,base)
S = size(preHt);
Ldpre = S(2);
S = size(postHt);
Ldpost = S(2);
R = cell(3,Ldpost);
    for syn = 4:4
        avepreHt = preHt{1,1};
        for ii = 1:Ldpre
            avepreHt = (avepreHt.*(ii-1) + preHt{1,ii})./ii;
        end
        if base =='H'
        r_pre = homemadexcorr2(4, avepreHt' ,avepreHt' );
        for l = 1:Ldpost
            R{syn-2,l} = homemadexcorr(syn,postHt{1,l}',avepreHt','all');
        end
        end
        
        if base =='W'
        r_pre = homemadexcorr2(4, avepreHt ,avepreHt );
        for l = 1:Ldpost
            R{syn-2,l} = homemadexcorr(syn,postHt{1,l},avepreHt,'all');
        end
        end
    end
    

end

function [ r ] = homemadexcorr(syn_num, x ,y,state )
% 
% x = []
% 
switch state
    case 'all'
        postsynsort = [2,1,4,3];
    case 'post'
        postsynsort = [1,2,4,3];
end
r = zeros(syn_num,syn_num);
for j = 1:syn_num
    for i = 1:syn_num
        x1 = x(:,postsynsort(j)) - mean(x(:,postsynsort(j)));
        y1 = y(:,i) - mean(y(:,i));
        
        r(i,j) = ( y1' * x1 )/(( (x1' * x1)*(y1' * y1)  )^(1/2));
%         rp() = r()
    end 
end

end

function [ r ] = homemadexcorr2(syn_num, x ,y )
% 
% x = []
% 
postsynsort = [1,2,3,4];
r = zeros(syn_num,syn_num);
for j = 1:syn_num
    for i = 1:syn_num
        x1 = x(:,postsynsort(j)) - mean(x(:,postsynsort(j)));
        y1 = y(:,i) - mean(y(:,i));
        
        r(i,j) = ( y1' * x1 )/(( (x1' * x1)*(y1' * y1)  )^(1/2));
%         rp() = r()
    end 
end

end
