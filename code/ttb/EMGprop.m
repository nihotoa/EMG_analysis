function s  = EMGprop(x,type)

if(~exist('type','var'))
    type    = [];
end

EMG.Name   = {'FDI'	'ADP'	'AbPB'	'2DI'	'3DI'	'4DI'	'AbDM'	'FDS'	'FDPr'	'FDPu'	'AbPL'	'ED23'	'ED45'	'EDC'	'FCR'	'FCU'	'PL'	'ECR'	'ECRb'	'ECRl'	'ECU'	'BRD'	'PT'	'Biceps'	'Triceps' 'NonEMG'};
EMG.Order  = [2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25  26  1];
EMG.Type   = [1	1	1	1	1	1	1	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2	2   0];
% EMG.Group  = [1	1	1	1	1	1	1	2	2	2	3	3	3	3	4	4	4	5	5	5	5	6	6	6	6   0];
EMG.Group  = [2 2   2   2   2   2   2   3   3   3   4   4   4   4   5   5   5   6   6   6   6   7   7   7   7   1];

if(~exist('x','var'))
    s   = EMG;
    return;
end

if(~iscell(x))
    x   = {x};
end
nx  = length(x);
ind = zeros(1,nx);

for ix=1:nx
    temp    = parseEMG(x{ix});
    if(~isempty(temp))
        x{ix}   = temp;
        ind(ix) = strmatch(x{ix},EMG.Name,'exact');
    else
        ind(ix) = 26;
    end
end

% if(~iscell(x))
%     x   = {x};
% end
% nx  = length(x);
% ind = zeros(1,nx);
% for ix  =1:nx
%     ind(ix) = strmatch(x{ix},EMG.Name,'exact');
% end

% s.Name  = EMG.Name(ind);
s.Name  = x;
s.Order = EMG.Order(ind);
s.Type  = EMG.Type(ind);
[temp,s.Index]  = sort(s.Order);
[temp,s.Order]  = sort(s.Index);
s.nEMG  = length(s.Name);
s.Group = EMG.Group(ind);
% keyboard
s.GroupName = cell(1,nx);
GroupNames  = {'non-EMG','ihand','ehand-fx','ehand-ex','wrist-fx','wrist-ex','elbow'};
s.GroupName(s.Group~=0) = GroupNames(s.Group(s.Group~=0));
s.GroupName(s.Group==0) = {'non-EMG'};

s.GroupNames    = GroupNames(ismember(GroupNames,unique(s.GroupName)));
s.nGroup    = length(s.GroupNames);
s.GroupN    = zeros(1,s.nGroup); 
for ii=1:s.nEMG
    s.Group(ii) = strmatch(s.GroupName{ii},s.GroupNames);
    s.GroupN(s.Group(ii))   = s.GroupN(s.Group(ii))+1;
end



% 
% 
% s.Name  = {'2DI' '3DI'   '4DI'   'AbDM'  'AbPB'  'AbPL'  'ADP'   'Biceps'    'BRD'   'ECR'   'ECU'   'ED23'  'EDC'   'FCR'   'FCU'   'FDI'   'FDPr'  'FDPu'  'FDS'   'PL'    'Triceps'};
% s.Order = [4     5       6       7       3       11      2       20          19      17      18      12      13      14      15      1       9       10      8       16      21];
% % s.Order = [2     3       4       7       6       14      5       20          19      17      18      16      15      12      13      1       9       10      8       11      21];
% s.Type  = [1     1       1       1       1       2       1       2           2       2       2       2       2       2       2       1       2        2       2       2      2];
% 
% s.Group = [1     1       1       1       1       3       1       6           6       5       5       3       3       4       4       1       2        2       2       4      6];
% s.GroupN= [7 3 3 3 2 2];
% 
% [temp,s.Index]  = sort(s.Order);

if(~isempty(type))
    switch type
        case 'Txx'
%             s.onset  = [0.0047	0.0035];
            s.pwhm   = 0.007;
            s.TW     = [0.005 0.015;...
                0.003 0.013];


        case 'Cxx'
%             s.onset  = [0.0074	0.0052];
            s.pwhm   = 0.007;
            s.TW     = [0.007 0.017;...
                0.005 0.015];

    end
end
