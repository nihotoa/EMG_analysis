clear all
%% 
% cd ../
Tdata = load('../DataSetForEachXcorr_80_syn_Range2.mat','TrigData_Each');
EMGdata = load('../DataSetForEachXcorr_80_EMG_Range2.mat','TrigData_Each');
% cd 'Wsynergy_plot'
% load('WsynData.mat');
load('WsynData_fixed.mat');
load('PostColor.mat');
theta = pi/2:pi/6:5*pi/2;
theta_m = linspace(0,2*pi);
x = 1:1:13;
synC = lines(4);
LineC = [0.75 0.75 0.75];
rmax = 2.5;
synOrder = [2 1 4 3];
absltorder = [9 11 10 8 12 7 1 2 6 5 4 3];

% c = lines(4);
%       c = jet(4);
AllDays = datetime([2017,04,05])+caldays(0:177);
dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
        '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
        '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
        '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
        '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
        '2017/06/14','2017/06/15','2017/06/16','2017/06/20',...
        '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
        '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
        '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
        '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
        '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
        '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
        '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
        '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
        '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
        '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
TaskCompletedDay = {'2017/08/07'};
TTsurgD = datetime([2017,05,30]);                %date of tendon transfer surgery
TTtaskD = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:178
   if k>length(dayX)
   elseif AllDays(i)==dayX(k)
   Xpost(1,i) = i;
   k=k+1;
   end
   if l>length(AVEPre4Days)
   elseif AllDays(i)==AVEPre4Days(l)
   Xpre4(1,i) = i;
   l=l+1;
   end
   if AllDays(i)==TaskCompletedDay
      tcd = i;
   end
end
xdays = find(Xpost) - find(AllDays==TTsurgD);
xPre4days = find(Xpre4) - find(AllDays==TTsurgD);
TCD = tcd - find(AllDays==TTsurgD);
xnoT = 0:(find(AllDays==TTtaskD)-1- find(AllDays==TTsurgD));
%%%%%%%%% finish preparing days %%%%%%%%%

%%%%%%%%% start calculation %%%%%%%%%
for ss = 1:4
   figure('Position',[800 720 800 800]);
   axA = gca;
   axA.XAxisLocation = 'origin';
   axA.YAxisLocation = 'origin';
   axA.FontSize = 16;
   axis square
   xlim([-2.8 2.8]);
   ylim([-2.8 2.8]);
%    polaraxes;
   hold on
   for r = 0.5:0.5:rmax
      if r == rmax
         plot(r*cos(theta_m),r*sin(theta_m),'k','LineWidth',2);
      else
         plot(r*cos(theta_m),r*sin(theta_m),'Color',LineC,'LineWidth',2);
      end
   end
%    plot([-3 3],[0 0],'Color',LineC,'LineWidth',3);
%    plot([0 0],[-3 3],'Color',LineC,'LineWidth',3);
   for th = 1:12
      plot([rmax*cos(theta(th)) (-rmax)*cos(theta(th))],[rmax*sin(theta(th)) (-rmax)*sin(theta(th))],'Color',LineC,'LineWidth',4);
   end
%    plot(r*cos(theta(theta_m)),r*sin(theta_m),'Color',[0.85 0.85 0.85],'LineWidth',1));

%    for dd = 20:20
      CD = [17 18 19 20];  % control days 
      for dd = 1:length(CD)
         R = [allW{CD(dd)}(absltorder,synOrder(ss)); allW{CD(dd)}(absltorder(1),synOrder(ss))]';
         if dd == 1 
            aR = zeros(length(CD),length(R));
         end
         aR(dd,:) = R;
      end
      mR = mean(aR,1);
      sR = std(aR,1,1);
      fi = fill([(mR+sR).*cos(theta) (mR(end:-1:1)-sR(end:-1:1)).*cos(theta(end:-1:1))],[(mR+sR).*sin(theta) (mR(end:-1:1)-sR(end:-1:1)).*sin(theta(end:-1:1))],'k');
      fi.FaceColor = synC(ss,:) + [0.05 0.05 0.05];%[0.75 0.75 0.75];       % make the filled area 'blue','red','yellow','purple'
      fi.FaceAlpha = .3;
      fi.EdgeColor = 'none';            % remove the line around the filled area
      plot(mR.*cos(theta),mR.*sin(theta),'Color',synC(ss,:),'LineWidth',4);
%       polarplot(theta,R,'k-')
%       fill([(R+0.002).*cos(theta) (R-0.002).*cos(theta(end:-1:1))],[(R+0.002).*sin(theta) (R-0.002).*sin(theta(end:-1:1))],'r')
%       polarfill(gca,theta,[allW{dd}(:,synOrder(ss)); allW{dd}(1,synOrder(ss))],[0 0 0.78],EMGs)
%       hold on
%    end
   
   figure('Position',[0 720 800 800]);
   axB = gca;
   axB.XAxisLocation = 'origin';
   axB.YAxisLocation = 'origin';
   axB.FontSize = 16;
   axis square
   xlim([-2.8 2.8]);
   ylim([-2.8 2.8]);
   hold on
   for r = 0.5:0.5:rmax
      if r == rmax
         plot(r*cos(theta_m),r*sin(theta_m),'k','LineWidth',2);
