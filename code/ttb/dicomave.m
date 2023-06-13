function dicomave

pathname1   = uigetdir(pwd,'Pick a DICOM directory1');
pathname2   = uigetdir(pwd,'Pick a DICOM directory2');
pathname3   = uigetdir(pwd,'Select output directory');

filename1   = dir(fullfile(pathname1,'*.dcm'));
filename2   = dir(fullfile(pathname2,'*.dcm'));


nfile1      = length(filename1);
nfile2      = length(filename2);
if(nfile1~=nfile2)
    error('no match number of files.')
end
if(nfile1==0)
    error('no DICOM files.')
end

uid     = dicomuid;
[SUCCESS,MSG,MSGID] = mkdir(pathname3,uid);
if(~SUCCESS)
    error(MSGID,MSG)
    return
end

warning off
for ii  = 1:nfile1
    fullfilename1   = fullfile(pathname1,filename1(ii).name);
    fullfilename2   = fullfile(pathname2,filename2(ii).name);
    
    info1   = dicominfo(fullfilename1);
    info2   = dicominfo(fullfilename2);
    info3   = info1;
    info3.SeriesInstanceUID = uid;

    image1  = dicomread(info1);
    image2  = dicomread(info2);
    image3  = imlincomb(.5,image1,.5,image2);
    
    fullfilename3   = fullfile(pathname3,uid,['average',num2str(ii),'.dcm']);
    dicomwrite(image3,fullfilename3,info3)
    
    indicator(ii,nfile1)
end
warning on    
% [filename1, pathname1]  = uigetfile('*.dcm', 'Pick a dicom-file', 'MultiSelect', 'on');
% [filename2, pathname2]  = uigetfile('*.dcm', 'Pick a dicom-file', 'MultiSelect', 'on');
% 
% fullfilename1   = fullfile(pathname1,filename1);
% fullfilename2   = fullfile(pathname2,filename2);
% 
% info1   = dicominfo(fullfilename1);
% info2   = dicominfo(fullfilename2);
% 
% image1  = dicomread(info1);
% image2  = dicomread(info2);
% image3  = imlincomb(.5,image1,.5,image2);
% 
% uid     = dicomuid;
% info3   = info1;
% info3.SeriesInstanceUID = uid;
% pathname3   = uigetdir;
% [SUCCESS,MESSAGE,MESSAGEID] = mkdir(pathname3,average);
% if(SUCCESS)
%     fullfilename3   = fullfile(pathname3,uid,'ave1.dcm');
%     dicomwrite(image3,fullfilename3,info3)
% else
%     disp('error')
% end