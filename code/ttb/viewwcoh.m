function viewwcoh(varargin)
if nargin < 1
    [s,f]   = topen;
else
    s   = varargin{1};
    f   = varargin{2};
end

if(~iscell(s))
    s   ={s};
    f   ={f};
end

for ii=1:length(s)
    figure('FileName',f{ii},...
        'Name',f{ii},...
        'NumberTitle','off');
    if(islogical(s{ii}.cxy))
        s{ii}.cxy =double(s{ii}.cxy);
    end
    H   = pcolor(s{ii}.t,s{ii}.freq,s{ii}.cxy);
    h   = gca;
    shading('flat')
    set(h,'CLim',[s{ii}.cl.ch_c95,max(max(s{ii}.cxy,[],2),[],1)]);
    % caxis(h,[s{ii}.cl.ch_c95,max(max(s{ii}.cxy,[],2),[],1)])
    colormap(tmap2)
    colorbar
    [pare,file,ext] =fileparts(f{ii}); 
    title(h,{pare;[file ext];['(Trials =',num2str(s{ii}.cl.seg_tot),')']})
    ylabel(h,'frequency(Hz)');
    xlabel(h,'time(s)')
end
