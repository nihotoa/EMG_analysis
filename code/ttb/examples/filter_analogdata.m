S=topen;
XData=((1:length(S.Data))-1)/S.SampleRate;
fig    = figure;
h     = nan(1,6);


h(1)   = subplot(6,1,1,'parent',fig);
plot(h(1),XData,S.Data); title(h(1),S.Name)


%highpass filtering
S   = makeContinuousChannel([S.Name,'-hp30Hz'],'butter',S,'high',2,30);
h(2)    = subplot(6,1,2,'parent',fig);
plot(h(2),XData,S.Data); title(h(2),S.Name)

%rectify
S  = makeContinuousChannel([S.Name,'-rect'],'rectify',S);
h(3)    = subplot(6,1,3,'parent',fig);
plot(h(3),XData,S.Data); title(h(3),S.Name)


%lowpass filtering
S  = makeContinuousChannel([S.Name,'-lp20Hz'], 'butter', S, 'low',2,20);
h(4)    = subplot(6,1,4,'parent',fig);
plot(h(4),XData,S.Data); title(h(4),S.Name)


% linear smoothing 100ms 100Hz version
S  = makeContinuousChannel([S.Name,'-ls100ms'],'linear smoothing',S,0.1);
h(5)    = subplot(6,1,5,'parent',fig);
plot(h(5),XData,S.Data); title(h(5),S.Name)


% downsampling
S  = makeContinuousChannel([S.Name,'-ds100Hz'], 'resample', S, 100,0);
XData=((1:length(S.Data))-1)/S.SampleRate;
h(6)    = subplot(6,1,6,'parent',fig);
plot(h(6),XData,S.Data); title(h(6),S.Name)

linkaxes(h,'xy')

%             save(fullfile(pathname,[Y3.Name,'.mat']),'-struct','Y3');disp(fullfile(pathname,Y3.Name));

