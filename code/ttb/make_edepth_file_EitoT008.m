function make_edepth_file_EitoT008

totaltime   = 14156;             %%%%%%
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
depth       = [ 250     500     2394;...
                1939    2474    4106;...
                3096    3105    4321;...
                3433    3487    4451;...
                3900    4078    4963;...
                4129    4995    5048;...
                5100    5500    5130;...
                5612    6857    5330;...
                7042    7180    5429;...
                7510    7724    5663;...
                8056    8216    6168;...
                8504    8540    6191;...
                8900    9397    4997;...
                9729    9927    4662;...
                10172   10513   4054;...
                10586   12830   3874;...
                12867   13892   3864];


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