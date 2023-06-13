function getPMID_btc

[parentpath] =uigetdir('W:\www\xoops\modules\PubMedPDF\papers');
outputpath  = fullfile(parentpath,'PMID');
mkdir(outputpath);
    
pdffiles    = dir(parentpath);
pdffiles    = {pdffiles([pdffiles(:).isdir]==0).name};

npdffiles   = length(pdffiles);
ispdf       = false(1,npdffiles);
for ii      = 1:npdffiles
    pdffile = pdffiles{ii};
    ispdf(ii) = ~isempty(strfind(pdffile,'.pdf'));
end
pdffiles    = pdffiles(ispdf);
npdffiles   = length(pdffiles);


for ii  = 1:npdffiles
    pdffile = fullfile(parentpath,pdffiles{ii});


    open(pdffile);
    prompt={'検索に用いる言葉（タイトルなど）を入力してください'};
    name='検索ワード';
    numlines=1;
    defaultanswer={''};
    search_words=inputdlg(prompt,name,numlines,defaultanswer);

    search_words    = search_words{1};
    
    disp('検索中...')
    [pmids,titles] = getPMID(search_words);
    disp('検索完了')

    fig = figure('Name','希望のファイルを選択してください。',...
        'DeleteFcn',@close_callback,...
        'NumberTitle','off',...
        'Menubar','none',...
        'Toolbar','none');
    h   = uicontrol(fig,'Unit','normalize',...
        'Style','listbox',...
        'String',titles,...
        'position',[0.05 0.05 0.9 0.9]);

    uiwait(fig);

    pmid    = pmids(ind);
    pdftitle    = titles{ind};
    
    outputfile  = fullfile(outputpath,[num2str(pmid),'.mat']);

    suc = copyfile(pdffile,outputfile);
    if(suc)
        disp(['(',num2str(ii),'/',num2str(npdffiles),') ',outputfile,' was created.'])
    else
        disp(['***** error occurred in ',outputfile])

    end
end

    function close_callback(varargin)
        ind = get(h,'Value');
    end
end
