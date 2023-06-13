function	plot_cv_error(InfoStat, infoStat, parm)

TrainErr = InfoStat.TrainErr ;
ModelErr = InfoStat.ModelErr ;
CheckErr = InfoStat.CheckErr;

Fmax  = InfoStat.Fmax  ;
Nact  = InfoStat.Nact ;

Nall = length(CheckErr);

%%%% ---- DEBUG ---- %%%%
[Errmin, Nmin] = min(CheckErr);
Err  = Errmin * (1 + parm.Err_min);
imin = find( InfoStat.CheckErr <= Err );
Nmin = imin(1);

Nopt = Nact(Nmin);

Prob = exp(Fmax);
Prob = Prob/sum(Prob);

figure;
subplot(2,2,1)
plot(TrainErr);
title('Training Error')

subplot(2,2,2)
plot(Nact);
hold on
plot([Nmin Nmin],[0 Nact(Nmin)])
title('# of selected input')

subplot(2,2,3)
plot(CheckErr);
hold on
plot([Nmin Nmin],[0 CheckErr(Nmin)], '-r')

plot([1 Nall], [Err Err], ':')
plot(infoStat.CheckErr, '--');

title('CV error (-) vs Test error (--)')
%title('CV Error for combined model')

subplot(2,2,4)
plot(ModelErr);
hold on
plot(Prob,'--y')
plot([Nmin Nmin],[0 ModelErr(Nmin)])
title('CV Error (Prob) for single model')

return

figure;
plot(InfoStat.CheckErr);
hold on
plot(infoStat.CheckErr, '--');

title('CV error (-) vs Test error (--)')
