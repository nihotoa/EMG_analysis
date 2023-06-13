function y  = windrive

ind = false(1,26);
y   = cell(1,26);
for ii  = 65:90
    y{ii}   = [char(ii),':'];
    if(exist(y{ii},'dir'))
        ind(ii) = true;
    end
end

y   = y(ind);
    