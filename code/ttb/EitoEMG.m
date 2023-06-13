function s= EitoEMG(type)
% 
% （１）s.Name(s.Index)とすると機能順にならべたEMGNameを出力できる。
% （２）sortind(s.Name,s.Order)やsortmtx(MTX,s.Order)とすると（１）のEMGに対応した順番にソートできる

if nargin<1
    type    = [];
end

s.Name  = {'2DI' '3DI'   '4DI'   'AbDM'  'AbPB'  'AbPL'  'ADP'   'Biceps'    'BRD'   'ECR'   'ECU'   'ED23'  'EDC'   'FCR'   'FCU'   'FDI'   'FDPr'  'FDPu'  'FDS'   'PL'    'Triceps'};
s.Order = [4     5       6       7       3       11      2       20          19      17      18      12      13      14      15      1       9       10      8       16      21];
% s.Order = [2     3       4       7       6       14      5       20          19      17      18      16      15      12      13      1       9       10      8       11      21];
s.Type  = [1     1       1       1       1       2       1       2           2       2       2       2       2       2       2       1       2        2       2       2      2];

s.Group = [1     1       1       1       1       3       1       6           6       5       5       3       3       4       4       1       2        2       2       4      6];
s.GroupName = {'ihand','ehand-fx','ehand-ex','wrist-fx','wrist-ex','elbow'};
s.GroupN= [7 3 3 3 2 2];

[temp,s.Index]  = sort(s.Order);

if(~isempty(type))
    switch type
        case 'Txx'
            s.onset  = [0.0047	0.0035];
            s.pwhm   = 0.007;
            s.TW     = [0.005 0.015;...
                0.003 0.013];

            
        case 'Cxx'
            s.onset  = [0.0074	0.0052];
            s.pwhm   = 0.007;
            s.TW     = [0.007 0.017;...
                0.005 0.015];

    end
end

% s.sp_onset  = [0.0047	0.0047	0.0047	0.0047	0.0047	0.0035	0.0047	0.0035	0.0035	0.0035	0.0035	0.0035	0.0035	0.0035	0.0035	0.0047	0.0035	0.0035	0.0035	0.0035	0.0035];
% s.sp_pwhm   = 0.007;
% s.cx_onset  = [0.0074	0.0074	0.0074	0.0074	0.0074	0.0052	0.0074	0.0052	0.0052	0.0052	0.0052	0.0052	0.0052	0.0052	0.0052	0.0074	0.0052	0.0052	0.0052	0.0052	0.0052];
% s.cx_pwhm   = 0.007;
% 
% s.sp_TW     = [0.005 0.015;0.003 0.013];
% s.cx_TW     = [0.007 0.017;0.005 0.015];