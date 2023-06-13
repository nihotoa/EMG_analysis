function varargout = analysescomp(objects, command, varargin)
% modified by TT
% TrialStorageCapを変更できるようにした。（Tag='070808'）
TSC     = 653400;    % TrialStorageCap　added by TT 070808

switch lower(command)
   case 'preprocess'
      preprocess(objects, varargin{:})
   case 'postprocess'
      postprocess(objects)
   case 'xdata'
      xdata(objects);
   case 'refschanged'
      refsChanged(objects);
   case 'recalculate'
      recalculate(objects);
   case 'getparameter'
      [varargout{1:nargout}] = getParameter(objects, varargin{:});
   case 'validrefs'
      varargout{1} = validRefs(objects, varargin{:});
   case 'verify'
      if nargin < 3
         [varargout{[1 2]}] = verify(objects);
      else
         [varargout{[1 2]}] = verify(objects, varargin{:});
      end
   case 'filterobjs'
      if nargin > 2
         varargout{1} = filterObjs(objects, varargin{:});
      else
         varargout{1} = filterObjs(objects);
      end
   case 'signalopobjs'
      if nargin > 2
         varargout{1} = signalOpObjs(objects, varargin{:});
      else
         varargout{1} = signalOpObjs(objects);
      end
   otherwise
      error(['Invalid analyses component command - ' command]);
end




function refs = validRefs(objects, prop)
%

refs = [];
Parent = parent(objects(1));
ObjectsToAnalyze = get(Parent, 'ObjectsToAnalyze');
if isempty(ObjectsToAnalyze)
   ObjectsToAnalyze = analyses(Parent, 'lastobjectanalyzed');
   if isempty(ObjectsToAnalyze)
      return
   end
end

if strcmp('experiment set', mdaclass(ObjectsToAnalyze(1)))
   ObjectsToAnalyze = expset(ObjectsToAnalyze(1), 'experimentobjs');
   if isempty(ObjectsToAnalyze)
      return
   end
end

switch prop
   case 'Reference'
      switch subclass(objects(1))
         case {'perievent histogram', 'triggered average', 'triggered power spectrum', 'triggered spectrogram', 'window count', ...
               'window average', 'count'} %[fft][tsg]
            refs = experiment(ObjectsToAnalyze(1), 'channelobjs', 'timestamps');
         case 'sweep average'
            refs = experiment(ObjectsToAnalyze(1), 'channelobjs', 'sweeps');
            %[ita]
         case {'interval average', 'interval count'}
            refs = experiment(ObjectsToAnalyze(1), 'channelobjs', 'intervals');
      end
   case 'Target'
      switch subclass(objects(1))
         case {'perievent histogram', 'window count', 'interval count'}
            refs = experiment(ObjectsToAnalyze(1), 'channelobjs', 'timestamps');
         case {'triggered average', 'triggered power spectrum', 'triggered spectrogram', ...
               'window average', 'interval average'} %[fft][tsg][ita]
            refs = experiment(ObjectsToAnalyze(1), 'channelobjs', 'continuous');
      end
end







function varargout = getParameter(objects, paramname)
%

global ANALYSES_COMPONENT

switch paramname
   case 'editing dialog'
      Index = find(strcmp(subclass(objects(1)), {ANALYSES_COMPONENT.TYPES.SubClass}));
      varargout{1} = ANALYSES_COMPONENT.TYPES(Index).EditingDialog;
      if nargout > 1
         varargout{2} = mdadir('ANALYSES_COMPONENT_DLGS');
      end
   case 'formal name'
      [varargout{1:nargout}] = analyses(parent(objects(1)), 'getparameter', paramname);
end





function pOut = preprocessRef(p, props, buffer)
%
pOut = p;
pOut.RefDataBuffer = bufferset(buffer, 'activate', {props.Reference});
Error = get(pOut.RefDataBuffer, 'Error');
if Error
   error('MDA:analysesErrorInReference', ['reference channel (' props.Reference ') has an error']);
end
pOut.RefBuffIndex = databuffer(pOut.RefDataBuffer, 'index');
if ~strcmp(get(pOut.RefDataBuffer, 'SubClass'), 'intervals')
   pOut.RefSampleRate = get(pOut.RefDataBuffer, 'SampleRate');
end
pOut.HasReference = 1;





function pOut = preprocessTarget(p, props, buffer)
%
pOut = p;
pOut.TargetDataBuffer = bufferset(buffer, 'activate', {props.Target});
Error = get(pOut.TargetDataBuffer, 'Error');
if Error
   error('MDA:analysesErrorInTarget', ['target channel (' props.Target ') has an error']);
end
pOut.TargetBuffIndex = databuffer(pOut.TargetDataBuffer, 'index');
if ~strcmp(mdaclass(pOut.TargetDataBuffer), 'intervals')
   pOut.TargetSampleRate = get(pOut.TargetDataBuffer, 'SampleRate');
end
pOut.HasTarget = 1;





function pOut = preprocessRefFilters(object, p, buffer)
%
pOut = p;
Filters = filterObjs(object, 'Reference');
try
   [pOut.RefFilters, Params] = preprocessFilters(Filters, buffer, p.RefDataBuffer, p.RefDataBuffer); % not sure about 2nd buffer margin param
catch
   ErrorInfo = lasterror;
   ErrorInfo.message = ['error preprocessing reference filter: ' ErrorInfo.message];
   rethrow(ErrorInfo);
end
if ~isempty(pOut.RefFilters)
   pOut.RefFilterParameters = Params;
end





function pOut = preprocessTargetFilters(object, p, buffer)
%
pOut = p;
Filters = filterObjs(object, 'Target');
try
   [pOut.TargetFilters, Params] = preprocessFilters(Filters, buffer, p.TargetDataBuffer, p.RefDataBuffer);
