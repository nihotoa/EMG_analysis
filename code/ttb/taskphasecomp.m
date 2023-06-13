trest    = [32 :131];
tgrip    = [232:331];
thold    = [607:706];

band1   = [8:12];
band2   = [13:32];
band3   = [53:63];

load('avewcoh_narrow');

% aveacxy(:,1)    = mean(acxy(:,rest),2);
% aveacxy(:,2)    = mean(acxy(:,grip),2);
% aveacxy(:,3)    = mean(acxy(:,hold),2);
% aveacxy(:,1)    = mean(acxy(:,rest),2);
% aveacxy(:,2)    = mean(acxy(:,grip),2);
% aveacxy(:,3)    = mean(acxy(:,hold),2);

% band1pcxy(:,1)    = mean(mean(allpcxy(band1,rest,:),1),2);
% band1pcxy(:,2)    = mean(mean(allpcxy(band1,grip,:),1),2);
% band1pcxy(:,3)    = mean(mean(allpcxy(band1,hold,:),1),2);
% 
% band2pcxy(:,1)    = mean(mean(allpcxy(band2,rest,:),1),2);
% band2pcxy(:,2)    = mean(mean(allpcxy(band2,grip,:),1),2);
% band2pcxy(:,3)    = mean(mean(allpcxy(band2,hold,:),1),2);
% 
% band3pcxy(:,1)    = mean(mean(allpcxy(band3,rest,:),1),2);
% band3pcxy(:,2)    = mean(mean(allpcxy(band3,grip,:),1),2);
% band3pcxy(:,3)    = mean(mean(allpcxy(band3,hold,:),1),2);
% 
% band1zcxy(:,1)    = mean(mean(allzcxy(band1,rest,:),1),2);
% band1zcxy(:,2)    = mean(mean(allzcxy(band1,grip,:),1),2);
% band1zcxy(:,3)    = mean(mean(allzcxy(band1,hold,:),1),2);
% 
% band2zcxy(:,1)    = mean(mean(allzcxy(band2,rest,:),1),2);
% band2zcxy(:,2)    = mean(mean(allzcxy(band2,grip,:),1),2);
% band2zcxy(:,3)    = mean(mean(allzcxy(band2,hold,:),1),2);
% 
% band3zcxy(:,1)    = mean(mean(allzcxy(band3,rest,:),1),2);
% band3zcxy(:,2)    = mean(mean(allzcxy(band3,grip,:),1),2);
% band3zcxy(:,3)    = mean(mean(allzcxy(band3,hold,:),1),2);
% 

% figure
% bar(avepcxy)
% title('avepcxy 10-15Hz')
% 
% avepcxy(1)    = mean(mean(pcxy(band2,rest),2));
% avepcxy(2)    = mean(mean(pcxy(band2,grip),2));
% avepcxy(3)    = mean(mean(pcxy(band2,hold),2));
% figure
% bar(avepcxy)
% title('avepcxy 16.5-40Hz')
% 
% 

% avezcxy(:,1)    = mean(zcxy(:,rest),2);
% avezcxy(:,2)    = mean(zcxy(:,grip),2);
% avezcxy(:,3)    = mean(zcxy(:,hold),2);

% figure
% plot([freq;freq;freq]',aveacxy)
% title('aveacxy')
% 
% figure
% plot([freq;freq;freq]',avepcxy)
% title('avepcxy')
% 
% figure
% plot([freq;freq;freq]',avezcxy)
% title('aveazxy')
% 
