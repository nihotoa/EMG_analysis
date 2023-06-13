timeWin = [-500,30];%msec
timeWin = timeWin/10; %convert to datapoint(100Hz)
% load('SesekiL_control3_leverOn_AveAll.mat')
load('SesekiL_control3_photoOn_AveAll.mat')
controls = cell(12,1);
for m=1:12
controls{m}=[AveAll{m,1}' AveAll{m,2}' AveAll{m,3}'];
end
% load('SesekiL_standard_28_leverOn_AveAll.mat')
load('SesekiL_standard_28_photoOn_AveAll.mat')
posts = cell(12,1);
controlAve = zeros(201,12);
for m=1:12
% posts{m}=[AveAll{m,1}' AveAll{m,2}' AveAll{m,3}' AveAll{m,4}' AveAll{m,5}' AveAll{m,6}' AveAll{m,7}' AveAll{m,8}' AveAll{m,9}' AveAll{m,10}' AveAll{m,11}' AveAll{m,12}' AveAll{m,13}' AveAll{m,14}' AveAll{m,15}' AveAll{m,16}' AveAll{m,17}' AveAll{m,18}' AveAll{m,19}' AveAll{m,20}' AveAll{m,21}' AveAll{m,22}' AveAll{m,23}' AveAll{m,24}' AveAll{m,25}' AveAll{m,26}' AveAll{m,27}' AveAll{m,28}'];
posts{m}=[AveAll{m,1}' AveAll{m,2}' AveAll{m,3}' AveAll{m,4}' AveAll{m,5}' AveAll{m,6}' AveAll{m,7}' AveAll{m,8}' AveAll{m,9}' AveAll{m,11}' AveAll{m,13}' AveAll{m,14}' AveAll{m,15}' AveAll{m,16}' AveAll{m,17}' AveAll{m,18}' AveAll{m,20}' AveAll{m,21}' AveAll{m,22}' AveAll{m,23}' AveAll{m,24}' AveAll{m,25}' AveAll{m,26}' AveAll{m,27}' AveAll{m,28}'];
controlAve(:,m) = mean(controls{m},2);
end
XCorrDataSets.EMGs = {'EDC','ED23','ED45','ECU','ECR','Deltoid','FDS','FDP','FCR','FCU','PL','BRD'}';
XCorrDataSets.Data = cell(12,1);
XCorrDataSets.Results = cell(12,1);
for m=1:12
XCorrDataSets.Data{m} = [controlAve(101+timeWin(1):101+timeWin(2),:) controls{m}(101+timeWin(1):101+timeWin(2),:) posts{m}(101+timeWin(1):101+timeWin(2),:)];
Alt = corrcoef(XCorrDataSets.Data{m});
XCorrDataSets.Results{m} = Alt(1:12,13:end);
end