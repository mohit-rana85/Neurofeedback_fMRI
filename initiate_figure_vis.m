function handles=initiate_figure_vis(handles)
try
    set(0,'units','pixels')
    %Obtains this pixel information
    handles.b.pre.screen_res = get(0,'screensize');
    handles.b.figures.image_vis_fig=figure('MenuBar','none','NumberTitle', 'off','Color',[0.5 0.5 0.5],'resize','off','Name','Images and Realignment parameters','visible','on','Position', [round(handles.b.pre.screen_res(3)*0.33),round(handles.b.pre.screen_res(4)*0.05),round(handles.b.pre.screen_res(3)*0.33), round(handles.b.pre.screen_res(4)*0.92)]);
    handles.b.figures.para_axes=axes('Position',[0.09 0.04 0.85 0.2]);
    position_figure=get(handles.b.figures.image_vis_fig,'position');
    axes_TextBox = uicontrol('style','text','parent', handles.b.figures.image_vis_fig,'position',[(position_figure(3)*0.35),(position_figure(4)*0.28),190,15],'string','Realignment Parameters','FontWeight','BOLD');
    image_TextBox = uicontrol('style','text','parent', handles.b.figures.image_vis_fig,'position',[(position_figure(3)*0.32),(position_figure(4)*0.98),150 ,15],'string','Functional Images','FontWeight','BOLD');
    handles.b.figures.Feedback_TextBox = uicontrol('style','text','parent', handles.b.figures.image_vis_fig,'position',[(position_figure(3)*0.091),(position_figure(4)*0.25),round(handles.b.pre.screen_res(3)*0.33)*0.85,20],'string',['X:      -        ','Y:      -        ','Z:      -        ','Pitch:      -        ','Roll:      -        ','Yaw:      -        '],'FontWeight','BOLD','FontSize',11);
   
    handles.b.figures.image_axes=axes('Position',[0.05 0.3 0.85 0.66]);
    if  strcmp(handles.b.session_type,'Feedback Run')
        uicontrol('style','text','parent', handles.b.figures.image_vis_fig,'position',[(position_figure(3)*0.01),(position_figure(4)*0.68),30,30],'string','R','FontSize',20,'FontWeight','BOLD');
        uicontrol('style','text','parent', handles.b.figures.image_vis_fig,'position',[(position_figure(3)*0.95),(position_figure(4)*0.68),30,30],'string','L','FontSize',20,'FontWeight','BOLD');
    end
    set(handles.b.figures.image_axes,'xticklabel',[]);set(handles.b.figures.image_axes,'yticklabel',[]);
    set(handles.b.figures.image_axes,'XTick',[]);set(handles.b.figures.image_axes,'YTick',[]);
    handles.b.pre.color_map_frame=[0 0 0; 1 1 1];
    handles.b.pre.color_map_images=colormap('gray');
    if  ~strcmp(handles.b.session_type,'Dummy Functional Run')&& ~strcmp(handles.b.session_type,'Anatomy Run') && ~strcmp(handles.b.session_type,'Localizer Collect Data')  
        handles.b.pre.color_map_mask=[0 0 0; 0 0.69 0.94; 1 0 0;0.61 0.01 0.98;1 0.37 0.02;0.94 0.08 0.83;0.1 0.94 0.29;1 1 1];
        if handles.b.flag.is_mask_MNI
            if length(handles.b.roi.count)~=size((handles.b.roi.MNI),1)
                text_prompt='';
                for ii=1: length(handles.b.roi.count)
                    text_prompt{ii} = ['MNI coordinates for ROI',num2str(ii),': '];
                end
                MNI = inputdlg(text_prompt,'Input MNI' ,1 );
                uiwait(MNI);
                handles.b.pre.MNI= str2num(cell2mat(MNI)); %#ok<ST2NM>
                if length(handles.b.roi.count)~=length(handles.b.pre.MNI)
                    errordlg('Not right number of mask files selected','File Error');
                    return
                end
            end
            [handles, masks] = mni2cor(handles.b.roi.MNI, handles.b.pre.normalization.mean_VOI.mat,handles.b.roi.ROI_Size,handles.b.roi.ROI_type,handles);
            handles.b.pre.normalization.global_voxels=(handles.b.pre.normalization.global_voxels-sum( handles.b.roi.mask_vox_ss,2));
            hdr.hdr.dime.dim(2:4)=handles.b.pre.normalization.mean_VOI.dim;
            handles.b.pre.hdr.dim(2:4)=handles.b.pre.normalization.mean_VOI.dim;
            
        else
            if length(handles.b.roi.count)~=length(handles.b.pre.masks)
                
                [handles.b.pre.masks,handles.b.pre.masks_path]=uigetfile({'*.nii','*.img'},['Please select ',num2str(length(handles.b.roi.count)), 'number of mask images:' ],'multiselect','on');
                if length(handles.b.roi.count)~=length(handles.b.pre.masks)
                    errordlg('Not right number of mask files selected','File Error');
                end
            end
            for ii=1:length(handles.b.pre.masks)
                try
                    hdr=spm_read_vols( spm_vol([ handles.b.pre.masks{ii}]));
                catch
                    hdr=load_untouched_nii( [ handles.b.pre.masks{ii}]);
                end
                Image=hdr.img(:);
                if ii==1
                    masks =zeros(size(Image,1),1);
                end
                
                masks (Image>0 )=ii ;
                handles.b.roi.mask_vox_ss(:,ii)=(Image>0);
            end
        end
        
        if ~isfield(handles.b.pre,'Label_radar')
            % handles.b.pre.Label_radar={'Global'};
            if handles.b.flag.is_mask_MNI
                for ii=1:size(handles.b.roi.MNI,1)
                    if ii==size(handles.b.roi.MNI,1)
                        handles.b.pre.Label_radar{ii}=[mni_label(handles.b.roi.image_coordinate(ii,:),handles),'(Ref)'];
                    else
                        handles.b.pre.Label_radar{ii}=mni_label(handles.b.roi.image_coordinate(ii,:),handles);
                    end
                end
            else
                for ii=1:length(handles.b.pre.masks)
                    [~, handles.b.pre.Label_radar{ii},~]=fileparts(handles.b.pre.masks{ii});
                end
                
            end
        end
        handles.b.roi.mask_vox=masks;
        %     handles.b.roi.mask_vox_ss(:,size(handles.b.roi.mask_vox_ss,2)+1)=handles.b.pre.global_voxels;
        %handles.b.roi.mask_vox(:, size(handles.b.roi.mask_vox_ss,2)+1)= sum(handles.b.roi.mask_vox_ss,2);
        masks_Im=reshape(masks,[hdr.hdr.dime.dim(3),hdr.hdr.dime.dim(2),hdr.hdr.dime.dim(4)]);
        handles.b.pre.mask_imag=zeros( hdr.hdr.dime.dim(3)*handles.b.pre.row+handles.b.pre.space*(handles.b.pre.row+1),hdr.hdr.dime.dim(2)*handles.b.pre.column+handles.b.pre.space*(handles.b.pre.column+1));
        x=handles.b.pre.space;y=handles.b.pre.space;
        iin2=0;
        for in2=handles.b.pre.func_planes(1):handles.b.pre.func_planes(end)
            iin2=iin2+1;
            handles.b.pre.mask_imag(x+1:x+hdr.hdr.dime.dim(3),y+1:y+hdr.hdr.dime.dim(2))= masks_Im(:,:,in2);
            %         figure, imshow(handles.b.pre.mask_imag,[0 3])
            if mod(iin2,handles.b.pre.column)==0
                y=handles.b.pre.space;x=floor(iin2/handles.b.pre.column)* hdr.hdr.dime.dim(3)+handles.b.pre.space*(floor(iin2/handles.b.pre.row)+1);
            else
                y=mod(iin2,handles.b.pre.column)*hdr.hdr.dime.dim(2)+handles.b.pre.space*(mod(iin2,handles.b.pre.column)+1);
            end
            
            
        end
        
        
        
    end
    handles.b.pre.frame= zeros( handles.b.pre.hdr.dim(3)*handles.b.pre.row+handles.b.pre.space*(handles.b.pre.row+1), handles.b.pre.hdr.dim(2)*handles.b.pre.column+handles.b.pre.space*(handles.b.pre.column+1));
    axes(handles.b.figures.image_axes);
    for ii=1: 2
        handles.b.pre.frame(:,ii: handles.b.pre.hdr.dim(2)+2:size(handles.b.pre.frame,2))=1;
        handles.b.pre.frame(ii: handles.b.pre.hdr.dim(3)+2:size(handles.b.pre.frame,1),:)=1;
    end
    handles.b.pre.image_rgb= ind2rgb(round(zeros(size(handles.b.pre.frame)).*size(handles.b.pre.color_map_images,1)),handles.b.pre.color_map_images);
    handles.b.pre.frame_rgb=ind2rgb( handles.b.pre.frame+1,handles.b.pre.color_map_frame);
    handles.b.figures.functional_image=imshow(handles.b.pre.image_rgb);colormap( handles.b.pre.color_map_images);
    hold on;
    if ~strcmp(handles.b.session_type,'Dummy Functional Run') &&   ~strcmp(handles.b.session_type,'Localizer Collect Data')  
        handles.b.pre.mask_rgb=ind2rgb(handles.b.pre.mask_imag+1,handles.b.pre.color_map_mask);
        
        handles.b.figures.mask=image(handles.b.pre.mask_rgb);
        a = 0.9;
        set(handles.b.figures.mask,'AlphaData',(handles.b.pre.mask_imag).*a)
        % handles.b.pre.mask_rgb=ind2rgb(handles.b.pre.mask_imag+1,handles.b.pre.color_map_mask);
        if handles.b.flag.is_mask_MNI
            L = line(ones( size(handles.b.roi.MNI,1)),ones( size(handles.b.roi.MNI,1)));
            MM=handles.b.pre.color_map_mask(2: size(handles.b.roi.MNI,1)+1,:);
            set(L,{'color'},mat2cell(MM ,ones(1, size(handles.b.roi.MNI,1)),3));
    
        else
            L = line(ones(length(handles.b.pre.masks)),ones(length(handles.b.pre.masks)));
            MM=handles.b.pre.color_map_mask(2:length(handles.b.pre.masks)+1,:);
            set(L,{'color'},mat2cell(MM ,ones(1,length(handles.b.pre.masks)),3));
        end
        hh=legend(handles.b.pre.Label_radar,'Location','southoutside','Orientation','horizontal');
        set(hh,'color',[0.6 0.6 0.6]);
    end
    handles.b.figures.frame=image(handles.b.pre.frame_rgb);
    a = 0.8;
    set(handles.b.figures.frame,'AlphaData',(handles.b.pre.frame>0).*a)
    
    axes(handles.b.figures.para_axes)
    
    
    if strcmp(handles.b.session_type,'Dummy Functional Run')  
        x=1:(handles.b.pre.Dummy_volumes-handles.b.pre.dummy_volumes_skip);y=zeros(1,(handles.b.pre.Dummy_volumes-handles.b.roi.volumes_skip));
        handles.b.figures.h1=plot(handles.b.figures.para_axes,nan,'color','r', 'LineWidth',2);
        hold on
        handles.b.figures.h2=plot(handles.b.figures.para_axes,nan,'color',[255,69,0]./255, 'LineWidth',2);
        handles.b.figures.h3=plot(handles.b.figures.para_axes,nan,'color',[1 1 0], 'LineWidth',2);
        handles.b.figures.h4=plot(handles.b.figures.para_axes,nan,'color','k', 'LineWidth',2);
        handles.b.figures.h5=plot(handles.b.figures.para_axes,nan,'color','c', 'LineWidth',2);
        handles.b.figures.h6=plot(handles.b.figures.para_axes,nan,'color','m', 'LineWidth',2);
        L1 = line(ones(6),ones(6));
        set(L1,{'color'},{'r';[255,69,0]./255;[1 1 0];'k';'c';'m'});
        hh1= legend({'X','Y','Z','Pitch','Roll','Yaw'},'Location','southoutside','Orientation','horizontal');
        set(hh1,'color',[0.6 0.6 0.6])
        xlabel('TRs'); ylabel('Degree/mm');
        set(handles.b.figures.para_axes,'xlim',[1 length(x)]);set(handles.b.figures.para_axes,'ylim',[-1 1]);
   elseif strcmp(handles.b.session_type,'Localizer Collect Data') || strcmp(handles.b.session_type,'Feedback Run')
        x=1:handles.b.roi.volumes;handles.b.pre.current_para_tot=zeros(handles.b.roi.volumes,6);
        hold on
        handles.b.figures.h1=plot(handles.b.figures.para_axes,nan,'color','r', 'LineWidth',2);
        %set(handles.b.figures.h1,'yData','handles.b.pre.current_para_tot(:,1)');
        
        handles.b.figures.h2=plot(handles.b.figures.para_axes,nan,'color',[255,69,0]./255, 'LineWidth',2);
        handles.b.figures.h3=plot(handles.b.figures.para_axes,nan,'color',[1 1 0], 'LineWidth',2);
        handles.b.figures.h4=plot(handles.b.figures.para_axes,nan,'color','k', 'LineWidth',2);
        handles.b.figures.h5=plot(handles.b.figures.para_axes,nan,'color','c', 'LineWidth',2);
        handles.b.figures.h6=plot(handles.b.figures.para_axes,nan,'color','m', 'LineWidth',2);
        L1 = line(ones(6),ones(6));
        set(L1,{'color'},{'r';[255,69,0]./255;[1 1 0];'k';'c';'m'});
        hh1= legend({'X','Y','Z','Pitch','Roll','Yaw'},'Location','southoutside','Orientation','horizontal');
        set(hh1,'color',[0.6 0.6 0.6]);
        xlabel('TRs'); ylabel('Degree/mm');
        set(handles.b.figures.para_axes,'ylim',[-5 5]);
        set(handles.b.figures.para_axes,'xlim',[1 handles.b.roi.volumes-handles.b.roi.volumes_skip]);
        axes(handles.b.figures.para_axes);
        for i = 1: length(handles.b.proto.line_graph.seqview)
            if i==1
                xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
            else
                xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
            end
            % patch(xx,[-1 1 1 -1],'facecolor',b.proto.seqview.color{1,i}(1:3),'edgecolor', b.proto.seqview.color{1,i}(1:3));
            patch(xx,[-5 5 5 -5],handles.b.proto.line_graph.seqview_color{1,i}(1:3));
        end
        %  uistack(handles.b.figures.h1,'top');
        set(handles.b.figures.para_axes,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
        set(handles.b.figures.para_axes,'YLim',[-5 5]);
    end
catch ME
    handles=error_log_display(handles,ME);
end
