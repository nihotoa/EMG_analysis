function s= AobaEMG(type)
% 
% （１）s.Name(s.Index)とすると機能順にならべたEMGNameを出力できる。
% （２）sortind(s.Name,s.Order)やsortmtx(MTX,s.Order)とすると（１）のEMGに対応した順番にソートできる

if nargin<1
    type    = [];
end

s.Name  = {'2DI' '3DI'   '4DI'   'AbDM'  'AbPB'  'AbPL'  'ADP'   'Biceps'    'BRD'   'ECR'   'ECU'   'ED23'  'EDC'   'FCR'   'FCU'   'FDI'   'FDPr'  'FDPu'  'FDS'   'PL'    'Triceps'};
s.Name  = {'AbDM'    'AbPB'    'ADP'    'Biceps'    'BRD'    'ECRb'    'ECRl'    'ECU'    'ED23'    'ED45'    'EDC'    'FCR'    'FCU'    'FDI'    'FDPr'    'FDPu'    'FDS'    'PL'    'PT'};
s.Order = [];
s.Type  = [1     1       1       1       1       2       1       2           2       2       2       2       2       2       2       1       2        2       2       2      2];
s.TypeName  = {'hand','arm'};
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