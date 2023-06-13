function bmi_car(command)

if nargin<1
    command = 'initialize';
end


hFig    = findobj('Tag','bmi_car');

if(~isempty(hFig))
    data    = get(hFig,'UserData');
else
    data    = [];
end


switch command
    case 'initialize'
        data.YLim                   = [-1 1];
        data.BLim                   = [0   1];
        data.amax                   = [0.08 0.1];
        data.Ath                    = [0.4 0.6];
        data.usbgon                 = [0 0];
        
        
        %%
        %% initialize figure
        hFig = figure('Tag','bmi_car',...
            'Name','BMI_CAR ver. 1.0',...
            'NumberTitle','off',...
            'DeleteFcn','bmi_car(''close'');');

        hAxis(1)    = subplot(2,4,[1:3],'Parent',hFig,...
            'Color',[0 0.5 0],...
             'XLim',[-inf inf],...
            'YLim',data.YLim,...
            'YLimMode','Manual');
        hAxis(2)    = subplot(2,4,[5:7],'Parent',hFig,...
            'Color',[0 0.5 0],...
             'XLim',[-inf inf],...
             'YLim',data.YLim,...
            'YLimMode','Manual');
        hInd(1)    = subplot(2,4,4,'Parent',hFig,...
            'Color',[1 1 1],...
            'XTick',[],...
            'YLim',data.BLim,...
            'YLimMode','Manual',...
            'Nextplot','replacechildren');
        hInd(2)    = subplot(2,4,8,'Parent',hFig,...
            'Color',[1 1 1],...
            'XTick',[],...
            'YLim',data.BLim,...
            'YLimMode','Manual',...
            'Nextplot','replacechildren');
        %%
        rc  = usbg(1,bin2dec('0000'));
        if(rc<1)
            error('USB-IO‚ª‹@”\‚µ‚Ä‚Ü‚¹‚ñ')
        end
        
        
        
        
        %% initialize analoginput
        ai = analoginput('winsound');

        set(ai,...
            'SampleRate', 44100,...
            'TriggerRepeat', 1,...
            'TriggerType', 'Manual',...
            'SamplesPerTrigger', floor(44100/10),...
            'TimerPeriod', 0.1,...
            'Timerfcn','bmi_car(''timeraction'')' );
        addchannel(ai, [1 2]);



        %%
        %% save data
        data.handle.figure         = hFig;
        data.handle.axes           = hAxis;
        data.handle.ind            = hInd;
        data.nChannels          =2;
        data.ai                      = ai;
        data.state = 0;
        
        
        



        %%
        %% suspend sampling
        start(data.ai);


        set(hFig,'UserData',data);
        disp(['BMI_CAR: ', command])
    case 'start'
        
        trigger(data.ai);
        d = getdata(data.ai, get(data.ai, 'SamplesPerTrigger'));
        a   = sqrt(mean(d.^2,1));

        for ii = 1:data.nChannels;
            hLine(ii) = line('Parent', data.handle.axes(ii),...
                'Xdata', [1:(length(d(:,1)))]/data.ai.SampleRate*1000,...
                'Ydata', d(:,ii),...
                'Color', 'w',...
                'HandleVisibility', 'off');

            hBar(ii) = bar(data.handle.ind(ii),1,a(ii),1,'FaceColor','g','EdgeColor','none');

        end
        drawnow;


        % Store the handle to the lines in the data structure.
        data.handle.line = hLine;
        data.handle.bar     = hBar;

        data.state = 1;

        set(hFig,'UserData',data);
        disp(['BMI_CAR: ', command])
    case 'timeraction'
        if data.state == 1
                    % Get the handles.
            hLine = data.handle.line;
            hBar    = data.handle.bar;

            % Execute a peekdata.
            x = peekdata(data.ai, data.ai.SamplesPerTrigger);
            
            x   = detrend(x,'constant');
%             keyboard
%             x   = diff([[0,0]; x]);
            
            a   = sqrt(mean(x.^2,1));
            A   = a./data.amax;
            
            % Update the plot.
            
            for ii=1:data.nChannels
                set(hLine(ii), 'Xdata', 1:length(x(:,1)),...
                    'YData', x(:,ii));
                
            if(A(ii)>data.Ath(2))
                data.usbgon(ii) = 1;
                set(hBar(ii),'YData',A(ii),...
                    'FaceColor','r');
            elseif(A(ii)>data.Ath(1))
                data.usbgon(ii) = 0;
                set(hBar(ii),'YData',A(ii),...
                    'FaceColor','y');
            else
                data.usbgon(ii) = 0;
                set(hBar(ii),'YData',A(ii),...
                    'FaceColor','g');
            end
                
                
            end
            
            if(all(data.usbgon))
            outdata = '0001';
            elseif(data.usbgon(1)==1&data.usbgon(2)==0)
            outdata = '0101';
            elseif(data.usbgon(1)==0&data.usbgon(2)==1)
            outdata = '1001';
            else
                outdata='0000';
            end
            
            usbg(1,bin2dec(outdata));
            
            
            
            %
            %                 ymin = min(x(:));
            %                 ymax = max(x(:));
            %
            %                 % If Nans are returned base the limit off the other.
            %                 if isnan(ymin) & isnan(ymax)
            %                     ymin = -0.01;
            %                     ymax = 0.01;
            %                 elseif isnan(ymin)
            %                     ymin = ymax - (abs(ymax)/2);
            %                 elseif isnan(ymax)
            %                     ymax = ymin + (abs(ymin)/2);
            %                 end
            %
            %                 % Handle the case when the limits are equal.
            %                 if ymin == ymax
            %                     ymin = ymin - (abs(ymin)/2);
            %                     ymax = ymax + (abs(ymax)/2);
            %                 end
            %
            %                 % If they are still equal (if they both were zero).
            %                 if ymin == ymax
            %                     ymin = -0.01;
            %                     ymax = 0.01;
            %                 end
            %
            %                 set(data.handle.axes, 'YLim', [ymin, ymax],...
            %                     'YTick', linspace(ymin, ymax, 11),...
            %                     'YTickLabel', {num2str(ymin,4), '','','', '','',...
            %                     '','','','',num2str(ymax,4)});
            %                 set(data.handle.uicontrol(3), 'String', num2str((ymax-ymin)/10,3));
            %             end

            drawnow;
            disp(['BMI_CAR: ', command])
        end

        case 'resume'
        data.state = 1;
        set(data.handle.figure,'UserData',data);
        disp(['BMI_CAR: ', command])
    case 'pause'
        data.state = 0;
        set(data.handle.figure,'UserData',data);
        disp(['BMI_CAR: ', command])
        
    case 'stop'
        data.state = 0;
        set(data.handle.figure,'UserData',data);
        stop(data.ai)
                disp(['BMI_CAR: ', command])
    case 'close'
        data.state = 0;
        set(data.handle.figure,'UserData',data);
        
        stop(data.ai)
        delete(data.ai)
        
        clear usbg
                disp(['BMI_CAR: ', command])
        
end


