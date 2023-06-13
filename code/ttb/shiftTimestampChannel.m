function S=shiftTimestampChannel(s,dt)

S   = s;
dtind   = round(dt.*S.SampleRate);      % SampleRate�̕␳
TimeRangeInd    = (S.TimeRange-S.TimeRange(1)).*S.SampleRate;

S.Data  = S.Data + dtind;
S.Data  = S.Data(S.Data>=TimeRangeInd(1) & S.Data<=TimeRangeInd(2));








