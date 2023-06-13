function combinesta(method1,method2,weights,fullfilenames)

% combinesta(method1,method2)
%
% STA file�̌���
% ������STAfile���������܂��B
% ��������P�ʂƂ��āA���ꂼ��̃t�@�C���ŕ��ς������̂�
% ����ɕ��ς�����@�imethod1='file'�j�ƁA�S�Ẵt�@�C���Ɋ܂܂��tirial��
% �܂Ƃ߂ĕ��ς�����@(method2='trial')���I�ׂ܂��B
% �܂��A���ς���̂łȂ����v�������ꍇ��method2��'sum'�Ɠ��͂��Ă��������B
% 
% ����STA file�ɂ�����TrialsToUse��applyTrialsToUse(loaddata���ɍs��)�ɂ����
% �f�[�^�ɔ��f���ꂽ���ʍ폜����܂��B
% 
% ����
%   method1 'trial' or 'file' (or 'pseadjusted' or 'trial-to-trial')
%   method2 'average' or 'sum'
% 
% ��P�@������STA�t�@�C����Trial���܂Ƃ߂ĕ��ς������ꍇ
% combinesta('trial','average');
% �𑖂点��ƃG�N�X�v���[���������̂ŁA���ς������t�@�C����I�����A
% �E��box�Ɉړ����Ă��������B
% ���ׂđI���OK�������ƁA�������ɉ��Z���ς��J�n���܂��B
% 
% ���Z���ς��I������ƁA�o�̓t�H���_�Əo�̓t�@�C���𕷂����̂ŁA
% �㏑���ɒ��ӂ��ĕۑ����Ă��������B
% 
% ���ʂ́ADisplayData�Ŋm�F���邱�Ƃ��ł��܂��B
% 
% ��Q�@�eSTA�̕��ς����g�`���A����ɕ��ς������ꍇ
% combinesta('file','average');
% �𑖂点�āA���Ƃ͏�L�ƈꏏ�ł��B
% 
% 
% see also, sta, sta_btc, displaydata
%
% Written by Takei 2010/09/29



if(nargin<1)
    method1     = 'trial';
    method2     = 'average';
    weights     = [];
    fullfilenames   = matexplorer;
elseif(nargin<2)
    method2     = 'average';
    weights     = [];
    fullfilenames   = matexplorer;
elseif(nargin<3)
    weights     = [];
    fullfilenames   = matexplorer; 
elseif(nargin<4)
    fullfilenames   = matexplorer; 
end

if(isempty(fullfilenames))
    disp('User pressed cancel')
    return;
end

if(isempty(fullfilenames))
    disp('User pressed cancel')
    return;
end


nfiles  = length(fullfilenames);
if(isempty(weights))
    weights = ones(nfiles,1);
end
weights     = shiftdim(weights);

if(length(weights)~=nfiles)
    error('Size of weights and files have to be same.')
end


switch lower(method1)
    case 'file'
        indicator(0,nfiles);
        for ifile=1:nfiles
            fullfilename    = fullfilenames{ifile};
            SS_hdr          = load(fullfilename);
            if(isfield(SS_hdr,'TrialsToUse'))
                [pathname,filename] = fileparts(fullfilename);
                SS_dat  = load(fullfile(pathname,['._',filename,'.mat']));
                [SS_hdr,SS_dat] = applyTrialsToUse(SS_hdr,SS_dat);
            end
            if(ifile==1)
                S_hdr   = SS_hdr;
                
                % Prepare default output
                S_hdr.TrialData     = 1;
                S_hdr.nTrials       = nfiles;
                S_hdr.Weights       = weights;
                if(isfield(SS_hdr,'ISATrialData'))
                    S_hdr.ISATrialData  = 1;
                end
                S_hdr.CreationMethod    = 'combinesta';
                S_hdr.MethodOptions     = {method1,method2};
                S_hdr.SourceFiles       = fullfilenames;
                
                
                S_dat.Name              = [];
                S_dat.hdr_file          = [];
                S_dat.TrialData         = nan(nfiles,size(S_hdr.XData,2));
                if(isfield(SS_hdr,'ISATrialData'))
                    S_dat.ISATrialData  = nan(nfiles,size(S_hdr.XData,2));
                end
            end
%             keyboard
            S_dat.TrialData(ifile,:)    = SS_hdr.YData * weights(ifile);
            if(isfield(S_dat,'ISATrialData'))
                S_dat.ISATrialData(ifile,:) = SS_hdr.ISAData * weights(ifile);
            end
            
            indicator(ifile,nfiles);
        end
        
        
        switch lower(method2)
            case 'average'
                S_hdr.YData         = mean(S_dat.TrialData,1);
                if(isfield(S_dat,'ISATrialData'))
                    S_hdr.ISAData   = mean(S_dat.ISATrialData,1);
                end
                
            case 'sum'
                S_hdr.YData         = sum(S_dat.TrialData,1);
                if(isfield(S_dat,'ISATrialData'))
                    S_hdr.ISAData   = sum(S_dat.ISATrialData,1);
                end
        end        

    case 'trial'
        indicator(0,nfiles);
        for ifile=1:nfiles
            fullfilename    = fullfilenames{ifile};
            SS_hdr          = load(fullfilename);
            
            % load dat file
            [pathname,filename] = fileparts(fullfilename);
            SS_dat  = load(fullfile(pathname,['._',filename,'.mat']));
            [SS_hdr,SS_dat] = applyTrialsToUse(SS_hdr,SS_dat);
            
            
            if(ifile==1)
                S_hdr   = SS_hdr;
                S_dat   = SS_dat;
                
                % Prepare default output
                S_hdr.TrialData     = 1;
                if(isfield(SS_hdr,'ISATrialData'))
                    S_hdr.ISATrialData  = 1;
                end
                S_hdr.CreationMethod    = 'combinesta';
                S_hdr.MethodOptions     = {method1,method2};
                S_hdr.SourceFiles       = fullfilenames;
                
                
                S_dat.TrialData         = cell(nfiles,1);
                if(isfield(SS_hdr,'ISATrialData'))
                    S_dat.ISATrialData  = cell(nfiles,1);
                end
            end
            
            S_dat.TrialData{ifile}      = SS_dat.TrialData * weights(ifile);
            if(isfield(S_dat,'ISATrialData'))
                S_dat.ISATrialData{ifile}   = SS_dat.ISATrialData * weights(ifile);
            end
            
            indicator(ifile,nfiles);
        end
        
        S_dat.TrialData = cat(1,S_dat.TrialData{:});
        if(isfield(S_dat,'ISATrialData'))
            S_dat.ISATrialData = cat(1,S_dat.ISATrialData{:});
        end
        
        S_hdr.nTrials       = size(S_dat.TrialData,1);
        
        switch lower(method2)
            case 'average'
                S_hdr.YData         = mean(S_dat.TrialData,1);
                if(isfield(S_dat,'ISATrialData'))
                    S_hdr.ISAData   = mean(S_dat.ISATrialData,1);
                end
                
            case 'sum'
                S_hdr.YData         = sum(S_dat.TrialData,1);
                if(isfield(S_dat,'ISATrialData'))
                    S_hdr.ISAData   = sum(S_dat.ISATrialData,1);
                end
        end
        
    case 'pseadjusted'
        indicator(0,nfiles);
        psename = [];
        for ifile=1:nfiles
            fullfilename    = fullfilenames{ifile};
            SS_hdr          = load(fullfilename);
            if(isempty(psename))
                psename = strfilt(fieldnames(SS_hdr),'pse');
                if(iscell(psename))
                    psename = psename{1};
                end
            end
                        
            [SS_hdr.YData,SS_hdr.XData,BaseLine,BaseMean,BaseSD,SS_hdr.Unit]    = pseadjust(SS_hdr,psename,'%');
            
            
%             if(isfield(SS_hdr,'TrialsToUse'))
%                 [pathname,filename] = fileparts(fullfilename);
%                 SS_dat  = load(fullfile(pathname,['._',filename,'.mat']));
%                 [SS_hdr,SS_dat] = applyTrialsToUse(SS_hdr,SS_dat);
%             end
            if(ifile==1)
                S_hdr   = SS_hdr;
                
                % Prepare default output
                S_hdr.TrialData     = 1;
                S_hdr.nTrials       = nfiles;
                S_hdr.Weights       = weights;
                if(S_hdr.ISA_flag==1)
                    S_hdr.ISA_flag = 0;
                end
                if(S_hdr.ISA_flag==1)
                    S_hdr   = rmfield(S_hdr,'ISATimeWindow');
                end
                if(isfield(S_hdr,'ISATrialData'))
                    S_hdr   = rmfield(S_hdr,'ISATrialData');
                end
                if(isfield(S_hdr,'ISAData'))
                    S_hdr   = rmfield(S_hdr,'ISAData');
                end
                if(isfield(S_hdr,'nISA'))
                    S_hdr   = rmfield(S_hdr,'nISA');
                end

                S_hdr.CreationMethod    = 'combinesta';
                S_hdr.MethodOptions     = {method1,method2};
                S_hdr.SourceFiles       = fullfilenames;
                
                
                S_dat.Name              = [];
                S_dat.hdr_file          = [];
                S_dat.TrialData         = nan(nfiles,size(S_hdr.XData,2));
            end
%             keyboard
            S_dat.TrialData(ifile,:)    = SS_hdr.YData * weights(ifile);
            
            indicator(ifile,nfiles);
        end
        
        
        switch lower(method2)
            case 'average'
                S_hdr.YData         = mean(S_dat.TrialData,1);
                
                
            case 'sum'
                S_hdr.YData         = sum(S_dat.TrialData,1);
        end
        
    case 'trial-to-trial'
        
        indicator(0,nfiles);
        for ifile=1:nfiles
            fullfilename    = fullfilenames{ifile};
            SS_hdr          = load(fullfilename);
            
             % load dat file
            [pathname,filename] = fileparts(fullfilename);
            SS_dat  = load(fullfile(pathname,['._',filename,'.mat']));
            
            if(ifile==1)
                S_hdr   = SS_hdr;
                
                % Prepare default output
                S_hdr.TrialData     = 1;
                S_hdr.nTrials       = nfiles;
                S_hdr.Weights       = weights;
                if(S_hdr.ISA_flag==1)
                    S_hdr.ISA_flag = 0;
                end
                if(S_hdr.ISA_flag==1)
                    S_hdr   = rmfield(S_hdr,'ISATimeWindow');
                end
                if(isfield(S_hdr,'ISATrialData'))
                    S_hdr   = rmfield(S_hdr,'ISATrialData');
                end
                if(isfield(S_hdr,'ISAData'))
                    S_hdr   = rmfield(S_hdr,'ISAData');
                end
                if(isfield(S_hdr,'nISA'))
                    S_hdr   = rmfield(S_hdr,'nISA');
                end

                S_hdr.CreationMethod    = 'combinesta';
                S_hdr.MethodOptions     = {method1,method2};
                S_hdr.SourceFiles       = fullfilenames;
                
                
                S_dat.Name              = [];
                S_dat.hdr_file          = [];
                S_dat.TrialData         = nan([size(SS_dat.TrialData),nfiles]);
            end
%             keyboard
            S_dat.TrialData(:,:,ifile)    = SS_dat.TrialData * weights(ifile);
            
            indicator(ifile,nfiles);
        end
        
        S_dat.TrialData = squeeze(nanmean(S_dat.TrialData,3));
        
        switch lower(method2)
            case 'average'
                S_hdr.YData         = mean(S_dat.TrialData,1);
                
                
            case 'sum'
                S_hdr.YData         = sum(S_dat.TrialData,1);
        end
        
        
end

psenames    = fieldnames(S_hdr);
psenames    = strfilt(psenames,'pse');
if(~isempty(psenames))
    S_hdr	= rmfield(S_hdr,psenames);
end
if(isfield(S_hdr,'TimeStamps'))
    S_hdr	= rmfield(S_hdr,'TimeStamps');
end
if(isfield(S_hdr,'TimeLabels'))
    S_hdr   = rmfield(S_hdr,'TimeLabels');
end



indicator(0,0);

% Output
[pathname,filename,ext] = fileparts(fullfilenames{1});
% filename    = [filename,ext];
pathname    = getconfig(mfilename,'pathname');
if(isempty(pathname)||~ischar(pathname)) 
    pathname            = pwd;
end
if(~exist(pathname,'dir')) 
    pathname            = pwd;
end
pause(0.5)
[filename,pathname] = uiputfile(fullfile(pathname,[filename,'.mat']));
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
    return;
end

if(strcmp(filename(1:2),'._'))
    filename(1:2)   = [];
end

hdrName = deext(filename);
datName = ['._',hdrName];

S_hdr.Name      = hdrName;
S_hdr.data_file = datName;
S_dat.Name      = datName;
S_dat.hdr_file  = hdrName;

save(fullfile(pathname,[hdrName,'.mat']),'-struct','S_hdr');
save(fullfile(pathname,[datName,'.mat']),'-struct','S_dat');
disp(fullfile(pathname,[hdrName,'.mat']))
disp(fullfile(pathname,[datName,'.mat']))
setconfig(mfilename,'pathname',pathname)