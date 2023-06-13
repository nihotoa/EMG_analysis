function output_txt = DataCursorFcn(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
% UD  = get(event_obj,'UserData');

output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

% if(~isempty(UD))
%     UDnames = fieldnames(UD);
%     nUD     = length(UDnames);
%     
%     for iUD=1:nUD
%         output_txt{end+1} = [UDnames{iUD},': ',num2str(UD.(UDnames{iUD}))];
%     end
%     
% end
% output_txt = UDnames{iUD}

