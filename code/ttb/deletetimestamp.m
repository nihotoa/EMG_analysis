function deletetimestamp(Trials)

% deletetimestamp(Trials)
%
% after delete timestamps, it is recommended to run makeOriginalChannels_btc([112])


[oldS,filename] = topen;
oldnTrials      = size(oldS.Data,2);
newS            = oldS;
newS.Data(:,Trials) = [];
newnTrials      = size(newS.Data,2);


Answer  = questdlg(['Are you surely want to delete ',num2str(oldnTrials-newnTrials),' timestamps?'],...
    'delete timestamp',...
    'OK','Cancel');

switch Answer
    case 'OK'
        oldfilename = [deext(filename),'(TSdeleted',datestr(now,1),')'];
        save(oldfilename,'-struct','oldS');
        save(filename,'-struct','newS');
        disp(oldfilename)
        disp(filename)
    case 'Cancel'
        disp('User Pressed Cancel.')
end

