function [y,halfmaxV]  = pwhm(x,d,PeakInd,method)
% d: direction 1=peak 0= trough
% if nargin<3
%     PeakInd = [];
% end
if nargin<3
    PeakInd = 1:length(x);
    method  = 'tolerance';
elseif nargin<4
    method  = 'tolerance';
end

nData   = length(x);
xind    = 1:nData;

if(d==1)    % Peak width
    [maxV,maxI] = max(nanmask(x,PeakInd));
    halfmaxV    = maxV/2;
    
    firstInd    = find(PeakInd,1,'first');
    lastInd     = find(PeakInd,1,'last');
    
    switch lower(method(1))
        case 't'
    if(x(firstInd) <= halfmaxV)  % PWHMのfirstの端っこがPeakIndの範囲内にあるとき
        onset    = find(nanmask(x,PeakInd)>=halfmaxV,1,'first');
        onset1   = max(onset - 1,1);
        if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
            onset   = onset1;
        end
    else
        onset    = find(nanmask(nanmask(x,[1:length(x)]<maxI),~PeakInd)<=halfmaxV,1,'last');
        onset1   = min(onset + 1,nData);
        if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
            onset   = onset1;
        end
    end

    if(x(lastInd) <= halfmaxV)  % PWHMのlastの端っこがPeakIndの範囲内にあるとき
        offset    = find(nanmask(x,PeakInd)>=halfmaxV,1,'last');
        offset1   = min(offset + 1,nData);
        if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
            offset   = offset1;
        end
    else
        offset    = find(nanmask(nanmask(x,[1:length(x)]>maxI),~PeakInd)<=halfmaxV,1,'first');
        offset1   = max(offset - 1,1);
        if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
            offset   = offset1;
        end
    end
        case 'e'
            onset    = find(x < halfmaxV & xind < maxI,1,'last');
            onset1   = onset + 1;
            if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
                onset   = onset1;
            end

            offset   = find(x < halfmaxV & xind > maxI,1,'first') - 1;
            offset1  = offset+1;
            if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
                offset   = offset1;
            end
            
    end

    

else
    [maxV,maxI] = min(nanmask(x,PeakInd));
    halfmaxV    = maxV/2;
    
    switch lower(method(1))
        case 't'
    firstInd    = find(PeakInd,1,'first');
    lastInd     = find(PeakInd,1,'last');

    if(x(firstInd) >= halfmaxV)  % PWHMのfirstの端っこがPeakIndの範囲内にあるとき
        onset    = find(nanmask(x,PeakInd)<=halfmaxV,1,'first');
        onset1   = max(onset - 1,1);
        if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
            onset   = onset1;
        end
    else
        onset    = find(nanmask(nanmask(x,[1:length(x)]<maxI),~PeakInd)>=halfmaxV,1,'last');
        onset1   = min(onset + 1,nData);
        if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
            onset   = onset1;
        end
    end

    if(x(lastInd) <= halfmaxV)  % PWHMのlastの端っこがPeakIndの範囲内にあるとき
        offset    = find(nanmask(x,PeakInd)<=halfmaxV,1,'last');
        offset1   = min(offset + 1,nData);
        if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
            offset   = offset1;
        end
    else
        offset    = find(nanmask(nanmask(x,[1:length(x)]>maxI),~PeakInd)>=halfmaxV,1,'first');
        offset1   = max(offset - 1,1);
        if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
            offset   = offset1;
        end
    end
    
            case 'e'
            onset    = find(x > halfmaxV & xind < maxI,1,'last');
            onset1   = onset + 1;
            if(abs(x(onset)-halfmaxV)>=abs(x(onset1)-halfmaxV)) % 近いほうをとる
                onset   = onset1;
            end

            offset   = find(x > halfmaxV & xind > maxI,1,'first') - 1;
            offset1  = offset+1;
            if(abs(x(offset)-halfmaxV)>=abs(x(offset1)-halfmaxV)) % 近いほうをとる
                offset   = offset1;
            end
            
    end



end
if(isempty(onset));
    onset   = 1;
end
if(isempty(offset));
    offset   = length(x);
end

    y           = [onset,offset];
%     n           = offset-onset;
