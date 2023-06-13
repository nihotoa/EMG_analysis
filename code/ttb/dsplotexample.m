x  = linspace(0, 2*pi, 1000000);
    y1 = sin(x) + .01*cos(200*x) + 0.001*sin(2000*x);
    y2 = sin(x) + 0.3*cos(3*x)   + 0.001*randn(size(x));
    y1([300000, 700000, 700001, 900000]) = [0, 1, -2, 0.5];
    y2(300000:500000) = y2(300000:500000) + 1;
    y2(500001:600000) = y2(500001:600000) - 1;
    y2(800000) = 0;
%     dsplot(x, [y1;y2]);title('Down Sampled');
figure
%     tdsplot(gca, x, [y1;y2],10000,'1');title('Down Sampled');
        tdsplot2(gca, x, [y1;y2]);set(get(gca,'Title'),'String','Down Sampled');