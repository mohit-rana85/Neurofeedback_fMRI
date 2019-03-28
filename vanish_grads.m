function status = vanish_grads(yes,handles)
try
global last_gobjects;

if (last_gobjects.update ~= 0)
	u = size(last_gobjects.update,2);
    for id = 1:u
        if(yes)
            set(last_gobjects.update(id), 'Visible', 'off');
        else
            set(last_gobjects.update(id), 'Visible', 'on');
        end
            
    end
    last_gobjects.update = 0; %to be safe
end

status = 1;
return;
catch ME
  figure(handles.b.figures.figure_session_log);
     handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack(1).line),' in ', ME.stack(1).name,': ',ME.message];
     set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
end