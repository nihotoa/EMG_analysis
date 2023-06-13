function export2text
% ttb用のデータ形式（.mat）からtextファイルにエクスポートするためのプログラム
% 荻原先生にデータを渡すときなどに使用。

[S,fullfilenames]   = topen;
if(isempty(S))
    disp('User pressed cancel.')
    return;
end

if(~iscell(S))
    S   = {S};
    fullfilenames   = {fullfilenames};
end
nS  = length(S);

for iS=1:nS
    fullfilename    = fullfilenames{iS};
    SS  = S{iS};
    [pathname,filename,ext] = fileparts(fullfilename);
    
    if(strcmp(SS.Class,'virtual channel'))
        SS   = loaddata(fullfilename);
    end
    
    fullfilename2   = fullfile(pathname,[filename,'.txt']);
    
    
    fid = fopen(fullfilename2,'w');
    
    
    switch SS.Class
        case 'continuous channel'
            YData   = SS.Data;
            nData   = size(YData,2);
            XData   = ((1:nData)-1) ./ SS.SampleRate + SS.TimeRange(1);
            
            fprintf(fid,'Platform\t%s\n',SS.PlatForm);
            fprintf(fid,'Name\t%s\n',SS.Name);
            fprintf(fid,'DataPoints\t%d\n',nData);
            fprintf(fid,'SampleRate(Hz)\t%f\n',SS.SampleRate);
            fprintf(fid,'Class\t%s\n',SS.Class);
            fprintf(fid,'StartTime(sec)\t%f\n',SS.TimeRange(1));
            fprintf(fid,'StopTime(sec)\t%f\n',SS.TimeRange(2));
            fprintf(fid,'Unit\t%s\n',SS.Unit);
            fprintf(fid,'\n');
            fprintf(fid,'Time(sec)\tData\n');
            
            for iData=1:nData
                fprintf(fid,'%f\t%f\n',XData(iData),YData(iData));
            end
            
            
            
            
            
        case 'timestamp channel'
            Data    = SS.Data ./ SS.SampleRate +  + SS.TimeRange(1);
            nData   = size(Data,2);
            
            fprintf(fid,'Platform\t%s\n',SS.PlatForm);
            fprintf(fid,'Name\t%s\n',SS.Name);
            fprintf(fid,'DataPoints\t%d\n',nData);
            fprintf(fid,'SampleRate(Hz)\t%f\n',SS.SampleRate);
            fprintf(fid,'Class\t%s\n',SS.Class);
            fprintf(fid,'StartTime(sec)\t%f\n',SS.TimeRange(1));
            fprintf(fid,'StopTime(sec)\t%f\n',SS.TimeRange(2));
            fprintf(fid,'\n');
            fprintf(fid,'Time(sec)\n');
            
            for iData=1:nData
                fprintf(fid,'%f\n',Data(iData));
            end
            
    end
        
    
    fclose(fid);
    disp([num2str(iS),'/',num2str(nS),': ',fullfilename2])
end
end