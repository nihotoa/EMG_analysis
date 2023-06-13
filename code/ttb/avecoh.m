function S  = avecoh(fullfilenames,Name)

warning('off')

nfile   = length(fullfilenames);
fullfilename    = fullfilenames{1};
s   = load(fullfilename);
AnalysisType    = s.AnalysisType;

% COH_peak_th     = 0.08;
COH_peak_th     = 0.01;

switch AnalysisType
%% DCOH    
    case 'DCOH'
         for ifile   = 1:nfile

            fullfilename    = fullfilenames{ifile};
            disp([num2str(ifile),'/',num2str(nfile),' ',fullfilename])
            try
                s   = load(fullfilename);
                DCOHind         = strfind(fullfilename,'DCOH');
                COHfullfilename = [fullfilename([1:(DCOHind(1)-1)]),fullfilename([(DCOHind(1)+1):(DCOHind(2)-1)]),fullfilename([(DCOHind(2)+1):length(fullfilename)])];

                if(exist(COHfullfilename,'file'))
                    isCOHfile   = true;
                    COH         = load(COHfullfilename);
%                     COH         = load(fullfilename);
                else
                    isCOHfile   = false;
                    display('対応するCOHfileが存在しませんでした。');
                end
%                 
%                 if(any(strfind(fullfilename,'Uma')))
%                     Uma_flag    = true
%                     s.Phixy     = unwrapi(s.Phixy+pi);
%                     s.Phiyx     = unwrapi(s.Phiyx+pi);
%                     s.Phixx     = unwrapi(s.Phixx+pi);
%                     s.Phiyy     = unwrapi(s.Phiyy+pi);
%                 else
%                     Uma_flag    = false;
%                 end
                
                if(ifile==1)
                    S.Name  = Name;
                    S.FileNames     = fullfilenames;
                    S.TriggerName   = s.TriggerName;
                    S.ReferenceName = s.ReferenceName;
                    S.TargetName    = s.TargetName;
                    S.Class         = s.Class;
                    S.AnalysisType  = ['AVE',s.AnalysisType];
                    S.TimeRange     = s.TimeRange;
                    S.SampleRate    = s.SampleRate;
                    S.nTrials       = zeros(1,nfile);
                    S.Cxy   = zeros(size(s.Cxy));
                    S.Cyx   = zeros(size(s.Cyx));
                    S.Cxx   = zeros(size(s.Cxx));
                    S.Cyy   = zeros(size(s.Cyy));
                    S.Phixy = zeros([nfile,size(s.Phixy)]);
                    S.Phiyx = zeros([nfile,size(s.Phiyx)]);
                    S.Phixx = zeros([nfile,size(s.Phixx)]);
                    S.Phiyy = zeros([nfile,size(s.Phiyy)]);
                    S.PhixyErr  = zeros([nfile,size(s.Phixy)]);
                    S.PhiyxErr  = zeros([nfile,size(s.Phiyx)]);
                    S.PhixxErr  = zeros([nfile,size(s.Phixx)]);
                    S.PhiyyErr  = zeros([nfile,size(s.Phiyy)]);
                    
                    S.PsigCxy  = zeros(size(s.Cxy));
                    S.PsigCyx  = zeros(size(s.Cyx));
                    S.PsigCxx  = zeros(size(s.Cxx));
                    S.PsigCyy  = zeros(size(s.Cyy));
                    
                    S.freqVec   = s.freqVec;
                    S.ar_order	= s.ar_order;
                    S.DC_method = s.DC_method;
                    S.c95       = [];
                    S.Unit      = s.Unit;

                    if(isfield(s,'sigindCxy'))
                        S.sigindCxy = zeros(size(s.sigindCxy));
                        S.clssigCxy = zeros(size(s.clssigCxy));
                        S.sigindCyx = zeros(size(s.sigindCyx));
                        S.clssigCyx = zeros(size(s.clssigCyx));
                        S.sigindCxx = zeros(size(s.sigindCxx));
                        S.clssigCxx = zeros(size(s.clssigCxx));
                        S.sigindCyy = zeros(size(s.sigindCyy));
                        S.clssigCyy = zeros(size(s.clssigCyy));

                        S.kkherz    = s.kkherz;
                        S.nnherz    = s.nnherz;
                        S.FOI       = s.FOI;
                        S.HUM       = s.HUM;
                    end
                end

                
                if(isCOHfile)
                    if(isfield(COH,'maxclust'))
                        if(isempty(COH.maxclust))
                            isinCOHmaxclust = false(size(COH.freqVec));
                        else
                            if(COH.maxclustpeak > COH_peak_th)
                                isinCOHmaxclust = COH.freqVec>=COH.maxclust(1) & COH.freqVec<=COH.maxclust(end);
                            else
                                isinCOHmaxclust = false(size(COH.freqVec));
                            end
                        end
                    else
                        isinCOHmaxclust = true(size(COH.freqVec));
                    end
                end
                
                
                if(isfield(s,'maxclustCxy'))
                    if(isempty(s.maxclustCxy))
                        isinmaxclustCxy = false(size(s.freqVec));
                    else
                        if(s.maxclustpeakCxy > COH_peak_th)
                            isinmaxclustCxy = s.freqVec>=s.maxclustCxy(1) & s.freqVec<=s.maxclustCxy(end);
                        else
                            isinmaxclustCxy = false(size(s.freqVec));
                        end
                    end
                else
                    isinmaxclustCxy = true(size(s.freqVec));
                end
                if(isfield(s,'maxclustCyx'))
                    if(isempty(s.maxclustCyx))
                        isinmaxclustCyx = false(size(s.freqVec));
                    else
                        if(s.maxclustpeakCyx > COH_peak_th)
                            isinmaxclustCyx = s.freqVec>=s.maxclustCyx(1) & s.freqVec<=s.maxclustCyx(end);
                        else
                            isinmaxclustCyx = false(size(s.freqVec));
                        end
                    end
                else
                    isinmaxclustCyx = true(size(s.freqVec));
                end
                if(isfield(s,'maxclustCxx'))
                    if(isempty(s.maxclustCxx))
                        isinmaxclustCxx = false(size(s.freqVec));
                    else
                        if(s.maxclustpeakCxx > COH_peak_th)
                            isinmaxclustCxx = s.freqVec>=s.maxclustCxx(1) & s.freqVec<=s.maxclustCxx(end);
                        else
                            isinmaxclustCxx = false(size(s.freqVec));
                        end
                    end
                else
                    isinmaxclustCxx = true(size(s.freqVec));
                end
                if(isfield(s,'maxclustCyy'))
                    if(isempty(s.maxclustCyy))
                        isinmaxclustCyy = false(size(s.freqVec));
                    else
                        if(s.maxclustpeakCyy > COH_peak_th)
                            isinmaxclustCyy = s.freqVec>=s.maxclustCyy(1) & s.freqVec<=s.maxclustCyy(end);
                        else
                            isinmaxclustCyy = false(size(s.freqVec));
                        end
                    end
                else
                    isinmaxclustCyy = true(size(s.freqVec));
                end

                
                sigindCxy   = s.Cxy > s.c95 & isinCOHmaxclust & isinmaxclustCxy;
                sigindCyx   = s.Cyx > s.c95 & isinCOHmaxclust & isinmaxclustCyx;
                sigindCxx   = s.Cxx > s.c95 & isinCOHmaxclust & isinmaxclustCxx;
                sigindCyy   = s.Cyy > s.c95 & isinCOHmaxclust & isinmaxclustCyy;

                if(~strcmp(S.TriggerName,s.TriggerName)),S.TriggerName = 'mixed';end
                if(~strcmp(S.ReferenceName,s.ReferenceName)),S.ReferenceName = 'mixed';end
                if(~strcmp(S.TargetName,s.TargetName)),S.TargetName = 'mixed';end
                if(~strcmp(S.Class,s.Class)),S.Class = 'mixed';end
                if(strcmp(S.TimeRange,'mixed') || ~all(S.TimeRange==s.TimeRange)),S.TimeRange = 'mixed';end
                if(strcmp(S.SampleRate,'mixed') || ~all(S.SampleRate==s.SampleRate)),S.SampleRate = 'mixed';end
                S.nTrials(ifile)   = s.nTrials;
                S.Cxy   = nansum([S.Cxy ; s.Cxy],1);
                S.Cyx   = nansum([S.Cyx ; s.Cyx],1);
                S.Cxx   = nansum([S.Cxx ; s.Cxx],1);
                S.Cyy   = nansum([S.Cyy ; s.Cyy],1);
                S.Phixy(ifile,:,:)    = nanmask(s.Phixy,sigindCxy);
                S.PhixyErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cxy),sigindCxy);
                S.Phiyx(ifile,:,:)    = nanmask(s.Phiyx,sigindCyx);
                S.PhiyxErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cyx),sigindCyx);
                S.Phixx(ifile,:,:)    = nanmask(s.Phixx,sigindCxx);
                S.PhixxErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cxx),sigindCxx);
                S.Phiyy(ifile,:,:)    = nanmask(s.Phiyy,sigindCyy);
                S.PhiyyErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cyy),sigindCyy);
                S.PsigCxy   = S.PsigCxy + double(sigindCxy);                % こちらは、isinCOHmaxclustのフィルタがかかっている
                S.PsigCyx   = S.PsigCyx + double(sigindCyx);
                S.PsigCxx   = S.PsigCxx + double(sigindCxx);
                S.PsigCyy   = S.PsigCyy + double(sigindCyy);

                if(strcmp(S.freqVec,'mixed') || ~all(size(S.freqVec)==size(s.freqVec))|| ~all(S.freqVec==s.freqVec)),S.freqVec = 'mixed';end
                if(strcmp(S.ar_order,'mixed')   || ~all(size(S.ar_order)==size(s.ar_order))|| ~all(S.ar_order==s.ar_order)),S.ar_order = 'mixed';end
                if(~strcmp(S.DC_method,s.DC_method)),S.DC_method = 'mixed';end
                if(~strcmp(S.Unit,s.Unit)),S.Unit   = 'mixed';end

                if(isfield(s,'sigindCxy'))
                    S.sigindCxy    = S.sigindCxy + double(s.sigindCxy);     % こちらは、isinCOHmaxclustのフィルタがかかっていない
                    S.clssigCxy    = S.clssigCxy + double(s.clssigCxy);
                    S.sigindCyx    = S.sigindCyx + double(s.sigindCyx);
                    S.clssigCyx    = S.clssigCyx + double(s.clssigCyx);
                    S.sigindCxx    = S.sigindCxx + double(s.sigindCxx);
                    S.clssigCxx    = S.clssigCxx + double(s.clssigCxx);
                    S.sigindCyy    = S.sigindCyy + double(s.sigindCyy);
                    S.clssigCyy    = S.clssigCyy + double(s.clssigCyy);
                    
                    if(strcmp(S.kkherz,'mixed') || ~all(S.kkherz==s.kkherz)),S.kkherz = 'mixed';end
                    if(strcmp(S.nnherz,'mixed') || ~all(S.nnherz==s.nnherz)),S.nnherz = 'mixed';end
                    if(strcmp(S.FOI,'mixed') || ~all(S.FOI==s.FOI)),S.FOI = 'mixed';end
                    if(strcmp(S.HUM,'mixed') || ~all(S.HUM==s.HUM)),S.HUM= 'mixed';end
                end
            catch
                disp(['  *** error occurred in ', fullfilename]);
            end
        end

        S.Cxy   = S.Cxy / nfile;
        S.Cyx   = S.Cyx / nfile;
        S.Cxx   = S.Cxx / nfile;
        S.Cyy   = S.Cyy / nfile;
        assignin('base','S',S);
        S.Phixy     = shiftdim(nancircmean(S.Phixy,1),1);
        S.PhixyErr  = sqrt(shiftdim(nansum(S.PhixyErr.^2,1),1)) ./ S.PsigCxy;   % ゼロ割起こりえます。
        S.PsigCxy   = S.PsigCxy / nfile;
        
        S.Phiyx     = shiftdim(nancircmean(S.Phiyx,1),1);
        S.PhiyxErr  = sqrt(shiftdim(nansum(S.PhiyxErr.^2,1),1)) ./ S.PsigCyx;   % ゼロ割起こりえます。
        S.PsigCyx   = S.PsigCyx / nfile;

        S.Phixx     = shiftdim(nancircmean(S.Phixx,1),1);
        S.PhixxErr  = sqrt(shiftdim(nansum(S.PhixxErr.^2,1),1)) ./ S.PsigCxx;   % ゼロ割起こりえます。
        S.PsigCxx   = S.PsigCxx / nfile;

        S.Phiyy     = shiftdim(nancircmean(S.Phiyy,1),1);
        S.PhiyyErr  = sqrt(shiftdim(nansum(S.PhiyyErr.^2,1),1)) ./ S.PsigCyy;   % ゼロ割起こりえます。
        S.PsigCyy   = S.PsigCyy / nfile;
        
        S.c95       = avecohcl(0.05,S.nTrials);

        if(isfield(s,'sigindCxy'))
            S.sigindCxy = S.sigindCxy / nfile;
            S.clsindCxy = S.clssigCxy / nfile;

            S.sigindCyx = S.sigindCyx / nfile;
            S.clsindCyx = S.clssigCyx / nfile;

            S.sigindCxx = S.sigindCxx / nfile;
            S.clsindCxx = S.clssigCxx / nfile;

            S.sigindCyy = S.sigindCyy / nfile;
            S.clsindCyy = S.clssigCyy / nfile;

        end
