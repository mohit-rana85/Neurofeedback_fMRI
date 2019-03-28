 function handles=plot_image_para(handles)
try
    images=zeros(size(handles.b.pre.frame));
    
    %nn=reshape(handles.b.pre.current_img,[handles.b.pre.current_hdr.dim(2),handles.b.pre.current_hdr.dim(3),handles.b.pre.current_hdr.dim(4)]);
    x=handles.b.pre.space;y=handles.b.pre.space;
    if strcmp(handles.b.session_type,'Dummy Functional Run')|| ~handles.b.flag.isnormalization ||  strcmp(handles.b.session_type,'Localizer Collect Data')
        handles.b.pre.func_planes=[];
        handles.b.pre.func_planes=1:handles.b.current_volume.V.dim(3);
        dim=handles.b.current_volume.V.dim(1:2);
        nn=handles.b.current_volume.volume;
    else
        dim= handles.b.pre.normalization.mean_VOI.dim;%handles.b.current_volume.V_norm.dim(1:2);
        nn=handles.b.current_volume.volume_norm;
    end
    iin2=0;
    for in2=handles.b.pre.func_planes(1):handles.b.pre.func_planes(end)
        iin2=iin2+1;
        images(x+1:x+ dim(2),y+1:y+ dim(1))= rot90(nn(:,:,in2),1);
        if mod(iin2,handles.b.pre.column)==0
            y=handles.b.pre.space;x=floor(iin2/handles.b.pre.column)* dim(2)+handles.b.pre.space*(floor(iin2/handles.b.pre.row)+1);
        else
            y=mod(iin2,handles.b.pre.column)*dim(1)+handles.b.pre.space*(mod(iin2,handles.b.pre.column)+1);
        end
        
    end
    [~,bbb]=hist(images(:),10);
    images1=double(images)./bbb(8);
    handles.b.pre.current_image_rgb= ind2rgb(round(images1.*size(handles.b.pre.color_map_images,1)),handles.b.pre.color_map_images);
    set(handles.b.figures.functional_image,'Cdata',handles.b.pre.current_image_rgb);
    axes(handles.b.figures.para_axes)
    set(handles.b.figures.h1,'YData',handles.b.Feedback.current_para_tot(1:handles.b.Feedback.current_volume,1));
    set(handles.b.figures.h2,'YData',handles.b.Feedback.current_para_tot(1: handles.b.Feedback.current_volume,2));
    set(handles.b.figures.h3,'YData',handles.b.Feedback.current_para_tot(1: handles.b.Feedback.current_volume,3));
    set(handles.b.figures.h4,'YData',handles.b.Feedback.current_para_tot(1: handles.b.Feedback.current_volume,4));
    set(handles.b.figures.h5,'YData',handles.b.Feedback.current_para_tot(1: handles.b.Feedback.current_volume,5));
    set(handles.b.figures.h6,'YData',handles.b.Feedback.current_para_tot(1: handles.b.Feedback.current_volume,6))
    drawnow
catch ME
    handles=error_log_display(handles,ME);
end