catch
   ErrorInfo = lasterror;
   ErrorInfo.message = ['error preprocessing target filter: ' ErrorInfo.message];
   rethrow(ErrorInfo);
end
if ~isempty(pOut.TargetFilters)
   pOut.TargetFilterParameters = Params;
end




function pOut = preprocessRefSignalOps(object, p)
%
pOut = p;
SignalOps = signalOpObjs(object, 'Reference');
try
   [pOut.RefSignalOps, Params] = preprocessSignalOps(SignalOps, p.RefDataBuffer, p.RefDataBuffer); % not sure about 2nd buffer param
catch
   ErrorInfo = lasterror;
   ErrorInfo.message = ['error preprocessing reference signal operation: ' ErrorInfo.message];
   rethrow(ErrorInfo);
end
if ~isempty(pOut.RefSignalOps)
   pOut.RefSignalOpParameters = Params;
end





function pOut = preprocessTargetSignalOps(object, p)
%
pOut = p;
SignalOps = signalOpObjs(object, 'Target');
try
   [pOut.TargetSignalOps, Params] = preprocessSignalOps(SignalOps, p.TargetDataBuffer, p.RefDataBuffer);
catch
   ErrorInfo = lasterror;
   ErrorInfo.message = ['error preprocessing target signal operation: ' ErrorInfo.message];
   rethrow(ErrorInfo);
end
if ~isempty(pOut.TargetSignalOps)
   pOut.TargetSignalOpParameters = Params;
end




function pOut = preprocessTimeWindow(p, props)
%
pOut = p;
TConversionFactor = units('conversionfactor', 'time', props.TimeUnits, 'seconds');
pOut.WindowStart = props.WindowStart * TConversionFactor;
pOut.WindowStop = props.WindowStop * TConversionFactor;
if pOut.WindowStop <= pOut.WindowStart
   if strcmp(pOut.SubClass, 'interval average')
     pOut.WindowStart = 0;
     pOut.WindowStop = 1;
   else
     error('MDA:analysesInvalidWindow', ['invalid time window  (' ...
        num2str(pOut.WindowStart) ' to ' num2str(pOut.WindowStop) ')']);
   end
end
pOut.WindowLeftMargin = pOut.WindowStart;
pOut.WindowRightMargin = pOut.WindowStop;





function pOut = preprocessBaselineTimeWindow(p, props)
%
pOut = p;
pOut.BaselineWindowStart = props.BaselineWindowStart * TConversionFactor;
pOut.BaselineWindowStop = props.BaselineWindowStop * TConversionFactor;
if pOut.BaselineWindowStop < pOut.BaselineWindowStart
   error('MDA:analysesInvalidWindow', ['invalid baseline time window  (' ...
      num2str(pOut.BaselineWindowStart) ' to ' num2str(pOut.BaselineWindowStop) ')']);
end
pOut.WindowLeftMargin = min(p.WindowLeftMargin, pOut.BaselineWindowStart);
pOut.WindowRightMargin = max(p.WindowRightMargin, pOut.BaselineWindowStop);





function preprocess(objects, varargin)
%

global OBJ_WAITBAR

Buffer = varargin{1};

