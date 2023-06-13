function make_edepth_file_EitoT015

totaltime   = 17081;             %%%%%%
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
depth       = [ 0       341     3626;...
                430     622     4113;...
                810     2474    4643;...
                2866    3047    5477;...
                3276    3476    5712;...
                3676    4245    6061;...
                4550    4750    6721;...
                5000    6313    7305;...
                6500    6626    7938;...
                7172    7396    7538;...
                7656    7759    6889;...
                7957    8464    6529;...
                8700    9833    6049;...
                9860    10057   6039;...
                10500   10740   4948;...
                11080   11380   4441;...
                12684   12684   1989];


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