function trenamefile
%            path                                                source      distination
files={'M:\tkitom\MDAdata\mat\Eito\Cortex Unit\EitoC04408','MSD 1-2.mat','tSpike.mat';...
'M:\tkitom\MDAdata\mat\Eito\Cortex Unit\EitoC04409','MSD 1-1.mat','tSpike.mat';...
'M:\tkitom\MDAdata\mat\Eito\Cortex Unit\EitoC04410','MSD 1-2.mat','tSpike.mat'};



nfiles  = size(files,1);

disp(num2str(nfiles))


for ii=1:nfiles
    S       = load(fullfile(files{ii,1},files{ii,2}));
    S.Name  = files{ii,3}(1:end-4);
    save(fullfile(files{ii,1},files{ii,3}),'-struct','S');
%     copyfile(fullfile(files{ii,1},files{ii,2}),fullfile(files{ii,1},files{ii,3}),'f');
    indicator(ii,nfiles)
end
% disp([num2str(n),' out of ',num2str(nfiles)])
indicator(0,0)