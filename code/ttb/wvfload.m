function varargout  = wvfload(varargin)


warning('off')
if nargin < 1
    HDRfile = uigetfullfile(fullfile('*','*.hdr'),'Pick a wvf header file (.HDR)');
else 
    HDRfile = varargin{1};
end

% open HDR file
[pn,fn,ext,v]   = fileparts(HDRfile);
WVFfile     = fullfile(pn, [fn, '.wvf']);
HDR         = wvfloadhdr(HDRfile);

% wvf File‚©‚çdata‚Ì“Ç‚Ýž‚Ý
fid     = fopen(WVFfile,'r');
status  = fseek(fid, HDR.DataOffset, -1);
switch HDR.VDataType(1:2)
    case 'IS'
        DataFormat{1}  = ['int',num2str(eval(HDR.VDataType(3)) * 8)];
    case 'IU'
        DataFormat  = ['uint',num2str(eval(HDR.VDataType(3)) * 8)];
    case 'FS'
        DataFormat{1}  = ['float64',num2str(eval(HDR.VDataType(3)) * 8)];
    case 'FU'
        DataFormat  = ['float64',num2str(eval(HDR.VDataType(3)) * 8)];
    otherwise 'B'
        DataFormat  = 'bitN';
end
DataFormat
Data    = fread(fid,inf,DataFormat);
fclose(fid);

% convert binary to voltage value
Data    = HDR.VResolution * Data + HDR.VOffset;

% rearrang data
Data    = Data(1:(HDR.BlockSize * HDR.BlockNumber));
Data    = reshape(Data,[HDR.BlockSize,HDR.BlockNumber]);

% % time scale
% t       = HDR.HResolution * ([1:HDR.BlockSize] - (HDR.DisplayPointNo + HDR.TriggerPointNo)) + HDR.HOffset;
% tTrigger    = t(HDR.DisplayPointNo + HDR.TriggerPointNo);
% DisplayRange(1) = t(HDR.DisplayPointNo);
% DisplayRange(2) = t(HDR.DisplayPointNo + HDR.DisplayBlockSize);
% 
% % plot
% figure
% plot(t,Data,'k')
% hold on
% plot(t,mean(Data,2),'r')
% hold off
% axis([DisplayRange(1) DisplayRange(2) -Inf Inf])
% title(WVFfile);
% ylabel(HDR.VUnit);
% xlabel(HDR.HUnit);

% argout
if nargout == 1
    varargout   = Data;
elseif nargout == 2
    varargout   = {Data,HDR};
elseif nargout == 3
    varargout   = {Data,HDR,WVFfile};
end
    

warning('on')

