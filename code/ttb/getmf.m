function Y  = getmf(S,psename)

if(nargin<2)
    psename = fieldnames(S);
    psename = psename(strmatch('pse',psename));
    psename = psename{1};
end

Y   = zeros(size(S.EMGName));

Y(S.(psename).isPSF==1) = 1;
Y(S.(psename).isPSS==1) = 2;
Y(S.(psename).isSF==1)  = 3;
Y(S.(psename).isSS==1)  = 4;
