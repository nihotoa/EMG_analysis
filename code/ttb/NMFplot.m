function hAx    =NMFplot(TimeRange,NMFhdr,NMFdat,iNMF)

figure

nEMG    = length(NMFhdr.TargetName);

H   = NMFdat.H{iNMF};

XData   = ((1:size(H,2))-1)/NMFhdr.Info.SampleRate;
ind     = XData>=TimeRange(1) & XData<=TimeRange(2);

H       = H(:,ind);
XData   = XData(ind);
hAx     = nan(1,nEMG);

for iEMG=1:nEMG
    hAx(iEMG)   = subplot(nEMG,1,iEMG);
    W   = NMFdat.W{iNMF}(iEMG,:);
%     keyboard
    fill([XData,XData(end:-1:1)],[zeros(size(H(2,:))),H(2,end:-1:1)*W(2)],'b','EdgeColor','none','Parent',hAx(iEMG));
    hold(hAx(iEMG),'on');
    fill([XData,XData(end:-1:1)],[H(2,:)*W(2),H(3,end:-1:1)*W(3)+H(2,end:-1:1)*W(2)],'g','EdgeColor','none','Parent',hAx(iEMG));
    fill([XData,XData(end:-1:1)],[H(3,:)*W(3)+H(2,:)*W(2),H(3,end:-1:1)*W(3)+H(2,end:-1:1)*W(2)+H(1,end:-1:1)*W(1)],'r','EdgeColor','none','Parent',hAx(iEMG));
    
    
%     plot(hAx(iEMG),XData,H(3,:)*W(3),'-k')
%     plot(hAx(iEMG),XData,H(2,:)*W(2)+H(3,:)*W(3),'-k')
    plot(hAx(iEMG),XData,H(1,:)*W(1)+H(2,:)*W(2)+H(3,:)*W(3),'-k');
    
    title(hAx(iEMG),NMFhdr.TargetName{iEMG});
end

linkaxes(hAx,'x')

