function make_edepth_file_EitoT018

totaltime   = 9527;             %%%%%%
Expname     = mfilename;
Expname     = Expname(end-7:end);
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
%               time(1) time(2)	depth       %%%%%%
depth       = [ 1153    1552    7142;...
                2581    3274    9177;...
                3543    5162    9062;...
                6483    6967    8987;...
                7219    7486    7702;...
                8052    8315    6604;...
                8359    8455    6504;...
                8629    8690    6459];


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
disp([outfile,' was created.'])