figure;

subplot(1,2,1)
hold on
stairs(freq,narrow18-monte10000.narrow18.ave,'Color','k','LineWidth',0.75);
stairs(freq,monte10000.narrow18.prctile99-monte10000.narrow18.ave,'Color','k','LineWidth',0.75);

subplot(1,2,2)
hold on
stairs(freq,broad10-monte10000.broad10.ave,'Color','k','LineWidth',0.75);
stairs(freq,monte10000.broad10.prctile99-monte10000.broad10.ave,'Color','k','LineWidth',0.75);