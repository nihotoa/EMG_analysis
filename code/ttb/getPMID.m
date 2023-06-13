function [pmids,titles] = getPMID(search_words)

ii  =0;
while(~isempty(search_words))
    ii  = ii+1;
    [search_word{ii},search_words]  = strtok(search_words);
end
nwords   = ii;

search_words    = search_word{1};
for ii=2:nwords
search_words    = [search_words,'%20',search_word{ii}];
end

% disp(search_words)
url = ['http://www.ncbi.nlm.nih.gov/sites/entrez?term=',search_words,'&sourceid=mozilla-search&db=pubmed&orig_db=PubMed&dispmax=20&dopt=DocSum'];
s   = urlread(url);

% disp('ŒŸõ’†...')
startindexes    = strfind(s,'PMID: ')+6;
stopindexes    = strfind(s,' [PubMed -')-1;
titleindexes    = strfind(s,'.Pubmed_RVDocSum">')+18;

nPMID   = length(stopindexes);
for ii=1:nPMID
pmids(ii,1)    = str2double(deblank(s(startindexes(ii):stopindexes(ii))));
titles{ii,1}      = s([0:100]+titleindexes(ii));
end
