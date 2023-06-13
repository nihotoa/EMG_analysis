function s	= woh2clssig(s)

% s   = topen;

% FFTpoints = 128
% 3   | 4   6  | 7    29  | 30   34  | 35   50  | 52   63   (Index)
% 3.9 | 5.9 9.8| 11.7 54.7| 56.6 64.5| 66.4 95.7| 99.6 121.1(Hz)
% 3   |4    7   |8     43   |44    52   |53    76   |77    80  (Index)
% 3.75|5.00 8.75|10.00 53.75|55.00 65.00|66.25 95.00|96.25 100 (Hz)

maxcluster_flag = 1;

chkcluster      = [4:43,53:76];
% FOI             = [12:99];
FOI             = [4:76];
HUM             = [44:52];

nnherz          = 10;    % 10Hz
kkherz          = 6.25;    % 6.25Hz

nnsec              = 0.24;   % 240ms
kksec              = 0.2;   % 200ms


cxy     = s.cxy;
freq    = s.freq;
t       = s.t;
cl      = s.cl.ch_c95;

dfreq   = freq(2)-freq(1);
dt      = t(2) - t(1);

ny      = round(nnherz/dfreq); 
ky      = round(kkherz/dfreq);
nnherz  = ny*dfreq;
kkherz  = ky*dfreq;

nx      = round(nnsec/dt); 
kx      = round(kksec/dt);
nnsec   = nx*dt;
kksec   = kx*dt;



FOImask = zeros(size(freq));
FOImask(FOI)    = ones(size(FOI));
HUMmask = zeros(size(freq));
HUMmask(HUM)    = ones(size(HUM));

sigcxy  = (cxy > cl);
clssig  = logical(zeros(size(sigcxy)));

for ii  = 1:size(sigcxy,2)
    sigInd  = sigcxy(:,ii)';
    clssig(:,ii)  = clustvec(sigInd,ky,ny,FOImask,HUMmask);
end
for ii  = 1:size(clssig,1)
    sigInd  = clssig(ii,:);
    % % % % % %         clssig(ii,:)  = clustvec(sigInd,kx(jj),nx(jj));
    clssig(ii,:)  = clustvec(sigInd,kx,nx);
end
for ii  = 1:size(sigcxy,2)
    sigInd  = clssig(:,ii)';
    clssig(:,ii)  = clustvec(sigInd,ky,ny,FOImask,HUMmask);
end


s.sig       = sigcxy;
s.clssig    = clssig;
s.nnherz    = nnherz;
s.kkherz    = kkherz;
s.nnsec     = nnsec;
s.kksec     = kksec;
s.FOI       = freq(FOI);
s.HUM       = freq(HUM);

% % % % % % end
isclust = 0;
if(maxcluster_flag==1)
    [nfreq,ntime] = size(clssig);

    maxclust = struct('first',[],'last',[],'n',[]);
    for(jj=1:ntime)
%         indicator(jj,ntime);
        clust = findclust(clssig(:,jj));
        if(~isempty(clust))
            [maxN,maxInd] = max([clust.last] - [clust.first]);
            maxclust(jj) = clust(maxInd);
            isclust = 1;
        else
            maxclust(jj) = struct('first',0,'last',0,'n',0);
        end
    end
%     keyboard
    if(isclust==1)
        [maxN,maxInd]       = max([maxclust.last] - [maxclust.first]);
        s.maxclust          = maxclust(maxInd);
        s.maxclust.first    = freq(s.maxclust.first);
        s.maxclust.last     = freq(s.maxclust.last);
        s.maxclust.n        = s.maxclust.last - s.maxclust.first;
        s.maxclust.t        = s.t(maxInd);
        s.isclust           = 1;
    else
        s.maxclust        = struct('first',[],'last',[],'n',[],'t',[]);
        s.isclust      = 0;
    end
end
% indicator(0,0);