%% COH
    case 'COH'
         for ifile   = 1:nfile

            fullfilename    = fullfilenames{ifile};
            disp([num2str(ifile),'/',num2str(nfile),' ',fullfilename])
            try
                s   = load(fullfilename);
                if(ifile==1)
                    %         S       = s;
                    S.Name  = Name;
                    S.FileNames     = fullfilenames;
                    S.TriggerName   = s.TriggerName;
                    S.ReferenceName = s.ReferenceName;
                    S.TargetName    = s.TargetName;
                    S.Class         = s.Class;
                    S.AnalysisType  = ['AVE',s.AnalysisType];
                    S.TimeRange     = s.TimeRange;
                    S.SampleRate    = s.SampleRate;
                    S.nTrials       = zeros(1,nfile);
                    S.Cxy   = zeros(size(s.Cxy));
                    S.Pxx   = zeros(size(s.Pxx));
                    S.Pyy   = zeros(size(s.Pyy));
                    S.Phi   = zeros([nfile,size(s.Phi)]);
                    S.PhiErr    = zeros([nfile,size(s.Phi)]);
                    S.Psig  = zeros(size(s.Cxy));
                    S.freqVec   = s.freqVec;
                    S.c95       = [];
                    S.Unit      = s.Unit;

                    if(isfield(s,'sigind'))
                        S.sigind    = zeros(size(s.sigind));
                        S.clssig    = zeros(size(s.clssig));
                        S.kkherz    = s.kkherz;
                        S.nnherz    = s.nnherz;
                        S.FOI       = s.FOI;
                        S.HUM       = s.HUM;
                    end
                end
                
                if(isfield(s,'maxclust'))
                    if(isempty(s.maxclust))
                        isinmaxclust = false(size(s.freqVec));
                    else
                        if(s.maxclustpeak > COH_peak_th)
                            isinmaxclust = s.freqVec>=s.maxclust(1) & s.freqVec<=s.maxclust(end);
                        else
                            isinmaxclust = false(size(s.freqVec));
                        end
                    end
                else
                    isinmaxclust = true(size(s.freqVec));
                end
                sigind  = s.Cxy > s.c95 & isinmaxclust;

                if(~strcmp(S.TriggerName,s.TriggerName)),S.TriggerName = 'mixed';end
                if(~strcmp(S.ReferenceName,s.ReferenceName)),S.ReferenceName = 'mixed';end
                if(~strcmp(S.TargetName,s.TargetName)),S.TargetName = 'mixed';end
                if(~strcmp(S.Class,s.Class)),S.Class = 'mixed';end
                if(strcmp(S.TimeRange,'mixed') || ~all(S.TimeRange==s.TimeRange)),S.TimeRange = 'mixed';end
                if(strcmp(S.SampleRate,'mixed') || ~all(S.SampleRate==s.SampleRate)),S.SampleRate = 'mixed';end
                S.nTrials(ifile)   = s.nTrials;
                S.Cxy   = S.Cxy + s.Cxy;
                S.Pxx   = S.Pxx + s.Pxx;
                S.Pyy   = S.Pyy + s.Pyy;
                S.Phi(ifile,:,:)    = nanmask(s.Phi,sigind);
                S.PhiErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cxy),sigind);
                S.Psig  = S.Psig + double(sigind);                          % こちらは、isinCOHmaxclustのフィルタがかかっている

                if(strcmp(S.freqVec,'mixed') || ~all(S.freqVec==s.freqVec)),S.freqVec = 'mixed';end
                if(~strcmp(S.Unit,s.Unit)),S.Unit   = 'mixed';end

                if(isfield(s,'sigind'))
                    S.sigind    = S.sigind + double(s.sigind);              % こちらは、isinCOHmaxclustのフィルタがかかっていない
                    S.clssig    = S.clssig + double(s.clssig);
                    if(strcmp(S.kkherz,'mixed') || ~all(S.kkherz==s.kkherz)),S.kkherz = 'mixed';end
                    if(strcmp(S.nnherz,'mixed') || ~all(S.nnherz==s.nnherz)),S.nnherz = 'mixed';end
                    if(strcmp(S.FOI,'mixed') || ~all(S.FOI==s.FOI)),S.FOI = 'mixed';end
                    if(strcmp(S.HUM,'mixed') || ~all(S.HUM==s.HUM)),S.HUM= 'mixed';end
                end
            catch
                disp(['  *** error occurred in ', fullfilename]);
            end
        end

        S.Cxy   = S.Cxy / nfile;
        S.Pxx   = S.Pxx / nfile;
        S.Pyy   = S.Pyy / nfile;

        S.Phi   = shiftdim(nancircmean(S.Phi,1),1);
        S.PhiErr = sqrt(shiftdim(nansum(S.PhiErr.^2,1),1)) ./ S.Psig;   % ゼロ割起こりえます。
        S.Psig  = S.Psig / nfile;

        S.c95   = avecohcl(0.05,S.nTrials);

        if(isfield(s,'sigind'))
            S.sigind    = S.sigind / nfile;
            S.clsind    = S.clssig / nfile;
        end
        
    otherwise
