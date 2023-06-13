function y  = timestamptime(ind)

if nargin<1
    ind_flag    = 0;
else
    ind_flag    = 1;
end

s   = topen;

dt      = 1/s.SampleRate;
stamps  = (s.Data) * dt;

if ind_flag == 0
    y   = stamps;
else
    y   = stamps(ind);
end

