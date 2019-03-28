function [y1,y2,y3]=coords(p,M1,M2,x1,x2,x3)
try
% Rigid body transformation of a set of coordinates.
M  = (inv(M2)*inv(spm_matrix(p))*M1);
y1 = M(1,1)*x1 + M(1,2)*x2 + M(1,3)*x3 + M(1,4);
y2 = M(2,1)*x1 + M(2,2)*x2 + M(2,3)*x3 + M(2,4);
y3 = M(3,1)*x1 + M(3,2)*x2 + M(3,3)*x3 + M(3,4);
catch ME
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack.line),' in ', ME.stack.name,': ',ME.message];
    set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    
end