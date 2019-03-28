function display_condimage(cond_image, handles)

try
    %delete the previous image if exists
    if(handles.b.ui.last_gobjects.image ~= 0)
        delete(handles.b.ui.last_gobjects.image);
    end
    
    axes(handles.b.ui.img.cond_axhandle);
    
    handles.b.ui.last_gobjects.image = image(cond_image);axis off;
catch ME
    handles=error_log_display(handles,ME);
end