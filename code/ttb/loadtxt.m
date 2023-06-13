function [Y,H]  = loadtxt(fullfilename)
% matrix状に並んだデータを含むテキストファイルをcell配列に読み込む

% written by tomohiko takei 20101222


if nargin<1
    fullfilename    = getconfig(mfilename,'fullfilename');
    if(~exist(fullfilename,'file'))
        fullfilename    = fullfile(pwd,'*.*');
    end
    [filename,pathname] = uigetfile(fullfilename);
    if(isequal(filename,0)||isequal(pathname,0))
        disp('User pressed cancel')
        return;
    end
    fullfilename        = fullfile(pathname,filename);
    
    setconfig(mfilename,'fullfilename',fullfilename);
end

fid = fopen(fullfilename,'r');

Y   = [];
H   = [];
while(1)
    tline   = fgetl(fid);
    if ~ischar(tline)
        break
    end
    
    if(strcmp(tline(1),'%'))% if header line...
        H   = textscan(tline,'%s');
        H   = H{1}';
        H(1)    = [];
        
    else
        
        cline    = eval(['{',tline,'}']);
        if(isempty(Y))
            Y   = cline;
        else
            Y   = [Y;cline];
        end
    end
end



fclose(fid);
