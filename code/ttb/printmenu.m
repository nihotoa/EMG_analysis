function printmenu(command)
if(nargin<1)
    fig = gcf;
    command = 'initialize';
elseif(ischar(command))
    fig = gcf;
else
    fig = command;
    command = 'initialize';
end

switch command
    case 'initialize'
        m = uimenu(fig,'Label','Print');
        uimenu(m,'Label','Print(jpg)','Callback','printmenu(''jpg'')','Enable','on','Checked','off');
        uimenu(m,'Label','Print(eps)','Callback','printmenu(''eps'')','Enable','on','Checked','off');
        uimenu(m,'Label','Page setup','Callback','pagesetupdlg(gcf)','Enable','on','Checked','off','Separator','on');

    case 'jpg'
        outputfile  = get(fig,'Name');
        outputpath  = fullfile(datapath,'figures');
        [outputfile,outputpath] = uiputfile(fullfile(outputpath,[outputfile,'.jpg']),'ファイルの保存');

        if(outputpath~=0)
            print(fig,'-djpeg90','-r300',fullfile(outputpath,deext(outputfile)));
            disp([fullfile(outputpath,deext(outputfile)),'.jpg was printed out.'])
        end

    case 'eps'
        outputfile  = get(fig,'Name');
        outputpath  = fullfile(datapath,'figures');
        [outputfile,outputpath] = uiputfile(fullfile(outputpath,[outputfile,'.eps']),'ファイルの保存');

        if(outputpath~=0)
            print(fig,'-depsc2',fullfile(outputpath,deext(outputfile)));
            disp([fullfile(outputpath,deext(outputfile)),'.eps was printed out.'])
        end
end
