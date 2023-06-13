function Y  = isihist(Ref, bw, nonzero_flag)

% Y  = isihist(Ref, bw[, nonzero_flag])
% nonzero_flag = 1 ->　ISI=0のデータは排除する。

if(nargin < 3)
    nonzero_flag    = 0;
end

Data    = diff(Ref.Data)./Ref.SampleRate;

if(nonzero_flag)
    Data    = Data(Data~=0);
end
BinEdges    = 0:bw:max(Data);
BinEdges    = [BinEdges,BinEdges(end)+bw];

XData   = bw./2 + bw.*((1:(length(BinEdges)-1))-1);
YData   = histc(Data,BinEdges);

Y.Name          = ['ISIHIST (',Ref.Name,')'];
Y.ReferenceName = Ref.Name;
Y.AnalysisType  = 'ISIHIST';
Y.ISIData       = Data;
Y.nonzero_flag  = nonzero_flag;
Y.XData         = XData;
Y.YData         = YData(1:(end-1));
Y.nData         = sum(YData);
Y.PData         = Y.YData ./ Y.nData;
Y.CData         = cumsum(Y.YData)./Y.nData;
Y.BinEdges      = BinEdges;
Y.BinWidth      = bw;



end