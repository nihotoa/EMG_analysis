function make_edepth_file_EitoT001

totaltime   = 3278;             %%%%%%
Expname     = 'EitoT001';       %%%%%%
outfile     = fullfile(matpath,'Eito','Spinal All',Expname);

if(~exist(outfile))
    mkdir(outfile)
end

outfile     = fullfile(outfile,'Electrode Depth(um)');
TimeRange   = [0 totaltime];
Name        ='Electrode Depth';
Class       ='continuous channel';
SampleRate  = 1000;
XData       = (([1:totaltime*SampleRate]-1)/SampleRate);

Inpth      = 0; %Interpolation_threshold

Data       = zeros(size(XData));
%               time(1) time(2)	depth
depth       = [ 0       450     3634;...
    715     799     4650;...
    1050    1227    4750;...
    1290    1493    4660;...
    2000    2027    4770;...
    2089    2309    4915;...
    2442    3116    4930;...
    5187    5187    3273];


ndepth = size(depth,1);
for ii=1:ndepth
    Data(XData>=depth(ii,1)&XData<depth(ii,2))    = depth(ii,3);
end

for ii=1:ndepth-1
    if(abs(depth(ii,3)-depth(ii+1,3))<=Inpth)
        n      = sum(XData>=depth(ii,2)&XData<depth(ii+1,1));
        Data(XData>=depth(ii,2)&XData<depth(ii+1,1))    = linspace(depth(ii,3),depth(ii+1,3),n);
    end
end
%  keyboard
save(outfile,'TimeRange','Name','Class','SampleRate','Data');