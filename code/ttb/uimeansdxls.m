function Y  = uimeansdxls(ndecimals)

if(nargin<1)
    ndecimals   = 1;
end

xlsload(-1,'Data')


m   = mean(Data);
s   = std(Data);

format  = ['%.',num2str(ndecimals),'f'];
Y   = [num2str(m,format),'}',num2str(s,format)];