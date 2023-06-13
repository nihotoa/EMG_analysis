%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% coded by Naoki Uchida
% last modification : 2021.03.23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yave,Y3ave] = CTcheck(monkeyname,xpdate_num,save_fold,save_CTR)
% monkeyname = 'Ya' ; 
% xpdate = '170524'; 
% Data = S.CTcheck{1,1};
% dt3 = S.CTcheck{4,1};
% L = length(Data(:,1));
switch monkeyname
    case 'Wa'
        real_name = 'Wasa';
    case 'Ya'
        real_name = 'Yachimun';
    case 'F'
        real_name = 'Yachimun';
    case 'Ma'
        real_name = 'Matatabi';
    case 'Sa'
        real_name = 'Sakiika';
    case 'Su'
        real_name = 'Suruku';
    case 'Se'
        %real_name = 'SesekiL';
        real_name = 'SesekiR';
end
global task
xpdate = sprintf('%d',xpdate_num);
 disp(['START TO MAKE & SAVE ' monkeyname xpdate 'CTcheck Data']);
cd(real_name)

L = 2;
for k = 1:L
    [Data,dt3] = loadCTData(monkeyname,xpdate,save_fold,k);
    Es = size(Data);
    if k == 1
        L = Es(1);
        Yave = zeros(L,L);
        Y3ave = zeros(L,L);
    end
    %     
    % Data = S.CTcheck{1,2};
    % dt3 = S.CTcheck{1,2};

%     L = length(Data(:,1));

    Y = cell(L);
    X = cell(L);
    Ysum = zeros(L,L);

    Y3 = cell(L);
    X3 = cell(L);
    Y3sum = zeros(L,L);

    count = 0;
    % f1 = figure;
    % f2 = figure;
    for i = 1:L
        for j = 1:L
            count = count + 1;
            %xcorr…相互相関を出す関数(xcorr(a,b)というふうに使う)
            [Y{i,j},X{i,j}] = xcorr(Data(i,:)-mean(Data(i,:)), Data(j,:)-mean(Data(j,:)),'coeff');
            Ysum(i,j) = max(abs(Y{i,j}));
%             Yave = (Yave .* (k-1) + Ysum) ./ k;
            [Y3{i,j},X3{i,j}] = xcorr(dt3(i,:)-mean(dt3(i,:)), dt3(j,:)-mean(dt3(j,:)),'coeff');
            Y3sum(i,j) = max(abs(Y3{i,j}));
%             Y3ave = (Y3ave .* (k-1) + Y3sum) ./ k;
            
%             [Y{i,j},X{i,j}] = xcorr(Data(i,:),Data(j,:),'coeff');
%             Ysum(i,j) = max(abs(Y{i,j}));
%             Yave = (Yave .* (k-1) + Ysum) ./ k;
%             [Y3{i,j},X3{i,j}] = xcorr(dt3(i,:),dt3(j,:),'coeff');
%             Y3sum(i,j) = max(abs(Y3{i,j}));
%             Y3ave = (Y3ave .* (k-1) + Y3sum) ./ k;

    %         figure(f1)
    %         subplot(L,L,count);
    %         plot(X{i,j},Y{i,j});
    %         ylim([-1 1]);
    %         figure(f2)
    %         subplot(L,L,count);
    %         plot(X{i,j},Y{i,j});
    %         ylim([-1 1]);
        end
    end
    Yave = (Yave .* (k-1) + Ysum) ./ k;
    Y3ave = (Y3ave .* (k-1) + Y3sum) ./ k;
end

cd([save_fold '/' monkeyname xpdate '_' task])
if save_CTR
    switch monkeyname
         case 'Wa'
             save([monkeyname xpdate '_CTR.mat'], 'monkeyname', 'xpdate', 'Yave', 'Y3ave');
         case 'Ya'
             save([monkeyname xpdate '_CTR.mat'], 'monkeyname', 'xpdate', 'Yave', 'Y3ave');
         case 'F'
             save([monkeyname xpdate '_CTR.mat'], 'monkeyname', 'xpdate', 'Yave', 'Y3ave');
     end
end
cd ../../../

% f3 = figure;
% hold on
% colormap 'jet'
% image(Yave,'CDataMapping','scaled')
% for i = 1:L
%     for j = 1:L
%         if Yave(i,j)>=0.25
%             plot([i i],[j j],'kx','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k')
%         end
%     end
% end
% % xticklabels(f4,S.EMGs);
% xlim([0.5 L+0.5]);
% ylim([0.5 L+0.5]);
% colorbar
% caxis([0 1])
% 
% f4 = figure;
% hold on
% colormap 'jet'
% image(Y3ave,'CDataMapping','scaled')
% for i = 1:L
%     for j = 1:L
%         if Y3ave(i,j)>=0.25
%             plot([i i],[j j],'kx','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k')
%         end
%     end
% end
% % xticklabels(f4,S.EMGs);
% xlim([0.5 L+0.5]);
% ylim([0.5 L+0.5]);
% colorbar
% caxis([0 1])
% hold off

close all

 disp(['FINISH TO MAKE & SAVE ' monkeyname xpdate 'CTcheck Data']);
end
%---------------------------------------------------------------------
function [D0,D3] = loadCTData(monkeyname,xpdate,save_fold,N)
global task
cd([save_fold '/' monkeyname xpdate '_' task])
    S = load([monkeyname xpdate '_CTcheckData.mat'],'CTcheck');
cd ../../
D0 = S.CTcheck.data0{:,N};
D3 = S.CTcheck.data3{:,N};
end