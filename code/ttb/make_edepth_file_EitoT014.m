function make_edepth_file_EitoT014

totaltime   = 13650;             %%%%%%
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
depth       = [ 69      141     3239;...
                1460    2109    4505;...
                2960    3910    6047;...
                4200    4965    6057;...
                6129    6385    7334;...
                6460    6687    7176;...
                7085    7276    6392;...
                7763    8509    5702;...
                8800    9406    5374;...
                9553    9814    5185;...
                10131   10170   5150;...
                10181   10227   5210;...
                10410   10973   4997;...
                11191   12751   4394;...
                13076   13122   3635];


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