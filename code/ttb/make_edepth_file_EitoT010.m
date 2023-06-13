function make_edepth_file_EitoT010

totaltime   = 14559;             %%%%%%
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
depth       = [ 250     1301    3309;...
                1777    2077    4627;...
                2311    3370    5336;...
                3977    5124    5712;...
                5571    6428    6235;...
                6700    7905    6577;...
                8100    8642    6691;...
                8800    9134    6949;...
                9273    9522    7294;...
                9760    9989    7339;...
                10040   10339   7424;...
                10462   10691   7543;...
                10919   11388   6843;...
                11715   11828   5544;...
                12048   12690   5134;...
                12972   13687   4639;...
                13884   14234   4270];


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