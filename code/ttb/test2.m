clear; p=[];
nrep    = 1000;
nset    = 10000;
NMFID   =1;
x   = [0.272410162
0.420706062
0.498415366
0.594211592
0.785192946
0.419991252
0.363437006
0.769822035
0.749324366
0.604538461
0.409366921
0.394325582
0.824993785
0.469378367
0.533898968
0.730850772
0.4214195
0.282661657
0.903914337
0.595603326
0.372422427
0.783167807
0.584073672
];
for randset=5000:7500
[rMPI,CA,Ind,sortCA]  =mfield_montecarlo(nrep,'within',randset);
for irep=1:nrep
a(:,irep)=sortCA{irep}(:,NMFID);
end
clc;
m=mean(a,1);
%m=mean(acosd(a),1);
limits	= prctile(m,97.5);
hlimits = mean(x)>prctile(m,97.5);
[httest1,pttest1]=ttest2(reshape(x,numel(x),1),reshape(a,numel(a),1),0.05,'both','equal');%disp(pttest1)
% [prstest1,hrstest1]=ranksum(reshape(x,numel(x),1),reshape(a,numel(a),1),'method','exact');disp(prstest1)
[prstest2,hrstest2]=ranksum(reshape(x,numel(x),1),reshape(a,numel(a),1),'method','approximate');%disp(prstest2)
[httest2,pttest2]=ttest2(reshape(x,numel(x),1),reshape(a,numel(a),1),0.05,'both','unequal');
[hkstest,pkstest]=kstest2(reshape(x,numel(x),1),reshape(a,numel(a),1));


pp=[randset,limits,hlimits,pttest1,prstest2,pttest2,pkstest];
p   = [p;pp];
disp(p)
[minp,minpind]=min(p)
disp(randset)
save('20110913b.mat')
end