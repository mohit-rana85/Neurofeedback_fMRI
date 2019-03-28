 function V = smooth_vol(P,hld,wrp,fwhm)
 try
% Convolve the volume in memory.
s  = sqrt(sum(P.mat(1:3,1:3).^2)).^(-1)*(fwhm/sqrt(8*log(2)));
x  = round(6*s(1)); x = -x:x;
y  = round(6*s(2)); y = -y:y;
z  = round(6*s(3)); z = -z:z;
x  = exp(-(x).^2/(2*(s(1)).^2));
y  = exp(-(y).^2/(2*(s(2)).^2));
z  = exp(-(z).^2/(2*(s(3)).^2));
x  = x/sum(x);
y  = y/sum(y);
z  = z/sum(z);

i  = (length(x) - 1)/2;
j  = (length(y) - 1)/2;
k  = (length(z) - 1)/2;
d  = [hld*[1 1 1]' wrp(:)];
V  = spm_bsplinc(P,d);
spm_conv_vol(V,V,x,y,z,-[i j k]);
 
catch ME
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack.line),' in ', ME.stack.name,': ',ME.message];
    set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    
end