%% いまのところAVEWCOH か　AVEWCOHTIMEAVE

        for ifile   = 1:nfile

            fullfilename    = fullfilenames{ifile};
            disp([num2str(ifile),'/',num2str(nfile),' ',fullfilename])
            try
                s   = load(fullfilename);
                if(ifile==1)
                    %         S       = s;
                    S.Name  = Name;
                    S.FileNames     = fullfilenames;
                    S.TriggerName   = s.TriggerName;
                    S.ReferenceName = s.ReferenceName;
                    S.TargetName    = s.TargetName;
                    S.Class         = s.Class;
                    S.AnalysisType  = ['AVE',s.AnalysisType];
                    S.TimeRange     = s.TimeRange;
                    S.SampleRate    = s.SampleRate;
                    S.nTrials       = zeros(1,nfile);
                    S.Cxy   = zeros(size(s.Cxy));
                    S.Pxx   = zeros(size(s.Pxx));
                    S.Pyy   = zeros(size(s.Pyy));
                    S.Pxy   = zeros(size(s.Pxy));
                    S.Phi   = zeros([nfile,size(s.Phi)]);
                    S.PhiErr    = zeros([nfile,size(s.Phi)]);
                    S.Psig  = zeros(size(s.Cxy));
                    S.freqVec   = s.freqVec;
                    S.timeVec	= s.timeVec;
                    S.sigma     = s.sigma;
                    S.c95       = [];
                    S.Unit      = s.Unit;

                    if(isfield(s,'sigind'))
                        S.sigind    = zeros(size(s.sigind));
                        S.clssig    = zeros(size(s.clssig));
                        S.kkherz    = s.kkherz;
                        S.nnherz    = s.nnherz;
                        S.FOI       = s.FOI;
                        S.HUM       = s.HUM;
                    end
                end

                sigind  = s.Cxy > s.c95;

                if(~strcmp(S.TriggerName,s.TriggerName)),S.TriggerName = 'mixed';end
                if(~strcmp(S.ReferenceName,s.ReferenceName)),S.ReferenceName = 'mixed';end
                if(~strcmp(S.TargetName,s.TargetName)),S.TargetName = 'mixed';end
                if(~strcmp(S.Class,s.Class)),S.Class = 'mixed';end
                if(strcmp(S.TimeRange,'mixed') || ~all(S.TimeRange==s.TimeRange)),S.TimeRange = 'mixed';end
                if(strcmp(S.SampleRate,'mixed') || ~all(S.SampleRate==s.SampleRate)),S.SampleRate = 'mixed';end
                S.nTrials(ifile)   = s.nTrials;
                S.Cxy   = S.Cxy + s.Cxy;
                S.Pxx   = S.Pxx + s.Pxx;
                S.Pyy   = S.Pyy + s.Pyy;
                S.Pxy   = S.Pxy + s.Pxy;
                S.Phi(ifile,:,:)    = nanmask(s.Phi,sigind);
                S.PhiErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cxy),sigind);
                S.Psig  = S.Psig + double(sigind);

                if(strcmp(S.freqVec,'mixed') || ~all(S.freqVec==s.freqVec)),S.freqVec = 'mixed';end
                if(strcmp(S.timeVec,'mixed') || ~all(S.timeVec==s.timeVec)),S.timeVec = 'mixed';end
                if(strcmp(S.sigma,'mixed') || ~all(size(S.sigma)==size(s.sigma))|| ~all(S.sigma==s.sigma)),S.sigma = 'mixed';end

                if(~strcmp(S.Unit,s.Unit)),S.Unit   = 'mixed';end

                if(isfield(s,'sigind'))
                    S.sigind    = S.sigind + double(s.sigind);
                    S.clssig    = S.clssig + double(s.clssig);
                    if(strcmp(S.kkherz,'mixed') || ~all(S.kkherz==s.kkherz)),S.kkherz = 'mixed';end
                    if(strcmp(S.nnherz,'mixed') || ~all(S.nnherz==s.nnherz)),S.nnherz = 'mixed';end
                    if(strcmp(S.FOI,'mixed') || ~all(S.FOI==s.FOI)),S.FOI = 'mixed';end
                    if(strcmp(S.HUM,'mixed') || ~all(S.HUM==s.HUM)),S.HUM= 'mixed';end
                end
            catch
                disp(['  *** error occurred in ', fullfilename]);
            end
        end

        S.Cxy   = S.Cxy / nfile;
        S.Pxx   = S.Pxx / nfile;
        S.Pyy   = S.Pyy / nfile;
        S.Pxy   = S.Pxy / nfile;

        S.Phi   = shiftdim(nancircmean(S.Phi,1),1);
        S.PhiErr = sqrt(shiftdim(nansum(S.PhiErr.^2,1),1)) ./ S.Psig;   % ゼロ割起こりえます。
        S.Psig  = S.Psig / nfile;

        S.c95   = avecohcl(0.05,S.nTrials);

        if(isfield(s,'sigind'))
            S.sigind    = S.sigind / nfile;
            S.clsind    = S.clssig / nfile;
        end
end
% warning('on')