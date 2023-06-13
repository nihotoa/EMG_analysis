function fmanova_btc(gnames,TimeWindow)
% fmanova_btc({'Rest', 'Grip', 'Hold'},[-1.0 -0.5; 0.00 0.30; 0.75 1.25]) % Uma
% fmanova_btc({'Rest', 'Grip', 'Hold'},[-1.0 -0.5; 0.00 0.30; 1.20 1.70]) % Aoba
% fmanova_btc({'Rest', 'Grip', 'Hold'},[-1.0 -0.5; 0.00 0.30; 0.90 1.20]) % Eito


warning('off');


ncond   = length(gnames);

ParentDir   = uigetdir(fullfile(datapath,'STA'),'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'対象とするfileを選択してください');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(Tarfiles)
                try
                    Tarfile = Tarfiles{ii};
                    Tar_hdr = load(fullfile(ParentDir,InputDir,Tarfile),'nTrials','XData','SampleRate');
                    Tar_dat = load(fullfile(ParentDir,InputDir,['._',Tarfile]),'TrialData');
                    
                    Data = zeros(Tar_hdr.nTrials,ncond);
                    OutputFile  = ['FMCMP(',deext(Tarfile)];
                    
                    for icond=1:ncond
                        OutputFile  = [OutputFile,',',gnames{icond}];
                        TW  = TimeWindow(icond,:);
                        if(islogical(Tar_dat.TrialData))  % psth
                            ind = Tar_hdr.XData >= TW(1) & Tar_hdr.XData<=TW(2);
                            Data(:,icond)   = sum(Tar_dat.TrialData(:,ind),2) .* Tar_hdr.SampleRate ./ sum(ind); % sps
                        else
                            ind = Tar_hdr.XData >= TW(1) & Tar_hdr.XData<=TW(2);
                            Data(:,icond)   = mean(Tar_dat.TrialData(:,ind),2);
                        end
                    end
                    
                    Y   = fmanova(Data,gnames);
                    Y.TimeWindow    = TimeWindow;
                    
                    
                    OutputFile  = [OutputFile,').mat'];
                    OutputFile  = fullfile(ParentDir,InputDir,OutputFile);
                    
                    save(OutputFile,'-struct','Y')
                    
                    clear('Tar_hdr','Tar_dat','Y')

                    disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
%                 indicator(ii,length(Tarfiles))
            end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');


function Y  = fmanova(Data,gnames)

Y.AnalysisType  = 'FMCMP';
Y.gnames    = gnames;
Y.Data  = Data;
Y.nTrials   = size(Data,1);
Y.mean  = mean(Data,1);
Y.std   = std(Data,1,1);

Y.alpha = 0.05;
Y.ctype = 'bonferroni';
Y.reps  = 1;


% friedman
[Y.friedman.p,Y.friedman.table,Y.friedman.stats] = friedman(Y.Data,Y.reps,'off');
[Y.friedman.comparison,Y.friedman.means,Y.friedman.h,Y.friedman.gnames] = multcompare(Y.friedman.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
Y.friedman.issig = (0 < Y.friedman.comparison(:,3) | Y.friedman.comparison(:,5) < 0);
Y.friedman.gnames    = gnames;

% anova1
[Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Data,gnames,'off');
[Y.anova1.comparison,Y.anova1.means,Y.anova1.h,Y.anova1.gnames] = multcompare(Y.anova1.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
Y.anova1.issig = (0 < Y.anova1.comparison(:,3) | Y.anova1.comparison(:,5) < 0);
