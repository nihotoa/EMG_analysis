function make_edepth_file_EitoT002

totaltime   = 10147;
outfile     = fullfile(matpath,'EitoT002','Electrode Depth(um)');

TimeRange   = [0 totaltime];
Name        ='Electrode Depth';
Class       ='continuous channel';
SampleRate  = 1000;
XData       = (([1:totaltime*SampleRate]-1)/SampleRate);

Inpth      = 1500; %Interpolation_threshold

Data       = zeros(size(XData));
%               time(1) time(2)	depth
depth       = [ 0       100     2205;...
                335     473     3010;...
                800     958     4080;...
                1250    1796    4798;...
                1834    2215    5048;...
                2215    2400    5036;...
                2550    2600    5091;...
                2754    2800    5532;...
                2910    3157    5637;...
                3831    3919    5481;...
                4030    4301    5115;...
                4350    4394    5110;...
                4540    5038    4980;...
                5145    5197    4845;...
                5329    5403    4540;...
                5599    6019    4230;...
                6033    6380    4220;...
                6450    7213    3940;...
                7341    7763    3681;...
                7763    8163    3668;...
                8163    9530    3666];
            

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