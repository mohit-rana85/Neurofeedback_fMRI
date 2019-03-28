function status = delete_grads(handles)
try
if (handles.b.ui.last_gobjects.update ~= 0)
	u = size(handles.b.ui.last_gobjects.update,2);
    delete(handles.b.ui.last_gobjects.update(1:u));
    handles.b.ui.last_gobjects.update = 0; %to be safe
end

status = 1;
return;
catch ME
    handles=error_log_display(handles,ME);
end