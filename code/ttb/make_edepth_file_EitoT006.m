function make_edepth_file_EitoT006

totaltime   = 13412;             %%%%%%
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
depth       = [ 196     400     2287;...
                600     770     2666;...
                1639    3308    4115;...
                3405    3571    4285;...
                3704    3902    4306;...
                4195    4584    4463;...
                5220    6016    4764;...
                6300    6970    4824;...
                7230    8000    5113;...
                8056    8783    5256;...
                8962    9063    5410;...
                9200    9996    5617;...
                10428   11715   5418;...
                11923   13051   3851];


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