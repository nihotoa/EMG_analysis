function	[ix_act, ix_rest] = get_active_index(Model,parm);
% return active index in original input without time embedding
%  [ix_act] = get_active_index(Model);
%  [ix_act, ix_rest] = get_active_index(Model);
%  --- Old version
%  [ix_act] = get_active_index(Model,parm);
%  [ix_act, ix_rest] = get_active_index(Model,parm);
% --- input
% Model.W : Weight matrix for active input [Ydim x Nactive]
% Model.ix_act : active input index in time embedding space
% Model.Dtau : time embedding dimension
% Model.M_all = Xdim * Model.Dtau : total dimension of time embedding space
% --- output
% ix_act  : active index in original input without time embedding
% ix_rest : non-active index in original input without time embedding
%
% 2011-6-21 Masa-aki Sato

if nargin < 2, parm  = []; end;

if isfield(Model,'Dtau')
	Dtau  = Model.Dtau;
elseif isfield(parm,'Dtau')
	Dtau  = parm.Dtau;
else
	Dtau  = 1;
end

if isfield(Model,'ix_act')
	% Active index
	ix_act = Model.ix_act;
	M_all  = length(ix_act);
else
	M_all  = Model.M_all;
	ix_act = 1:M_all;
end

Xeff   = M_all/Dtau;
ix_act = ix_act(1:Xeff);

if nargout==1, return; end;

M_all = Model.M_all;
Xdim  = M_all/Dtau;

ix_rest = vb_setdiff2(1:Xdim,ix_act);

