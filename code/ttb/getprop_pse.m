function getprop_pse
%   y  = getprop('PropName1','PropName2',...)


fid = fopen('pseBure.xls','a');
fprintf(fid,'\n%s',datestr(now));

fprintf(fid,'\n%s','No');
fprintf(fid,'\t%s','expname');
fprintf(fid,'\t%s','filename');
fprintf(fid,'\t%s','pseind');
fprintf(fid,'\t%s','baseonset(sec)');
fprintf(fid,'\t%s','baseoffset(sec)');
fprintf(fid,'\t%s','basemean(uV)');
fprintf(fid,'\t%s','basesd(uV)');
fprintf(fid,'\t%s','basensd');
fprintf(fid,'\t%s','nnsec');
fprintf(fid,'\t%s','kksec');
fprintf(fid,'\t%s','alpha');
fprintf(fid,'\t%s','pseonset(sec)');
fprintf(fid,'\t%s','pseoffset(sec)');
fprintf(fid,'\t%s','pseduration(sec)');
fprintf(fid,'\t%s','peaktime(sec)');
fprintf(fid,'\t%s','peakamp(uV)');
fprintf(fid,'\t%s','peakmean(uV)');
fprintf(fid,'\t%s','PPI');
fprintf(fid,'\t%s','MPI');
fprintf(fid,'\t%s','API');
fprintf(fid,'\t%s','PWHM_onset');
fprintf(fid,'\t%s','PWHM_onset');
fprintf(fid,'\t%s','PWHM_onset');
fprintf(fid,'\t%s','PWHM_onset');
fprintf(fid,'\t%s','p-value');
fprintf(fid,'\t%s','issig');



ParentDir   = fullfile(datapath,'PSE');
[Expnames,Filenames]    = getprop_pse_set;
Expnames    = uiselect(Expnames);
Filenames    = uiselect(Filenames);

nExp    = length(Expnames);
nFile   = length(Filenames);

ii  = 0;
for iExp    = 1:nExp
    Expname = Expnames{iExp};
    disp([Expname,'(',num2str(iExp),'/',num2str(nExp),')'])
    for iFile   = 1:nFile
        Filename    = Filenames{iFile};
        Tarfile     = fullfile(ParentDir,Expname,Filename);
        try
            s   = load(Tarfile);

            nPeaks      = s.npeaks;
            if(nPeaks~=0)
                Base    = s.base;
                for iPeaks  =1:nPeaks
                    ii  = ii+1;
                    Peak   = s.peaks(iPeaks);


                    fprintf(fid,'\n%d',ii);  %'No')
                    fprintf(fid,'\t%s',Expname);  %'expname')
                    fprintf(fid,'\t%s',Filename);  %'filename')
                    fprintf(fid,'\t%d',iPeaks);  %'pseind')
                    fprintf(fid,'\t%f',Base.onset);  %'baseonset(sec)')
                    fprintf(fid,'\t%f',Base.offset);  %'baseoffset(sec)')
                    fprintf(fid,'\t%f',Base.mean);  %'basemean(uV)')
                    fprintf(fid,'\t%f',Base.sd);  %'basesd(uV)')
                    fprintf(fid,'\t%d',Base.nsd);  %'nsd')
                    fprintf(fid,'\t%f',Base.nnsec);  %'nnsec')
                    fprintf(fid,'\t%f',Base.kksec);  %'kksec')
                    fprintf(fid,'\t%f',Base.alpha);  %'alpha')
                    fprintf(fid,'\t%f',Peak.onset);  %'pseonset(sec)')
                    fprintf(fid,'\t%f',Peak.offset);  %'pseoffset(sec)')
                    fprintf(fid,'\t%f',Peak.duration);  %'pseduration(sec)')
                    fprintf(fid,'\t%f',Peak.peaktime);  %'psetime(sec)')
                    fprintf(fid,'\t%f',Peak.peak);  %pseamp(uV)')
                    fprintf(fid,'\t%f',Peak.mean);  %'psemean(uV)')
                    fprintf(fid,'\t%f',Peak.PPI);  %'PPI')
                    fprintf(fid,'\t%f',Peak.MPI);  %'MPI')
                    fprintf(fid,'\t%f',Peak.API);  %'API')
                    fprintf(fid,'\t%f',Peak.PWHM_onset);  %'PWHM_onset')
                    fprintf(fid,'\t%f',Peak.PWHM_offset);  %'PWHM_onset')
                    fprintf(fid,'\t%f',Peak.PWHM_duration);  %'PWHM_onset')
                    fprintf(fid,'\t%f',Peak.PWHM_halfmax);  %'PWHM_onset')
                    fprintf(fid,'\t%f',Peak.p);  %'p-value')
                    fprintf(fid,'\t%d',Peak.issig);  %'issig')

                end
            end
            disp(['L--- (',num2str(iFile),'/',num2str(nFile),')  ',Tarfile])
            indicator((iExp-1)*nFile+iFile,nExp*nFile)
        catch
            keyboard
            message = [' L-- *** error occured in ',Tarfile];
            disp(message)
            errorlog(message)
            indicator((iExp-1)*nFile+iFile,nExp*nFile)
        end
    end

end

fclose(fid);
indicator(0,0)