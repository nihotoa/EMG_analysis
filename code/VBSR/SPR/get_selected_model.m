function	[Model,SC,Err] = get_selected_model(ModelAll,InfoStat,parm)
%  Get best combined model from set of training models
% --- Usage
%	[Model,SC] = get_selected_model(ModelAll, InfoStat)
% --- Input
% m-th single model 
%	ModelAll{m},ix_act
%	ModelAll{m},W
%
%	InfoStat.CheckErr(m) : model selection error of m-th combined model 
%	InfoStat.Fmax(m)     : Free erergy of m-th model 
%	InfoStat.M_all  
% --- Output
%  Model.ix_act 
%  Model.W  
%  SC : selection count number for each input dimension
%
% 2011-10-10 Made by M. Sato

if ~isfield(parm,'Err_min'), parm.Err_min = 0.001; end;

M_all = ModelAll{1}.M_all;
Ydim  = size(ModelAll{1}.W, 1);

W  = zeros(Ydim,M_all);
SC = zeros(1,M_all);

[Errmin, Nmin] = min(InfoStat.CheckErr);

imin = find( InfoStat.CheckErr <= Errmin * (1 + parm.Err_min) );
Nmin = imin(1);
Err  = InfoStat.CheckErr(Nmin);

Prob = exp(InfoStat.Fmax(1:Nmin));
Prob = Prob/sum(Prob);

for m=1:Nmin
	ix_act = ModelAll{m}.ix_act;
	SC(ix_act)  = SC(ix_act) + 1;
	W(:,ix_act) = W(:,ix_act) + ModelAll{m}.W * Prob(m);
end

ix_act = find( SC > 0 );
Model.ix_act = ix_act;
Model.W  = W(:,ix_act);

% Input dimension in original input data
Model.M_all = M_all;
Model.Xdim  = ModelAll{1}.Xdim ;
Model.Tau   = ModelAll{1}.Tau  ;
Model.Dtau  = ModelAll{1}.Dtau ;
