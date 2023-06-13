clear all
%% 
% cd ../
Tdata = load('../DataSetForEachXcorr_28_syn_Range1.mat','Allfiles','TrigData_Each');
EMGdata = load('../DataSetForEachXcorr_28_EMG_Range1.mat','TrigData_Each');
% cd 'Wsynergy_plot'
load('WsynData.mat');
% load('WsynData_fixed.mat');
% load('PostColor.mat');
theta = pi/2:2*pi/9:5*pi/2;
theta_m = linspace(0,2*pi);
x = 1:1:13;
synC = lines(4);
LineC = [0.75 0.75 0.75];
rmax = 2.5;
synOrder = [4 1 3 2];
absltorder = [7 5 6 4 3 2 8 9 1];

% c = lines(4);
%       c = jet(4);
Nd = 74;
AllDays = datetime([2020,01,17])+caldays(0:Nd-1);
dayX = {'2020/1/17', '2020/1/19', '2020/1/20',...
       '2020/2/10', '2020/2/12', '2020/2/13', '2020/2/14', '2020/2/17',...
       '2020/2/18', '2020/2/19', '2020/2/20', '2020/2/21', '2020/02/26',...
       '2020/3/3', '2020/3/4', '2020/3/5', '2020/3/6', ...
       '2020/3/9', '2020/3/10', '2020/3/16', '2020/3/17', ...
       '2020/3/18', '2020/3/19', '2020/3/23', '2020/3/24', '2020/3/25',...
       '2020/3/26', '2020/3/30'};
AVEPre4Days = {'2020/01/17', '2020/01/19', '2020/01/20'};
TaskCompletedDay = {'2020/02/10'};
TTsurgD = datetime([2020,01,21]);                %date of tendon transfer surgery
TTtaskD = datetime([2020,02,10]);                %date monkey started task by himself after surgery 
AllDay = strrep(Tdata.Allfiles,'Se','');
AllDaysN =str2num(cell2mat(AllDay'));
cd ../
P = load('PostDays.mat');
PostDays = P.PostDays(6:end);
Sp = length(PostDays);
Csp = jet(Sp);
cd Wsynergy_plot
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
N = length(dayX);
k=1;l=1;
for i=1:Nd
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
   for th = 1:9
%       plot([rmax*cos(theta(th)) (-rmax)*cos(theta(th))],[rmax*sin(theta(th)) (-rmax)*sin(theta(th))],'Color',LineC,'LineWidth',4);
      plot([rmax*cos(theta(th)) 0],[rmax*sin(theta(th)) 0],'Color',LineC,'LineWidth',4);
   end
%    plot(r*cos(theta(theta_m)),r*sin(theta_m),'Color',[0.85 0.85 0.85],'LineWidth',1));

%    for dd = 20:20
      CD = [1 2 3];  % control days 
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
   for th = 1:9
%       plot([rmax*cos(theta(th)) (-rmax)*cos(theta(th))],[rmax*sin(theta(th)) (-rmax)*sin(theta(th))],'Color',LineC,'LineWidth',4);
      plot([rmax*cos(theta(th)) 0],[rmax*sin(theta(th)) 0],'Color',LineC,'LineWidth',4);
   end
   for dd = 4:N
      R = [allW{dd}(absltorder,synOrder(ss)); allW{dd}(absltorder(1),synOrder(ss))]';
      plot(R.*cos(theta),R.*sin(theta),'Color',Csp(find(PostDays==AllDaysN(dd)),:),'LineWidth',4);
%       polarplot(theta,[allW{dd}(:,synOrder(ss)); allW{dd}(1,synOrder(ss))],'k-')
%       polarfill(gca,theta,[allW{dd}(:,synOrder(ss)); allW{dd}(1,synOrder(ss))],[0 0 0.78],EMGs)
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% make reconstructed EMG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    VAF,COR
   if ss ==1
      rEMG = cell(4,N);
      VAF = cell(4,1);
      COR = cell(4,1);
      I9 = ones(9,1);
      rEE_all = cell(1,N);
      EE_all = cell(1,N);
   end
   f1 = figure;
   f2 = figure;
   vaf = zeros(9,N);
   cor = zeros(9,N);
   for dd = 1:N
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
      cori = zeros(9,1);
      for i = 1:9
         SSTi(i,:) = rEE(i,:) - ones(1,length(rEE(1,:))).*EM(i);
         CC = corrcoef(rEE(i,:)',EE(i,:)');
         cori(i) = CC(1,2);
      end
      vaf(:,dd) = I9 -sum((EE - rEE).^2,2)./sum(SSTi.^2,2);
      cor(:,dd) = cori;
%       figure(f1)
%       for jj =1:9
%          subplot(3,4,jj)
%          hold on
%          plot(EE(jj,:))
%       end
%       figure(f2)
%       for jj =1:9
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
   for jj =1:9
      subplot(3,4,jj)
      hold on
      for dd =1:N
         plot(EE_all{dd}(jj,:))
      end
   end
   figure(f2)
   for jj =1:9
      subplot(3,4,jj)
      hold on
      for dd =1:N
         plot(rEE_all{dd}(jj,:))
      end
   end
end
cc = jet(9);
for pp = 1:4
figure
xlim([xPre4days(1) xdays(end)]);
hold on
fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
fi1.EdgeColor = 'none';            % remove the line around the filled area
for i = 1:9
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
