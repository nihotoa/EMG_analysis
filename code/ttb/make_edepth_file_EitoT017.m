function make_edepth_file_EitoT017

totaltime   = 13591;             %%%%%%
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
depth       = [ 0       2211    4343;...
                2318    3101    4716;...
                3660    3872    5739;...
                5167    5600    6611;...
                5690    6220    6745;...
                6237    7150    6790;...
                7213    7451    6894;...
                7582    7708    7251;...
                7816    8588    7286;...
                8677    8687    7300;...
                8890    9120    7803;...
                9240    9472    8166;...
                10223   10292   6816;...
                10488   10992   6312;...
                11102   11331   5677;...
                11492   13000   5138];


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