ObjectCount = length(objects);
for i = 1:ObjectCount
   Object = objects(i);
   try
      set(Object,'TrialStorageCap',20000);      % added by TT 070808
      Props = get(Object);
      if ~isempty(OBJ_WAITBAR)
         Name = get(Object, 'Name');
         waitbar(OBJ_WAITBAR, 'update', (i-1)/ObjectCount, ['preparing analyses: ' Name]);
      end

      ClearOnLoad = get(Props.Parent, 'ClearOnLoad');
      if ClearOnLoad
         clear(Object);
      end

      p = struct('SubClass', subclass(Object));
      p.HasReference = 1;
      p.HasTarget = 0;

      switch p.SubClass
         case {'perievent histogram', 'window count'}
            p = preprocessTimeWindow(p, Props);

            p = preprocessRef(p, Props, Buffer);
            p = preprocessTarget(p, Props, Buffer);

            if strcmp(p.SubClass, 'window count') && Props.UseBaseline
               p = preprocessBaselineTimeWindow(p, Props);
            end
            databuffer(p.RefDataBuffer, 'addmarginparameter', p.TargetDataBuffer, ...
               [max(0, -p.WindowLeftMargin) max(0, p.WindowRightMargin)]);

            p = preprocessRefFilters(Object, p, Buffer);
            p = preprocessTargetFilters(Object, p, Buffer);

            p.TrialLimit = Props.TrialLimit;
            p.StoreTrials = Props.StoreTrials;
            p.StorageCap = Props.TrialStorageCap;

            switch p.SubClass
               case 'perievent histogram'
                  TConversionFactor = units('conversionfactor', 'time', Props.TimeUnits, 'seconds');
                  p.Bins = get(Object, 'BinEdges') * TConversionFactor;
                  p.YDataProp = 'YData';

               case 'window count'
                  p.YDataProp = 'TotalCount';
                  p.YDataType = Props.YDataType;
                  p.Bins = [p.WindowStart p.WindowStop];
                  p.WindowWidth = p.Bins(2) - p.Bins(1);

                  p.UseBaseline = Props.UseBaseline;
                  if p.UseBaseline
                     p.BaselineBins = [p.BaselineWindowStart p.BaselineWindowStop];
                     p.BaselineWindowWidth = p.BaselineBins(2) - p.BaselineBins(1);
                  else
                     Index = findfirst({'total count', 'counts/trial', 'frequency'}, p.YDataType);
                     if ~Index
                        set(Object, 'YData', NaN, 'BaselineYData', NaN);
                        error('MDA:analysesInvalidDataType', ['Must use baseline for data type ' p.YDataType]);
                     end
                  end
            end

            p.StoreStDev = Props.StoreStDev;

         case {'interval count'}
            p = preprocessRef(p, Props, Buffer);
            p = preprocessTarget(p, Props, Buffer);

            databuffer(p.RefDataBuffer, 'addmarginparameter', p.TargetDataBuffer, ...
               [max(0, -p.WindowLeftMargin) max(0, p.WindowRightMargin)]);

            p = preprocessTargetFilters(Object, p, Buffer);

            p.YDataType = Props.YDataType;

         case {'triggered average', 'triggered power spectrum', 'triggered spectrogram', 'interval average', 'window average'} %[fft][tsg][ita]
            p = preprocessTimeWindow(p, Props);
            p = preprocessRef(p, Props, Buffer);
            p = preprocessTarget(p, Props, Buffer);

            if strcmp(p.SubClass, 'window average') && Props.UseBaseline
               p = preprocessBaselineTimeWindow(p, Props);
            end

            databuffer(p.RefDataBuffer, 'addmarginparameter', p.TargetDataBuffer, ...
               [max(0, -p.WindowLeftMargin) max(0, p.WindowRightMargin)]);

            TargetChannel = get(p.TargetDataBuffer, 'LinkedChannel');
            if ismember(p.SubClass, {'triggered average', 'interval average', 'window average'})
               if ~isempty(TargetChannel)
                  Experiment = parent(TargetChannel);
                  set(Object, 'CustomConversionFactor', get(TargetChannel, 'CustomConversionFactor'), ...
                     'CustomDataUnits', get(TargetChannel, 'CustomDataUnits'), ...
                     'ConverterVoltageRange', get(Experiment, 'ConverterVoltageRange'), ...
                     'ConverterBitPrecision', get(Experiment, 'ConverterBitPrecision'));
               end
            end

            p = preprocessRefFilters(Object, p, Buffer);
            p = preprocessTargetSignalOps(Object, p);

            p.TrialLimit = Props.TrialLimit;
            p.StoreTrials = Props.StoreTrials;
            p.StorageCap = Props.TrialStorageCap;
            p.Rectify = Props.Rectify;

            MemoryLimit = 5000000;
            TargetFileDataType = get(TargetChannel, 'FileDataType');
            ByteSize = get(p.TargetDataBuffer, 'ByteSize');
            switch TargetFileDataType
               case {'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64'}
                  p.OperationType = 'integer';
               otherwise
                  p.OperationType = 'double';
            end
            switch subclass(Object)
               case 'triggered average'
                  p.ConversionFactor = units('conversionfactor', 'signal units', 'digitizing units', Props.YUnits, Experiment, TargetChannel);

                  Offset = round(p.TargetSampleRate * p.WindowStart);
                  p.SweepBaseRange = (1 + Offset):(round((p.WindowStop-p.WindowStart)*p.TargetSampleRate) + Offset);
                  p.SweepLength = length(p.SweepBaseRange);

                  p.BatchLength = max(1, floor((MemoryLimit/ByteSize)/p.SweepLength));

                  if p.TargetSampleRate ~= Props.SampleRate
                     setwoq(Object, 'SampleRate', p.TargetSampleRate);
                     xdata(Object);
                     Props.XData = get(Object, 'XData');
                  end
                  if length(Props.XData) ~= p.SweepLength
                     error('MDA:analysesInvalidXData', 'error in number of x and y data points');
                  end

               case 'window average'
                  p.ConversionFactor = units('conversionfactor', 'signal units', 'digitizing units', Props.YUnits, Experiment, TargetChannel);

                  Offset = round(p.TargetSampleRate * p.WindowStart);
                  p.SweepBaseRange = (1 + Offset):(round((p.WindowStop-p.WindowStart)*p.TargetSampleRate) + Offset);
                  p.SweepLength = length(p.SweepBaseRange);

                  p.BatchLength = max(1, floor((MemoryLimit/ByteSize)/p.SweepLength));

                  if p.TargetSampleRate ~= Props.SampleRate
                     setwoq(Object, 'SampleRate', p.TargetSampleRate);
                  end

                  p.YDataType = Props.YDataType;
                  p.UseBaseline = Props.UseBaseline;
                  if p.UseBaseline
                     Offset = round(p.TargetSampleRate * p.WindowStart);
                     p.BaselineSweepBaseRange = (1 + Offset):(round((p.BaselineWindowStop-p.BaselineWindowStart)*p.TargetSampleRate) + Offset);
                     p.BaselineSweepLength = length(p.BaselineSweepBaseRange);
                  else
                     Index = findfirst({'average'}, p.YDataType);
                     if ~Index
                        set(Object, 'YData', NaN, 'BaselineYData', NaN);
                        error('MDA:analysesInvalidDataType', ['Must use baseline for data type ' p.YDataType]);
                     end
                  end

               case 'triggered power spectrum'
                  p.Detrend = Props.Detrend;
                  p.UseHanningWindow = Props.UseHanningWindow;
                  
                  Offset = round(p.TargetSampleRate * p.WindowStart);
                  p.SweepBaseRange = (1 + Offset):(round((p.WindowStop-p.WindowStart)*p.TargetSampleRate) + Offset);
                  p.WindowWidth = length(p.SweepBaseRange);
                  
                  p.BatchLength = max(1, floor((MemoryLimit/ByteSize)/p.WindowWidth));
                  
                  % Calculate Hanning window if desired.  This will reduce spectral leakage
                  % from adjacent bins, but emphasizes the central data.
                  if p.UseHanningWindow
                     p.Window = hanning(p.WindowWidth);
                  else
                     p.Window = ones(p.WindowWidth, 1);
                  end
                  p.NormFactor = 2 / norm(p.Window)^2; % Factor of 2/L except when using a Hanning window.
                  p.PValue = Props.PValue;
                  
                  % Store the X axis (in Hertz)
                  set(Object, 'XData', (0:(p.WindowWidth-1)) * (p.TargetSampleRate / p.WindowWidth));
                  
               case 'triggered spectrogram'
                  p.Detrend = Props.Detrend;
                  p.UseHanningWindow = Props.UseHanningWindow;
                  p.FFTSize = Props.FFTSize;
                  
                  Offset = round(p.TargetSampleRate * p.WindowStart);
                  p.SweepBaseRange = (1 + Offset):(round((p.WindowStop-p.WindowStart)*p.TargetSampleRate) + Offset);
                  p.WindowWidth = length(p.SweepBaseRange);
                  
                  p.BatchLength = max(1, floor((MemoryLimit/ByteSize)/p.WindowWidth));
                  
                  % Calculate an index for extracting overlapping data sections from
                  % each sweep of data.  XData marks the middle of each data section.
                  FFTSpacing = Props.FFTSize - Props.Overlap;
                  p.PreTriggerBins = floor(-p.WindowStart * p.TargetSampleRate);
                  if (p.WindowStart <= 0) && (p.WindowStop > 0)
                     % Align fft sections starting at time 0.
                     ZeroBasedStartBin = mod(p.PreTriggerBins, FFTSpacing);
