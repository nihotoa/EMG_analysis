% function [Y,YY]  = MPISynergyCorrelation(X,C)

% X   = m x n matrix mCells n EMGs value = MPI
% C   = M x N matrix M number of synergies NEMGs value = Synergy coefficient
% Y   = m x M matrix m Cells M number of synergies value = R

% method  = 'Pearson';
% method  = 'Kendall';
% method  = 'Spearman';

[mm,nn] = size(X);
[MM,NN] = size(C);


Y   = nan(mm,MM);

for iX =1:mm
    for iC =1:MM
%                 Y(iX,iC)    = corr(X(iX,:)',C(iC,:)','type',method,'rows','complete');
%         Y(iX,iC)    = dot(X(iX,:),C(iC,:)) ./ sum(C(iC,:));
        Y(iX,iC)    = sum(X(iX,:)&C(iC,:)) ./ sum(X(iX,:)|C(iC,:));
%           Y(iX,iC)  = sum(X(iX,:)==C(iC,:)) ./ nn;  
    end
end

% Y2 = (Y.^2);
Y2 = Y;
maxY2   = max(Y2,[],2);

N=10000;
meanYY2  = nan(1,N);
for ii=1:N
XX  = nan(size(X));
for iX =1:nn
    XX(:,iX)    = X(randperm(mm),iX);
end

% for iX =1:mm
%     XX(iX,:)    = X(iX,randperm(nn));
% end


YY  = nan(mm,MM);

for iX =1:mm
    for iC =1:MM
%         YY(iX,iC)    = corr(XX(iX,:)',C(iC,:)','type',method,'rows','complete');
%         YY(iX,iC)    = dot(XX(iX,:),C(iC,:)) ./ sum(C(iC,:));
        YY(iX,iC)    = sum(XX(iX,:)&C(iC,:)) ./ sum(XX(iX,:)|C(iC,:));
%         YY(iX,iC)  = sum(XX(iX,:)==C(iC,:)) ./ nn;
    end
end

% YY2 = (YY.^2);
YY2 = YY;
maxYY2   = max(YY2,[],2);

meanYY2(ii) = mean(maxYY2);
end

[H,P]   = ttest2(maxY2,maxYY2)

