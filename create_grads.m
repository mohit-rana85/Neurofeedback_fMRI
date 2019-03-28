function handles=create_grads(current_fig, ui, grads, force_creation,handles,aa)
try
    if handles.b.flag.isref_zero
        
        INCREMENT_GRADS=0;
    else
        INCREMENT_GRADS=handles.b.ui.thermo_grads/2;
    end
    
    
    
    if ( abs(grads) > 0.5*handles.b.ui.thermo_grads) & ( abs(grads) < handles.b.ui.thermo_grads) %grads can be negative also, so absolute is taken
        return; %don't have to create
        
    elseif (force_creation ~= 1) & ( abs(grads) == handles.b.ui.thermo_grads)
        return;
        
    else  %create new grads if grads > handles.b.ui.thermo_grads
        
        if (force_creation ~= 1)
            %if the current number of grads is greater than handles.b.ui.thermo_grads,
            %increase
            delete_grads; %first delete the previous grads
            handles.b.ui.thermo_grads = abs(grads) + INCREMENT_GRADS;
            
            if (handles.b.ui.thermo_grads <= 0)
                handles.b.ui.thermo_grads = INCREMENT_GRADS; %to make sure value does not go below zero
            end
            
        end
        
        %fprintf('\nNew handles.b.ui.thermo_grads = %d\n', handles.b.ui.thermo_grads);
    end
    
    %compute the co-ordinates of all the graduations and store it for later
    %use in update_thermo
    if handles.b.flag.isShaping
        grad.w = handles.b.ui.thermo.wi+0.05;
        grad.gap = 0.0; %some problem here! does not work if the grad.gap is more than 1.0!!!!
        grad.h = (handles.b.ui.thermo.hi / handles.b.ui.thermo_grads) - grad.gap*2;
        %handles.b.ui.thermo_grads=10;
        bottom_xleft = handles.b.ui.thermo.Xi(1,1);
        bottom_xright = handles.b.ui.thermo.Xi(1,2);
        bottom_yleft =  handles.b.ui.thermo.Yi(1,1) + grad.gap; %start after the gape
        bottom_yright =   handles.b.ui.thermo.Yi(1,2) + grad.gap;
        set(ui.thermo_ax.handle,'ylim',[bottom_yleft, bottom_yleft+ grad.h* handles.b.ui.thermo_grads]);
    else
        grad.w = handles.b.ui.thermo.wi;
        grad.gap = 0.0; %some problem here! does not work if the grad.gap is more than 1.0!!!!
        
        grad.h = (handles.b.ui.thermo.hi / handles.b.ui.thermo_grads) - grad.gap*2;
        
        bottom_xleft = handles.b.ui.thermo.Xi(1,1);
        bottom_xright = handles.b.ui.thermo.Xi(1,2);
        bottom_yleft =  handles.b.ui.thermo.Yi(1,1) + grad.gap; %start after the gape
        bottom_yright =handles.b.ui.thermo.Yi(1,2) + grad.gap;
    end
    for i=1:handles.b.ui.thermo_grads
        add_y = (grad.gap + grad.h)*(i-1);
        grad.coords(i).X = [bottom_xleft bottom_xright bottom_xright bottom_xleft]; %5 points to close the polygon
        grad.coords(i).Y = [(bottom_yleft+add_y) (bottom_yright+add_y) (bottom_yright+grad.h+add_y) (bottom_yleft+grad.h+add_y)];
        
        %baseline
        if(i > fix(handles.b.ui.thermo_grads/aa))
            grad.color(i).value = [1 0 0]; %red
        else
            grad.color(i).value = [0 0 1]; %blue
        end
        
        %draw the object but set its visibility to off now
        %set the figure and the axes
        figure(current_fig); %set the current fig
        axes(ui.thermo_ax.handle); %background of the axes
        handles.b.ui.last_gobjects.update(i) = patch(grad.coords(i).X, grad.coords(i).Y, grad.color(i).value);
        set( handles.b.ui.last_gobjects.update(i), 'Visible', 'off');
        
        handles.b.ui.grad=grad;
    end
    if  handles.b.ui.SHOW_REWARD  && handles.b.flag.isContinuous && strcmp(handles.b.ui.feedbacktype , 'THERMOMETER')
        nn=figure(current_fig);
        % set(nn,'Units','normalized');
        handles.b.figures.high_limit=uicontrol('Parent',nn,'Style','text',...
            'Units','Normalized',...
            'FontUnits','normalized',...
            'FontSize',0.7,...
            'HorizontalAlignment','left',...
            'BackgroundColor',[0.46 0.46 0.46],...
            'visible','off',...
            'Position',[0.601   0.65    0.07   0.05]);
        handles.b.figures.low_limit=uicontrol(nn,'Style','text',...
            'Units','Normalized',...
            'FontUnits','normalized',...
            'FontSize',0.7,...
            'HorizontalAlignment','center',...
            'BackgroundColor',[0.46 0.46 0.46],...
            'visible','off',...
            'Position',[0.601   0.22    0.07   0.05]);
        handles.b.figures.cum_feed=uicontrol(nn,'Style','text',...
            'Units','Normalized',...
            'FontUnits','normalized',...
            'FontSize',0.75,...
            'HorizontalAlignment','center',...
            'BackgroundColor',[0.46 0.46 0.46],...
            'visible','off',...
            'Position',[0.38 0.75 0.25 0.1]);
        set(handles.b.figures.low_limit,'string','$0');
        set(handles.b.figures.high_limit,'string',['$',num2str(handles.b.ui.MAX_EUROS)]);
        
    end
    handles.b.ui.previous_grads =  handles.b.ui.last_gobjects.update;
catch ME
    handles=error_log_display(handles,ME);
end