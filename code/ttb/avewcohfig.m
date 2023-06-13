function avewcohfig(wsfilename)
%function avewcohfig(wsfilename)
if nargin<1
    wsfilename  =[];
end
TOI = [-1.024 3.072];
FOI = [0 100];


% dirname = uigetdir(fullfile(datapath,'wcohclssig'));
[files,dirname]   = uigetallfile(fullfile(datapath,'wcohclssig'));
nfile   = length(files);

L   =[];
n   = 0;
for ii=1:nfile
    mat    = load(files{ii});
    if ii==1
        freq    = mat.freq;
        t    = mat.t;
        zcxy    = zeros(length(freq),length(t));
        acxy    = zcxy;
        psig    = zcxy;
        pclssig = zcxy;
        
    end
    n       = n + 1;
    L(ii)   = mat.cl.seg_tot;
%     allacxy(:,:,ii) = mat.cxy;
%     allzcxy(:,:,ii) = zcoh(mat.cxy,mat.cl.seg_tot);
%     allpcxy(:,:,ii) = (mat.cxy > mat.cl.ch_c95);
%     allphi(:,:,ii)  = mat.phi;
    zcxy    = zcxy + zcoh(mat.cxy,mat.cl.seg_tot);
    acxy    = acxy + double(mat.cxy);
    psig    = psig + double(mat.sig);
    pclssig = pclssig + double(mat.clssig);
%     disp(num2str(mat.cl.seg_tot))
    indicator(ii,nfile,mfilename);
end

zcxy    = zcxy / sqrt(n);
acxy    = acxy / n;
psig    = psig * 100 / n;
pclssig    = pclssig * 100 / n;

figure('Name',dirname,...
    'NumberTitle','off');

h   = subplot(3,1,1);
cl  = cohmeansignif(L,0.05);
pcolor(t,freq,acxy);
shading('flat')
% set(h,'CLim',[cl,max(max(acxy,[],2),[],1)],...
    set(h,'CLim',[cl 0.05],...
    'XLim',TOI,...
    'YLim',FOI);
colormap(tmap2)
colorbar
title({[dirname,' (n= ',num2str(nfile),')'],'','Averaged coherence'});
ylabel('frequency (Hz)')
xlabel('time (s)')

h   = subplot(3,1,2);
cl  = binocl(n,0.05,0.05) * 100 / n;
pcolor(t,freq,psig);
shading('flat')
set(h,'CLim',[cl,max(max(psig,[],2),[],1)],...
    'XLim',TOI,...
    'YLim',FOI);
colormap(tmap2)
colorbar
title('% sig')
ylabel('frequency (Hz)')
xlabel('time (s)')


h   = subplot(3,1,3);
cl  = binocl(n,0.05,0.05) * 100 / n;
pcolor(t,freq,pclssig);
shading('flat')
set(h,'CLim',[cl,max(max(pclssig,[],2),[],1)],...
    'XLim',TOI,...
    'YLim',FOI);
colormap(tmap2)
colorbar
title('% clssig')
ylabel('frequency (Hz)')
xlabel('time (s)')


if(~isempty(wsfilename))
    save(wsfilename)
end

indicator(0,0);


