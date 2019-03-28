function handles=error_log_display(handles,ME)
  pre = '<HTML><FONT color="';
    post = '</FONT></HTML>';
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= [pre ,rgb2Hex( [235 53 53] ), '">' ,'Error at line ',num2str(ME.stack(1).line),' in ', ME.stack(1).name,': ',ME.message , post];
    set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
