% dcohrtig_btc

% EndHold = dcohtrig(gcme, [0 gettime], 1024, 128, 192, 64, 32, 'Non-filtered-subsample', 'ADP-subsample',{'CentT Enter Off (success valid)'}, {[-3.072 1.024]},   'summed smoothed Torque','sbc');
Control = dcohtrig(gcme, [0 gettime], 192,  64,  [], [], [], 'Non-filtered-subsample', 'ADP-subsample',{'OutT1 Enter On (success valid)'},  {[0      1.280]},    'summed smoothed Torque','sbc');

figure;
subplot(3,2,1)
plot(EndHold.compiled.freq',squeeze(EndHold.compiled.coh(1,2,:)),Control.compiled.freq',squeeze(Control.compiled.coh(1,2,:)))
% plot(EndHold.compiled.freq',squeeze(EndHold.compiled.coh(1,2,:)))
set(gca,'Xlim',[3 50],...
    'Ylim',[0 1]);

subplot(3,2,2)
% plot(EndHold.compiled.freq',squeeze(EndHold.compiled.coh(2,1,:)),Control.compiled.freq',squeeze(Control.compiled.coh(2,1,:)))
plot(EndHold.compiled.freq',squeeze(EndHold.compiled.coh(2,1,:)))
set(gca,'Xlim',[3 50],...
    'Ylim',[0 1]);

subplot(3,2,3)
pplot(EndHold.compiled.freq',squeeze(EndHold.compiled.phase(1,2,:)),'b')
set(gca,'Xlim',[3 50]);

subplot(3,2,4)
pplot(EndHold.compiled.freq',squeeze(EndHold.compiled.phase(2,1,:)),'b')
set(gca,'Xlim',[3 50]);

subplot(3,2,5)
% pcolor(EndHold.timecoarse.t,EndHold.timecoarse.freq,squeeze(EndHold.timecoarse.coh(1,2,:,:))./repmat(squeeze(Control.compiled.coh(1,2,:)),1,size(EndHold.timecoarse.coh,4)))
pcolor(EndHold.timecoarse.t,EndHold.timecoarse.freq,squeeze(EndHold.timecoarse.coh(1,2,:,:)))
shading('Interp');
set(gca,'CLim',[0 Inf],...
    'Xlim',[-Inf Inf],...
    'Ylim',[3 50]);

subplot(3,2,6)
% pcolor(EndHold.timecoarse.t,EndHold.timecoarse.freq,squeeze(EndHold.timecoarse.coh(2,1,:,:))./repmat(squeeze(Control.compiled.coh(2,1,:)),1,size(EndHold.timecoarse.coh,4)))
pcolor(EndHold.timecoarse.t,EndHold.timecoarse.freq,squeeze(EndHold.timecoarse.coh(2,1,:,:)))
shading('Interp');
set(gca,'CLim',[0 Inf],...
    'Xlim',[-Inf Inf],...
    'Ylim',[3 50]);