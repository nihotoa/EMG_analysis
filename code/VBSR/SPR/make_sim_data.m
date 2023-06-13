set_dir;
clear all

% File name for test data
datafile  = ['./test/test.mat'];

% Training & test data setting
Tdata  = 100 ; % # of training data
Ttest  = 1000 ; % # of test data

parm.SY   = [0.3; 0.1; 0.5; 1.0];% output moise variance
%parm.SY   = [0.3];% output moise variance
parm.Ydim = length(parm.SY);
parm.Xdim = 200;   % Input dim
parm.Meff = 30;    % Effective Input
parm.Sdim = 10; % number of sinusoidal input
parm.Tmin = 50; % minimum period
parm.Tmax = 200;% maximum period

parm.sy = parm.SY;
parm.Ntrial = 1;
[xdata,ydata,Wout,Weff,Wrdn,Win,Wirr] = ...
	make_train_data(parm, Tdata);

parm.sy = 0.0;
parm.Ntrial = 2;
[xtest,ytest] = ...
	make_train_data(parm, Ttest, Wout,Wrdn,Win,Wirr);

if ~isempty(datafile)
	save(datafile, ...
		'xdata','ydata','xtest','ytest',...
		'Wout','Weff','parm')
end
