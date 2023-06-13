function randreset(nseed)

if(nargin<1)
    nseed  = 0;
end

s = RandStream.create('mt19937ar','seed',nseed);
 RandStream.setDefaultStream(s);
 