%                     p.Index = (ZeroBasedStartBin:FFTSpacing:p.WindowWidth) - (Props.FFTSize - 1);
                     p.Index = ZeroBasedStartBin:FFTSpacing:p.WindowWidth-Props.FFTSize;
                     NumSections = length(p.Index);
                     p.Index = repmat(p.Index,Props.FFTSize,1) + repmat((1:Props.FFTSize)',1,NumSections);
                  else
                     % Start fft sections at first data point.
                     NumSections = floor((p.WindowWidth - Props.Overlap) / FFTSpacing);
                     p.Index = repmat((0:NumSections-1) .* FFTSpacing, Props.FFTSize,1) + repmat((1:Props.FFTSize)',1,NumSections);
                  end
                  
                  % Calculate Hanning window if desired.  This will reduce spectral leakage
                  % from adjacent bins, but emphasizes the central data.
                  if p.UseHanningWindow
                     p.Window = hanning(Props.FFTSize);
                  else
                     p.Window = ones(Props.FFTSize, 1);
                  end
                  p.NormFactor = 2 / norm(p.Window)^2; % Factor of 2/L except when using a Hanning window.
                  p.Window = repmat(p.Window, 1, NumSections); % One window for each FFT section.
                  
                  % Determine the correct number of points to return (note that input data is always real).
                  if rem(Props.FFTSize,2)   
                     p.NonRedundantIndexes = 1:(Props.FFTSize+1)/2; % FFTSize odd
                  else		
                     p.NonRedundantIndexes = 1:Props.FFTSize/2+1; % FFTSize even
                  end
                  
                  % Store the Y axis (in Hertz)
 				  set(Object, 'YData', (0:(size(p.NonRedundantIndexes)-1)) * (p.TargetSampleRate / p.FFTSize));
                                
                  % Store the X axis (in Seconds)
                  set(Object, 'XData', (p.Index(1,:) - p.PreTriggerBins - 1) ./ p.TargetSampleRate);

               case 'interval average'
                  p.ConversionFactor = units('conversionfactor', 'signal units', 'digitizing units', Props.YUnits, Experiment, TargetChannel);

            end

         case 'sweep average'
            p = preprocessRef(p, Props, Buffer);
            %%% not done

         case 'count'
            p = preprocessRef(p, Props, Buffer);
            p = preprocessRefFilters(Object, p, Buffer);

      end
      setuser(Object, 'PreprocessedParameters', p);

   catch
      ErrorInfo = lasterror;
      if isempty(strfind(ErrorInfo, 'MDA'))
         ErrorInfo.identifier = 'MDA:analysesPreprocessingError';
      end
      if ~isempty(strfind(ErrorInfo, ':analyses'))
         ErrorInfo.message = ['error preprocessing analyses: ' ErrorInfo.message];
      end
      set(Object, 'Error', 1, 'ErrorMessage', ErrorInfo.ErrorMessage);
   end

   if ~isempty(OBJ_WAITBAR)
      waitbar(OBJ_WAITBAR, 'update', i/ObjectCount, ['preparing analyses: ' Name]);
   end
end





function [activefilters, params] = preprocessFilters(filters, buffer, refbuffer, marginbuffer)
%

activefilters = [];
params = [];
if ~isempty(filters)
   Active = cell2dbl(get(filters, 'Active'));
   activefilters = filters(find(Active));
end
if ~isempty(activefilters)
   FilterReferenceObjs = cell(1, length(activefilters));
   for i = 1:length(activefilters)
      ReferenceNames = timefilter(activefilters(i), 'references');
      if ~isempty(ReferenceNames)
         FilterReferenceObjs{i} = bufferset(buffer, 'activate', ReferenceNames);
         Errors = cell2dbl(get(FilterReferenceObjs{i}, 'Error'));
         if any(Errors)
            Index = find(Errors);
            error('MDA:analysesErrorInReference', ['a filter reference channel (' ReferenceNames{Index} ') has an error']);
         end
      end
   end
   params = timefilter(activefilters, 'preprocess', refbuffer, FilterReferenceObjs);

   FilterMarginParameters = timefilter(activefilters, 'getmarginparameters', FilterReferenceObjs);
   for i = 1:size(FilterMarginParameters, 1)
      databuffer(marginbuffer, 'addmarginparameter', ...
         FilterMarginParameters{i, 1}, FilterMarginParameters{i, 2});
   end
end





function [activesigops, params] = preprocessSignalOps(sigops, refbuffer, marginbuffer)
%

activesigops = [];
params = [];
if ~isempty(sigops)
   Active = cell2dbl(get(sigops, 'Active'));
   activesigops = sigops(find(Active));
end
if ~isempty(activesigops)
   params = signaloperation(activesigops, 'preprocess', refbuffer);
   try
      SignalOpMarginParameters = signaloperation(activesigops, 'getmarginparameters', refbuffer);
      for i = 1:size(SignalOpMarginParameters, 1)
         databuffer(marginbuffer, 'addmarginparameter', ...
            SignalOpMarginParameters{i, 1}, SignalOpMarginParameters{i, 2});
      end
   catch
      ErrorInfo = lasterror;
      ErrorInfo.message = ['error getting signal operation margins: ' ErrorInfo.message];
      rethrow(ErrorInfo);
   end
end







function postprocess(objects)
%

for i = 1:length(objects)
   Object = objects(i);

   rmuser(Object, 'PreprocessedParameters');
   %switch subclass(Object)
   %case 'perievent histogram'
   %case {'triggered average', 'interval average', 'sweep average', 'triggered power spectrum', 'triggered spectrogram'} %[fft][tsg][ita]
   %end
end






function xdata(objects)
%

for i = 1:length(objects)
   Object = objects(i);
   switch subclass(Object)
      case 'perievent histogram'
         WindowStart = get(Object, 'WindowStart');
         WindowStop = get(Object, 'WindowStop');
         BinWidth = get(Object, 'BinWidth');
         BinCenterOffset = BinWidth/2;
         BinEdges = WindowStart:BinWidth:WindowStop;
         XData = (WindowStart+BinCenterOffset):BinWidth:BinEdges(end);
         set(Object, 'BinEdges', BinEdges, ...
            'XData', XData);
      case 'triggered average'
         WindowStart = get(Object, 'WindowStart');
         WindowStop = get(Object, 'WindowStop');
         SampleRate = get(Object, 'SampleRate');
         TimeUnits = get(Object, 'TimeUnits');
         ConversionFactor = units('conversionfactor', 'time', 'seconds', TimeUnits);
         Step = ConversionFactor/SampleRate;
         XData = WindowStart:Step:(WindowStop-Step);
         set(Object, 'XData', XData);
         %[fft]
      case 'triggered power spectrum'
         WindowStart = get(Object, 'WindowStart');
         WindowStop = get(Object, 'WindowStop');
         SampleRate = get(Object, 'SampleRate');
         TimeUnits = get(Object, 'TimeUnits');
         ConversionFactor = units('conversionfactor', 'time', 'seconds', TimeUnits);
         Step = ConversionFactor/SampleRate;
         SegSize = length(WindowStart:Step:(WindowStop-Step));
         if rem(SegSize, 2)
            N = (SegSize + 1) / 2; % N for odd FFT segment size.
         else
            N = SegSize / 2 + 1; % N for even FFT segment size.
         end
         XData = 0:(N-1) * (SampleRate / SegSize); % X axis is in Hz.
         set(Object, 'XData', XData);
         %[tsg]
      case 'triggered spectrogram'
         WindowStart = get(Object, 'WindowStart');
         WindowStop = get(Object, 'WindowStop');
         SampleRate = get(Object, 'SampleRate');
         FFTSize = get(Object, 'FFTSize');
         Overlap = get(Object, 'Overlap');
         TimeUnits = get(Object, 'TimeUnits');
         ConversionFactor = units('conversionfactor', 'time', 'seconds', TimeUnits);
         Step = ConversionFactor/SampleRate;
         SamplesPerSweep = length(WindowStart:Step:(WindowStop-Step));
         FFTSpacing = FFTSize - Overlap;
         NumSections = floor((SamplesPerSweep - Overlap) / FFTSpacing);
         XData = ((0:(NumSections-1)) .* FFTSpacing + FFTSize/2) ./ (SampleRate/ConversionFactor) + WindowStart;
         set(Object, 'XData', XData);
         %[ita]
      case 'interval average'
         %Interval triggered averages use trial index as the XAxis.
         YData = get(Object, 'YData');
         TrialCount = length(YData);
         set(Object, 'XData', 1:TrialCount);
         setwoq(Object, 'WindowStart', 1);
         setwoq(Object, 'WindowStop', TrialCount);
         setwoq(Object, 'TrialCount', TrialCount);
      case 'sweep average'
         WindowStart = get(Object, 'WindowStart');
         WindowStop = get(Object, 'WindowStop');
         SampleRate = get(Object, 'SweepSampleRate');
         Step = 1/SampleRate;
         XData = WindowStart:Step:(WindowStop-Step);
         set(Object, 'XData', XData);
   end
end




function refsChanged(objects)
%

for i = 1:length(objects)
   Object = objects(i);
   switch subclass(Object)
      case {'perievent histogram', 'window count', 'interval count', 'window average', 'count'}
         %[fft][tsg][ita]
      case {'triggered average', 'triggered power spectrum', 'triggered spectrogram', 'interval average'}
         Experiments = get(Object, 'ObjectsToAnalyze');
         UseSets = get(parent(Object), 'LinkUsingSets');
         if UseSets && ~isempty(Experiments)
            Experiments = expset(Experiments, 'experimentobjs');
         end

         if ~isempty(Experiments)
            Target = get(Object, 'Target');
            Channel = findmdaobj(Experiments(1), 'children', ...
               'Name', Target);
            if ~isempty(Channel)
               SampleRate = get(Channel, 'SampleRate');
               CurrentSampleRate = get(Object, 'SampleRate');
               if SampleRate ~= CurrentSampleRate
                  set(Object, 'SampleRate', SampleRate);
               end
            else
               %% Don't do this as currently setting by 'default' is not
               %% implemented
               %%%set(Object, 'SampleRate', 'default'); %%% do this?  it clears the data (in onpropchange)
            end
         end
      case 'sweep average'
   end
end




function recalculate(objects)
%

for i = 1:length(objects)
   switch subclass(objects(i))
      case 'perievent histogram'
         StoreTrials = get(objects(i), 'StoreTrials');
         if ~StoreTrials
            return
         end
         TrialsToUse = get(objects(i), 'TrialsToUse');
         TrialData = get(objects(i), 'TrialData');
         StoredTrialCount = length(TrialData);
         if isempty(TrialsToUse)
            TrialsToUse = 1:StoredTrialCount;
         elseif max(TrialsToUse) > StoredTrialCount
            TrialsToUse(TrialsToUse > StoredTrialCount) = [];
         end

         TrialData = TrialData(TrialsToUse);
         Times = [];
         for j = 1:length(TrialData)
            Times = [Times TrialData{j}];
         end
         Times = sort(Times);
         TimeUnits = get(objects(i), 'TimeUnits');
         ConversionFactor = units('conversionfactor', 'time', TimeUnits, 'seconds');
         BinEdges = get(objects(i), 'BinEdges') * ConversionFactor;
         if ~isempty(Times)
            YData = histc(Times, BinEdges);
         else
            YData = zeros(1, length(BinEdges));
         end
         set(objects(i), 'YData', YData(1:end-1), ...
            'TrialCount', length(TrialsToUse));

      case 'window count'
         YDataType = get(objects(i), 'YDataType');
         StoreTrials = get(objects(i), 'StoreTrials');
         TrialsToUse = get(objects(i), 'TrialsToUse');
         TrialCount = get(objects(i), 'TrialCount');
         NeedTrials = ~isempty(strfind(YDataType, 'by trial'));

         if ~StoreTrials && NeedTrials && TrialCount > 0
            set(Object, 'Error', 1, 'ErrorMessage', ['Must store trials to calculate data type ''' YDataType ''''], ...
               'YData', NaN, 'BaselineYData', NaN);
            continue
         end

         if ~StoreTrials || isempty(TrialsToUse)
            if NeedTrials
               TrialData = get(objects(i), 'TrialData');
            else
               TotalCount = get(objects(i), 'TotalCount');
            end
         else
            TrialData = get(objects(i), 'TrialData');
            StoredTrialCount = length(TrialData);
            if ~isempty(TrialsToUse)
               if max(TrialsToUse) > StoredTrialCount
                  TrialsToUse = TrialsToUse(TrialsToUse <= StoredTrialCount);
               end
               TrialData = TrialData(TrialsToUse);
            end
            TrialCount = length(TrialData);
            TotalCount = 0;
            if ~NeedTrials
               for j = 1:TrialCount
                  TotalCount = TotalCount + length(TrialData{j});
               end
            end
         end

         if TrialCount == 0
            YData = NaN;
            BaselineYData = NaN;
         else
            UseBaseline = get(objects(i), 'UseBaseline');
            if UseBaseline
               if ~StoreTrials || isempty(TrialsToUse)
                  BaselineTotalCount = get(objects(i), 'BaselineTotalCount');
                  if NeedTrials
                     BaselineTrialData = get(objects(i), 'BaselineTrialData');
                  end
               else
                  BaselineTrialData = get(objects(i), 'BaselineTrialData');
                  BaselineTrialData = BaselineTrialData(TrialsToUse);
                  BaselineTotalCount = 0;
                  if ~NeedTrials
                     for j = 1:TrialCount
                        BaselineTotalCount = BaselineTotalCount + length(BaselineTrialData{j});
                     end
                  end
               end
               if findfirst({'baseline frequency', 'rate difference', 'rate difference (by trial)'}, YDataType)
                  WindowStart = get(objects(i), 'BaselineWindowStart');
                  WindowStop = get(objects(i), 'BaselineWindowStop');
                  TimeUnits = get(objects(i), 'TimeUnits');
                  TConversionFactor = units('conversionfactor', 'time', TimeUnits, 'seconds');
                  BaselineWindowWidth = (WindowStop - WindowStart)*TConversionFactor;
               end
               BaselineYData = BaselineTotalCount;

            else
               if ~findfirst({'total count', 'counts/trial', 'frequency'}, YDataType)
                  set(objects(i), 'Error', 1, ...%'ErrorMessage', ['Must use baseline for data type ''' YDataType ''''], ...
                     'YData', NaN, 'BaselineYData', NaN);
                  continue
               end
               BaselineYData = NaN;
            end

            if findfirst({'frequency', 'rate difference', 'rate difference (by trial)'}, YDataType)
               WindowStart = get(objects(i), 'WindowStart');
               WindowStop = get(objects(i), 'WindowStop');
               TimeUnits = get(objects(i), 'TimeUnits');
               TConversionFactor = units('conversionfactor', 'time', TimeUnits, 'seconds');
               WindowWidth = (WindowStop - WindowStart)*TConversionFactor;
            end

            switch YDataType
               case 'total count'
                  YData = TotalCount;
               case 'counts/trial'
                  YData = TotalCount/TrialCount;
                  if UseBaseline
                     BaselineYData = BaselineTotalCount/TrialCount;
                  end
               case 'frequency'
                  YData = TotalCount/TrialCount/WindowWidth;
                  if UseBaseline
                     BaselineYData = BaselineTotalCount/TrialCount/WindowWidth;
                  end
               case 'baseline total count'
                  YData = BaselineYData;
               case 'baseline counts/trial'
                  BaselineYData = BaselineTotalCount/TrialCount;
                  YData = BaselineYData;
               case 'baseline frequency'
                  BaselineYData = BaselineTotalCount/TrialCount/BaselineWindowWidth;
                  YData = BaselineYData;
               case 'ratio'
                  if BaselineTotalCount
                     YData = TotalCount/BaselineTotalCount;
                  else
                     YData = NaN;
                  end
               case 'ratio'
                  if BaselineTotalCount
                     YData = TotalCount/BaselineTotalCount;
                  else
                     YData = NaN;
                  end
               case 'ratio (by trial)'
                  YData = NaN;
                  for j = 1:TrialCount
                     Baseline = length(BaselineTrialData{j});
                     if Baseline
                        YData(j) = length(TrialData{j})/Baseline;
                     else
                        YData = NaN;
                        break;
                     end
                  end
                  YData = mean(YData);
               case 'difference'
                  YData = (TotalCount - BaselineTotalCount)/TrialCount;
               case 'rate difference'
                  YData = TotalCount/TrialCount/WindowWidth - BaselineTotalCount/TrialCount/BaselineWindowWidth;
               case 'mean percent change'
                  if BaselineTotalCount
                     YData = (TotalCount-BaselineTotalCount)/BaselineTotalCount * 100;
                  else
                     YData = NaN;
                  end
               case 'mean percent change (by trial)'
                  YData = NaN;
                  for j = 1:TrialCount
                     Baseline = length(BaselineTrialData{j});
                     if Baseline
                        YData(j) = (length(TrialData{j})-BaselineTotalCount)/BaselineTotalCount * 100;
                     else
                        YData = NaN;
                        break;
                     end
                  end
                  YData = mean(YData);
            end
         end

         switch YDataType
            case {'total count', 'baseline total count'}
               YUnitClass = 'count';
               YUnits = 'count';
            case {'counts/trial', 'baseline counts/trial'}
               YUnitClass = 'count';
               YUnits = 'count';
            case {'frequency', 'baseline frequency'}
               YUnitClass = 'frequency';
               YUnits = 'Hertz';
            case 'ratio'
               YUnitClass = 'undefined';
               YUnits = 'undefined';
            case 'ratio (by trial)'
               YUnitClass = 'undefined';
               YUnits = 'undefined';
            case 'difference'
               YUnitClass = 'count';
               YUnits = 'count';
            case 'difference (by trial)'
               YUnitClass = 'count';
               YUnits = 'count';
            case 'rate difference'
               YUnitClass = 'frequency';
               YUnits = 'Hertz';
            case 'rate difference (by trial)'
               YUnitClass = 'frequency';
               YUnits = 'Hertz';
            case 'mean percent change'
               YUnitClass = 'percent';
               YUnits = 'percent';
            case 'mean percent change (by trial)'
               YUnitClass = 'percent';
               YUnits = 'percent';
         end
         set(objects(i), 'YData', YData, 'BaselineYData', BaselineYData, ...
            'TrialCount', TrialCount, 'YUnitClass', YUnitClass, 'YUnits', YUnits);

      case {'triggered average', 'sweep average'}
         StoreTrials = get(objects(i), 'StoreTrials');
         if ~StoreTrials
            return
         end
         TrialsToUse = get(objects(i), 'TrialsToUse');
         TrialData = get(objects(i), 'TrialData');
         Rectify = get(objects(i), 'Rectify');
         StoredTrialCount = size(TrialData, 1);
         if isempty(TrialsToUse)
            TrialsToUse = 1:StoredTrialCount;
         elseif max(TrialsToUse) > StoredTrialCount
            TrialsToUse(TrialsToUse > StoredTrialCount) = [];
         end

         if Rectify
            YData = mean(abs(TrialData(TrialsToUse,:)), 1);
         else
            YData = mean(TrialData(TrialsToUse,:), 1);
         end
         set(objects(i), 'YData', YData, ...
            'TrialCount', length(TrialsToUse));

         %[fft]
      case {'triggered power spectrum'}
         StoreTrials = get(objects(i), 'StoreTrials');
         if ~StoreTrials
            return
         end
         TrialsToUse = get(objects(i), 'TrialsToUse');
         TrialData = get(objects(i), 'TrialData');
         StoredTrialCount = size(TrialData, 1);
         if isempty(TrialsToUse)
            TrialsToUse = 1:StoredTrialCount;
         elseif max(TrialsToUse) > StoredTrialCount
            TrialsToUse(TrialsToUse > StoredTrialCount) = [];
         end
         nfft = size(TrialData,2);
         YData = psd(reshape(TrialData(TrialsToUse,:), length(TrialsToUse) * nfft)',nfft, get(objects(i), 'SampleRate'), ones(nfft,1), 'linear');
         set(objects(i), 'YData', YData, 'TrialCount', length(TrialsToUse));

         %[tsg]
      case {'triggered spectrogram'}
         StoreTrials = get(objects(i), 'StoreTrials');
         if ~StoreTrials
            return
         end

         TrialsToUse = get(objects(i), 'TrialsToUse');
         TrialData = get(objects(i), 'TrialData');
         StoredTrialCount = size(TrialData, 1);
         if isempty(TrialsToUse)
            TrialsToUse = 1:StoredTrialCount;
         elseif max(TrialsToUse) > StoredTrialCount
            TrialsToUse(TrialsToUse > StoredTrialCount) = [];
         end


         return %%% Need to copy most of the [tsg] part from analyze.m

         %nfft = size(TrialData,2);
         %ZData = psd(reshape(TrialData(TrialsToUse,:), length(TrialsToUse) * nfft)',nfft, get(objects(i), 'SampleRate'), ones(nfft,1), 'linear');
         %set(objects(i), 'ZData', ZData, 'TrialCount', length(TrialsToUse));

         %[ita]
      case 'interval average'

         % Recalculate the weighted average using only the trials specified in
         % the TrialsToUse property.

         YData = get(objects(i), 'YData');  % Mean value for each interval.
         TrialCount = length(YData);    % Number of intervals.
         TrialLimit = get(objects(i), 'TrialLimit');
         TrialTimes = get(objects(i), 'TrialTriggerTime');  % Starting time of each interval.
         TrialEndTimes = get(objects(i), 'TrialEndTime'); % Ending time of each interval.
         StoreTrials = get(objects(i), 'StoreTrials');
         if StoreTrials
            StoredTrials = get(objects(i), 'TrialData');
            if ~isempty(StoredTrials)
               Rectify = get(objects(i), 'Rectify');
               TrialCount = min([TrialLimit, length(StoredTrials)]);
               YData = zeros(1, TrialCount);
               for j = 1:TrialCount
                  if Rectify
                     YData(j) = mean(abs(StoredTrials{j}));
                  else
                     YData(j) = mean(StoredTrials{j});
                  end
               end
               setwoq(objects(i), 'YData', YData, ...
                  'XData', 1:TrialCount, ...
                  'TrialCount', TrialCount, ...
                  'WindowStart', 1, ...
                  'WindowStop', TrialCount);
            end
         end

         TrialsToUse = get(objects(i), 'TrialsToUse');  % List of intervals to use in the weighted average.
         if isempty(TrialsToUse)
            TrialsToUse = 1:TrialCount;  % Use all trials if the TrialsToUse list is empty.
         else
            % Limit TrialsToUse to valid values between 1 and TrialCount.
            TrialsToUse = TrialsToUse((TrialsToUse >= 1) & (TrialsToUse <= TrialCount));
         end
         if length(TrialsToUse) > TrialLimit
            TrialsToUse = TrialsToUse(1:TrialLimit);
         end

         if isempty(TrialsToUse)
            % No intervals to use
            WeightedAverage = 0;
            WeightedAverageN = 0;
            WeightedSD = 0;
            ConfInterval = [0;0;0];
         else
            % Calculated weighted average of specified intervals.
            IntervalWidths = TrialEndTimes(TrialsToUse) - TrialTimes(TrialsToUse);
            Weights = IntervalWidths ./ sum(IntervalWidths);
            WeightedAverage = sum(YData(TrialsToUse)' .* Weights);
            WeightedAverageN = length(TrialsToUse); % Number of samples used to create weighted average.
            WeightedSD = sqrt(sum( (YData(TrialsToUse)' - mean(YData(TrialsToUse))).^2 .* Weights ));
            ConfInterval = [WeightedAverage - 2 * WeightedSD; WeightedAverage + 2 * WeightedSD; WeightedAverage] * ones(1, TrialCount);
         end

         set(objects(i), 'WeightedAverage', WeightedAverage, ...
            'WeightedAverageN', WeightedAverageN, ...
            'WeightedSD', WeightedSD, ...
            'ConfidenceInterval', ConfInterval);
      case 'count'
         % Cannot recalculate

   end
end




function [ok, message] = verify(objects, findfirstflag)
%

if nargin >=2 && findfirstflag
   FindFirst = 1;
else
   FindFirst = 0;
end

ok = zeros(1, length(objects));
message = cell(1, length(objects));
[message{:}] = deal('');
Analyses = [];

for i = 1:length(objects)
   Object = objects(i);
   ObjectStruct = get(Object);
   Message = '';

   if isvalid(Object)

      if ~isequal(Analyses, ObjectStruct.Parent)
         Analyses = ObjectStruct.Parent;
         %AllChannels = experiment(Experiment, 'channelobjs');
         %ChannelNames = cellstr(get(AllChannels, 'Name'));
      end

      while 1		% Loop so that any error can break out

         switch ObjectStruct.SubClass
            case 'perievent histogram'
               %[ok, Message] = verifyReference(AllChannels, ChannelNames, ...
               %   ObjectStruct.Reference, 'timestamp channel');
               %if ~ok
               %   break;
               %end

            otherwise
               %Message = ['Invalid or unsupported subclass - ' ...
               %   ObjectStruct.SubClass];
               %break
         end

         %%% Test filters and signal ops
         %             if ObjectStruct.Filter
         %                Filters = filterObjs(Object);
         %                if ~isempty(Filters)
         %                   [OK, Messages] = timefilter(Filters, 'verify', FindFirst);
         %                   if ~all(OK)
         %                      NotOK = find(~OK);
         %                      Message = ['Filter: ' Messages{NotOK(1)}];
         %                      break;
         %                   end
         %                end
         %             end
         %
         %             AccessoryData = accessoryDataObjs(Object);
         %             if ~isempty(AccessoryData)
         %                [OK, Messages] = accessory(AccessoryData, 'verify', FindFirst);
         %                if ~all(OK)
         %                   NotOK = find(~OK);
         %                   Message = ['Accessory Data: ' Messages{NotOK(1)}];
         %                   break;
         %                end
         %             end

         break;
      end % error while loop
   end

   if isempty(Message)
      ok(i) = 1;
   else
      message{i} = Message;
      if FindFirst
         break;
      end
   end
end % loop through objects





function filterobjects = filterObjs(objects, type)
%

if nargin < 2
   Type = '';
else
   Type = type;
end

filterobjects = [];
for i = 1:length(objects)
   Children = children(objects(i));
   if ~isempty(Children)
      Classes = mdaclass(Children);
      Indexes = find(strcmp('timestamp filter', Classes));
      if ~isempty(Indexes)
         if ~isempty(Type)

            Names = get(Children(Indexes), 'Name');
            Indexes = Indexes(find(strcmp(Type, Names)));
         end
         if ~isempty(Indexes)
            if isempty(filterobjects)
               filterobjects = Children(Indexes);
            else
               filterobjects(end+1:end+length(Indexes)) = Children(Indexes);
            end
         end
      end
   end
end





function opobjects = signalOpObjs(objects, source)
%

if nargin < 2
   Source = '';
else
   Source = source;
end

opobjects = [];
for i = 1:length(objects)
   Children = children(objects(i));
   if ~isempty(Children)
      Classes = mdaclass(Children);
      Indexes = find(strcmp('signal operation', Classes));
      if ~isempty(Indexes)
         if ~isempty(Source)
            DataSources = get(Children(Indexes), 'DataSource');
            Indexes = Indexes(find(strcmp(Source, DataSources)));
         end
         if ~isempty(Indexes)
            if isempty(opobjects)
               opobjects = Children(Indexes);
            else
               opobjects(end+1:end+length(Indexes)) = Children(Indexes);
            end
         end
      end
   end
end