%          text(r*cos(theta(1)),r*sin(theta(1)),'FLEXOR',24);
      else
         plot(r*cos(theta_m),r*sin(theta_m),'Color',LineC,'LineWidth',2);
      end
   end
%    plot([-3 3],[0 0],'Color',LineC,'LineWidth',3);
%    plot([0 0],[-3 3],'Color',LineC,'LineWidth',3);
   for th = 1:12
      plot([rmax*cos(theta(th)) (-rmax)*cos(theta(th))],[rmax*sin(theta(th)) (-rmax)*sin(theta(th))],'Color',LineC,'LineWidth',4);
   end
   for dd = 36:80
      R = [allW{dd}(absltorder,synOrder(ss)); allW{dd}(absltorder(1),synOrder(ss))]';
      plot(R.*cos(theta),R.*sin(theta),'Color',c(dd-35,:),'LineWidth',4);
%       polarplot(theta,[allW{dd}(:,synOrder(ss)); allW{dd}(1,synOrder(ss))],'k-')
%       polarfill(gca,theta,[allW{dd}(:,synOrder(ss)); allW{dd}(1,synOrder(ss))],[0 0 0.78],EMGs)
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% make reconstructed EMG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    VAF,COR
   if ss ==1
      rEMG = cell(4,80);
      VAF = cell(4,1);
      COR = cell(4,1);
      I12 = ones(12,1);
      rEE_all = cell(1,80);
      EE_all = cell(1,80);
   end
   f1 = figure;
   f2 = figure;
   vaf = zeros(12,80);
   cor = zeros(12,80);
   for dd = 1:80
      eval(['TT = Tdata.TrigData_Each.T' sprintf('%d',ss) '.data{1,dd};']);
      eval(['EE = EMGdata.TrigData_Each.T' sprintf('%d',ss) '.data{1,dd};']);
%       TT = (TT - repmat(min(TT,[],2),1,length(TT(1,:))))./repmat(max(TT,[],2),1,length(TT(1,:)));
      EE = (EE - repmat(min(EE,[],2),1,length(EE(1,:))))./repmat(max(EE,[],2),1,length(EE(1,:)));
      rEMG{ss,dd} = allW{1,dd}*TT;
      rEE = (rEMG{ss,dd} - repmat(min(rEMG{ss,dd},[],2),1,length(rEMG{ss,dd}(1,:))))./repmat(max(rEMG{ss,dd},[],2),1,length(rEMG{ss,dd}(1,:)));
      rEE = rEE(absltorder',:);
%       rEE = rEMG{ss,dd};
      EM = mean(rEE,2);
      SSTi = rEE;
      cori = zeros(12,1);
      for i = 1:12
         SSTi(i,:) = rEE(i,:) - ones(1,length(rEE(1,:))).*EM(i);
         CC = corrcoef(rEE(i,:)',EE(i,:)');
         cori(i) = CC(1,2);
      end
      vaf(:,dd) = I12 -sum((EE - rEE).^2,2)./sum(SSTi.^2,2);
      cor(:,dd) = cori;
%       figure(f1)
%       for jj =1:12
%          subplot(3,4,jj)
%          hold on
%          plot(EE(jj,:))
%       end
%       figure(f2)
%       for jj =1:12
%          subplot(3,4,jj)
%          hold on
%          plot(rEE(jj,:))
%       end
      rEE_all{dd} = rEE;
      EE_all{dd} = EE;
   end
   VAF{ss} = vaf;
   COR{ss} = cor;
%%%%%%%plot%%%%%%
   figure(f1)
   for jj =1:12
      subplot(3,4,jj)
      hold on
      for dd =1:80
         plot(EE_all{dd}(jj,:))
      end
   end
   figure(f2)
   for jj =1:12
      subplot(3,4,jj)
      hold on
      for dd =1:80
         plot(rEE_all{dd}(jj,:))
      end
   end
end
cc = jet(12);
for pp = 1:4
figure
xlim([xPre4days(1) xdays(end)]);
hold on
fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
fi1.EdgeColor = 'none';            % remove the line around the filled area
for i = 1:12
if i == 3||i ==10
plot(xdays,COR{pp}(i,:)- mean(COR{pp}(i,17:20)),'Color',cc(i,:),'LineWidth',2)
% plot(xdays,COR{pp}(i,:),'Color',cc(i,:),'LineWidth',2)
else
plot(xdays,COR{pp}(i,:)- mean(COR{pp}(i,17:20)),'Color',cc(i,:))
% plot(xdays,COR{pp}(i,:),'Color',cc(i,:))
end
end
fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1);
fi2.FaceColor = [1 1 1];       % make the filled area
legend(['control', cellstr(EMGs'), 'Task Disable']);
end
