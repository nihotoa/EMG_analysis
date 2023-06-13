for ii=10:42
subplot(2,1,1)
plot(s.XData,filter(Hd,s.TrialData(ii,:)))
subplot(2,1,2)


plot(ss.XData,filter(Hd,ss.TrialData(ii,:)))
keyboard
end