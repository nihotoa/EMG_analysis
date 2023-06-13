% figure
% subplot(3,2,1)
% bar(xAFF,[LAGDCGAFFHIST(:,1),LAGDCHAFFHIST(:,1)]),title('SpinalNB-Aff')
% subplot(3,2,3)
% bar(xAFF,[LAGDCGAFFHIST(:,2),LAGDCHAFFHIST(:,2)]),title('SpinalBB-Aff')
% subplot(3,2,5)
% bar(xAFF,[LAGDCGAFFHIST(:,3),LAGDCHAFFHIST(:,3)]),title('Cortex-Aff')
% subplot(3,2,2)
% bar(xEFF,[LAGDCGEFFHIST(:,1),LAGDCHEFFHIST(:,1)]),title('SpinalNB-Eff')
% subplot(3,2,4)
% bar(xEFF,[LAGDCGEFFHIST(:,2),LAGDCHEFFHIST(:,2)]),title('SpinalBB-Eff')
% subplot(3,2,6)
% bar(xEFF,[LAGDCGEFFHIST(:,3),LAGDCHEFFHIST(:,3)]),title('Cortex-Eff')
% 
% figure
% subplot(3,2,1)
% bar(xAFF,[LAGDCGAFFHIST(:,1),LAGDCHAFFHIST(:,1)]/n1),title('SpinalNB-Aff')
% subplot(3,2,3)
% bar(xAFF,[LAGDCGAFFHIST(:,2),LAGDCHAFFHIST(:,2)]/n2),title('SpinalBB-Aff')
% subplot(3,2,5)
% bar(xAFF,[LAGDCGAFFHIST(:,3),LAGDCHAFFHIST(:,3)]/n3),title('Cortex-Aff')
% subplot(3,2,2)
% bar(xEFF,[LAGDCGEFFHIST(:,1),LAGDCHEFFHIST(:,1)]/n1),title('SpinalNB-Eff')
% subplot(3,2,4)
% bar(xEFF,[LAGDCGEFFHIST(:,2),LAGDCHEFFHIST(:,2)]/n2),title('SpinalBB-Eff')
% subplot(3,2,6)
% bar(xEFF,[LAGDCGEFFHIST(:,3),LAGDCHEFFHIST(:,3)]/n3),title('Cortex-Eff')


figure
subplot(4,3,1)
bar(xEFF,LAGDCGEFFHIST(:,2)/n2,1),title('SpinalBB-Grip-Eff')
xlim([0 100])
ylim([0 0.6])
subplot(4,3,2)
bar(xEFF,LAGDCGEFFHIST(:,1)/n1,1),title('SpinalNB-Grip-Eff')
xlim([0 100])
ylim([0 0.12])
subplot(4,3,3)
bar(xEFF,LAGDCGEFFHIST(:,3)/n3,1),title('Cortex-Grip-Eff')
xlim([0 100])
ylim([0 0.15])
subplot(4,3,4)
bar(xEFF,LAGDCGAFFHIST(end:-1:1,2)/n2,1),title('SpinalBB-Grip-Aff')
xlim([0 100])
ylim([0 0.6])
subplot(4,3,5)
bar(xEFF,LAGDCGAFFHIST(end:-1:1,1)/n1,1),title('SpinalNB-Grip-Aff')
xlim([0 100])
ylim([0 0.12])
subplot(4,3,6)
bar(xEFF,LAGDCGAFFHIST(end:-1:1,3)/n3,1),title('Cortex-Grip-Aff')
xlim([0 100])
ylim([0 0.15])

subplot(4,3,7)
bar(xEFF,LAGDCHEFFHIST(:,2)/n2,1),title('SpinalBB-Hold-Eff')
xlim([0 100])
ylim([0 0.6])
subplot(4,3,8)
bar(xEFF,LAGDCHEFFHIST(:,1)/n1,1),title('SpinalNB-Hold-Eff')
xlim([0 100])
ylim([0 0.12])
subplot(4,3,9)
bar(xEFF,LAGDCHEFFHIST(:,3)/n3,1),title('Cortex-Hold-Eff')
xlim([0 100])
ylim([0 0.15])
subplot(4,3,10)
bar(xEFF,LAGDCHAFFHIST(end:-1:1,2)/n2,1),title('SpinalBB-Hold-Aff')
xlim([0 100])
ylim([0 0.6])
subplot(4,3,11)
bar(xEFF,LAGDCHAFFHIST(end:-1:1,1)/n1,1),title('SpinalNB-Hold-Aff')
xlim([0 100])
ylim([0 0.12])
subplot(4,3,12)
bar(xEFF,LAGDCHAFFHIST(end:-1:1,3)/n3,1),title('Cortex-Hold-Aff')
xlim([0 100])
ylim([0 0.15])


% figure
% subplot(3,2,1)
% pie(PRODCAFF(1,:)),title('SpinalNB-Aff')
% subplot(3,2,3)
% pie(PRODCAFF(2,:)),title('SpinalBB-Aff')
% subplot(3,2,5)
% pie(PRODCAFF(3,:)),title('Cortex-Aff')
% subplot(3,2,2)
% pie(PRODCEFF(1,:)),title('SpinalNB-Eff')
% subplot(3,2,4)
% pie(PRODCEFF(2,:)),title('SpinalBB-Eff')
% subplot(3,2,6)
% pie(PRODCEFF(3,:)),title('Cortex-Eff')

% figure
% h   =subplot(3,2,1);
% bar([PRODCGAFF(1,:)/sum(PRODCGAFF(1,:)); PRODCHAFF(1,:)/sum(PRODCHAFF(1,:))],'stacked'),title('SpinalNB-Aff')
% axis(h,'square');
% h   = subplot(3,2,3);
% bar([PRODCGAFF(2,:)/sum(PRODCGAFF(2,:)); PRODCHAFF(2,:)/sum(PRODCHAFF(2,:))],'stacked'),title('SpinalBB-Aff')
% axis(h,'square');
% h   = subplot(3,2,5);
% bar([PRODCGEFF(3,:)/sum(PRODCGEFF(3,:)); PRODCHAFF(3,:)/sum(PRODCHAFF(3,:))],'stacked'),title('Cortex-Aff')
% axis(h,'square');
% h   = subplot(3,2,2);
% bar([PRODCGEFF(1,:)/sum(PRODCGEFF(1,:)); PRODCHEFF(1,:)/sum(PRODCHEFF(1,:))],'stacked'),title('SpinalNB-Eff')
% axis(h,'square');
% h   = subplot(3,2,4);
% bar([PRODCGEFF(2,:)/sum(PRODCGEFF(2,:)); PRODCHEFF(2,:)/sum(PRODCHEFF(2,:))],'stacked'),title('SpinalBB-Eff')
% axis(h,'square');
% h   = subplot(3,2,6);
% bar([PRODCGEFF(3,:)/sum(PRODCGEFF(3,:)); PRODCHEFF(3,:)/sum(PRODCHEFF(3,:))],'stacked'),title('Cortex-Eff')
% axis(h,'square');
% colormap('gray')