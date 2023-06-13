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
    prompt={'�����ɗp���錾�t�i�^�C�g���Ȃǁj����͂��Ă�������'};
    name='�������[�h';
    numlines=1;
    defaultanswer={''};
    search_words=inputdlg(prompt,name,numlines,defaultanswer);

    search_words    = search_words{1};
    
    disp('������...')
    [pmids,titles] = getPMID(search_words);
    disp('��������')

    fig = figure('Name','��]�̃t�@�C����I�����Ă��������B',...
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
