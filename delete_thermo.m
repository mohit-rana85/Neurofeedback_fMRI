function status = delete_thermo(handles)

try
%first delete the grads
delete_grads(handles);

%delete the condition image
%delete(last_gobjects.image);
handles.b.ui.last_gobjects.image = 0;

%then delete the thermo
if(handles.b.ui.last_gobjects.thermo ~= 0)
	t = size(handles.b.ui.last_gobjects.thermo,2);
	delete(handles.b.ui.last_gobjects.thermo(1:t)); 
    handles.b.ui.last_gobjects.thermo = 0; %to be safe
end

status = 1;
return;
catch ME
    handles=error_log_display(handles,ME);
end