function status = update_thermo(current_fig, ui, incr_decr, color,handles)
%This function updates the display of the thermometer view for the new data
%incr_decr is an integer which can be positive, negative or zero
%c is the color with which the data needs to be displayed.




%set the figure and the axes
try
    figure(current_fig); %set the current fig
    if handles.b.proto.cond_images
        set(gcf, 'Color','k');
    else
        set(gcf, 'Color', ui.backcolor);
    end
    axes(handles.b.ui.thermo_ax.handle); %background of the axes
    
    %make sure incr_decr is an integer
    incr_decr = fix(incr_decr); %note: fix works for even neg numbers!
    
    %update grads
    if handles.b.flag.isref_zero
        handles.b.ui.grad.newcount = fix(incr_decr); %baseline +/- incr_decr
    else
        handles.b.ui.grad.newcount = fix(handles.b.ui.thermo_grads/2 + incr_decr); %baseline +/- incr_decr
        %create_grads(current_fig, ui, incr_decr, 0); %will create new grads only if grad.newcount > MAX_GRADUATIONS
    end
    %make the previous grads invisible first
    set( handles.b.ui.previous_grads(:), 'Visible', 'off');
    
    if(handles.b.ui.grad.newcount > 0) %lower limit is zero
        
        if(handles.b.ui.grad.newcount > handles.b.ui.thermo_grads) %upper limit
            handles.b.ui.grad.newcount = handles.b.ui.thermo_grads;
        end
        set( handles.b.ui.last_gobjects.update(1:handles.b.ui.grad.newcount), 'Visible', 'on');
        handles.b.ui.previous_grads =  handles.b.ui.last_gobjects.update(1:handles.b.ui.grad.newcount);
    end
    xx=get(handles.b.ui.thermo_ax.handle,'ylim');
    %handles.b.ui.last_gobjects.thermo(3) = line(cl.X, cl.Y, 'LineStyle', cl.linestyle, 'Color',  cl.color);
    %handles.b.ui.last_gobjects.thermo(3) = line([0 handles.b.ui.thermo_ax.w], xx(1)+ones(1,2)*((xx(2)-xx(1))/2), 'LineStyle', '--', 'Color', 'r','LineWidth', 3);
    
    %draw the centerline
    uistack(handles.b.ui.last_gobjects.thermo(3) ,'top');
    %
    status = 1;
    
    return;
    
    %------------------------------------------------------------------------
    
catch ME
    figure(handles.b.figures.figure_session_log);
     handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack(1).line),' in ', ME.stack(1).name,': ',ME.message];
     set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));

end


