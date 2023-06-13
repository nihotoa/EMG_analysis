function mpack

% carefully chose pack filename
yn  = 1;
while(yn)
%     packfile = ['mpack',char(96+ceil(rand(1,12)*26)),'.mat'];
    packfile = [tempname,'.mat'];
    yn      = exist(packfile,'file');
end

% eval(['save(''',packfile,''');clear;load(''',packfile,''');delete(''',packfile,''');'])
evalin('caller',['save(''',packfile,''');clear;load(''',packfile,''');delete(''',packfile,''');'])
