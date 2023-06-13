function HDR    = wvfloadhdr(filename)
% •¡”‚ÌGroupATrace‚É–¢‘Î‰ž
% 
% written by TT 070615

[fields,values] = textread(filename,'%s %s','commentstyle','c++');
% Check group number
ind = strmatch('GroupNumber',fields);
nGroup  = eval(values{ind});
if nGroup > 1
    error('Too many groups.')
end   

ind = strmatch('$',fields);
fields(ind)  = [];
values(ind) = [];

% parsing
for ii  = 1:length(fields)
    % delete '.' in filed names 
    ind = strfind(fields{ii},'.');
    fields{ii}(ind) =[];
    
    % converse numstring to num
    if(~strcmpi(fields{ii},'Date') && ~strcmpi(fields{ii},'Time'))
        num = str2num(values{ii});
        if(~isempty(num))
            values{ii}  = num;
        end
    end
end
    

HDR = cell2struct(values,fields,1);