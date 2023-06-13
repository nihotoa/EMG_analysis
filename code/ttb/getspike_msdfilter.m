function getspike_msdfilter
global gsobj;

localmax    = get(gsobj.handles.rb_localmax,'Value');

timestamps  = gsobj.spike.Data;
% YData       = gsobj.scope.YData;
% XData       = gsobj.scope.XData;
ntimestamps = length(timestamps);
SampleRate  = gsobj.unit.SampleRate;
% nUnitData   = length(gsobj.unit.Data);

% Window      = gsobj.scope.Window;
% Window      = [0 4];     % ms spike ���炱�͈̔͂�msd��������̂�filter���� for unit
Window      = [-4 0];     % ms spike ���炱�͈̔͂�msd��������̂�filter���� for unit MSD�ł͂Ȃ��A��xoffline��isolate����timestamp���g���Ƃ��B
% Window      = [-20 -5];     % ms spike ���炱�͈̔͂ɂ�msd��������̂�filter���� for MEP
% Window      = [-3072 1024];     % ms spike ���炱�͈̔͂ɂ�����̂�filter����

Reflactory  = gsobj.scope.Reflactory;


msdstamps       = gsobj.msd.Data;
msdSampleRate   = gsobj.msd.SampleRate;
msdstamps       = round((msdstamps * SampleRate) / msdSampleRate);  % Unit�̃T���v�����O���[�g�ɂ��킹��

% keyboard
if(isfield(gsobj.spike,'addflag'))
    addflag     = gsobj.spike.addflag;
else
    addflag     = true(size(timestamps))';
end

% SampleRate  = gsobj.unit.SampleRate;
% dt          = gsobj.unit.dt;
% nUnitData   = length(gsobj.unit.Data);

WindowIndex = round((Window/1000) * SampleRate);
ReflactoryIndex = max(round((Reflactory/1000) * SampleRate),1);
WindowIndexLength   = WindowIndex(2) - WindowIndex(1) + 1;


Indeces     = repmat([WindowIndex(1):WindowIndex(2)],ntimestamps,1) + repmat(timestamps',1,WindowIndexLength);


msdflag     = any(ismember(Indeces,msdstamps),2);

addflag     = (msdflag & addflag);

% timestamps  = timestamps(StartWindowIndeces >= 1 & StopWindowIndeces <= nUnitData);

gsobj.spike.addflag = addflag;
gsobj.spike.Data    = timestamps;

