function xtalkchk_btc

th          = 0.25;

Exps        = gsme;
ChanNames   = getchanname;
OutputDir   = uigetdir(fullfile(datapath,'XTALKCHK'));
if(~exist(OutputDir,'dir'))
    mkdir(OutputDir);
end

nExp        = length(Exps);
nChan       = length(ChanNames);
for iExp =1:nExp
    Exp         = Exps(iExp);
    S           = xtalkchk(Exp,ChanNames);
    S.isxtalk   = S.lRlmaxs>th;
    S.th        = 0.25;
    S.randseed  = logical(makerandseed(nChan));
    S.isxtalkA  = any(S.isxtalk & S.randseed,2);
    S.isxtalkB  = any(S.isxtalk & ~S.randseed,2);
        
    ExpName = get(Exp,'Name');
    Outputfile  = fullfile(OutputDir,ExpName);
    save(Outputfile,'-struct','S');
    disp(Outputfile)
end


function r  =makerandseed(n)

for ii=1:n
    a   = rand(n-ii,1)>0.5;
    R(ii,:,:)   = diag(a,ii);
    R(n+ii,:,:) = diag(1-a,-1*ii);
end

r   = squeeze(sum(R,1));
    

