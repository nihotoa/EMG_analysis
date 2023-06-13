function spike2ana(binwidth)

[S,filename]    = topen;

if ~strcmp(S.Class,'timestamp channel')
    error('File is not timestamp channel')
    return;
end

variables   = fieldnames(S);
clear('S')
load(filename)

Data    = makebinary(Data);
Data    = bin2ana(Data,binwidth);
SampleRate  = SampleRate / binwidth;
Name    = [Name,'_',num2str(SampleRate),'Hz'];
Class   = 'continuous channel';
[a,b]   = extension(filename);
filename    = [b,'_',num2str(SampleRate),'Hz'];
disp(filename)
keyboard
save(filename,variables{:})

