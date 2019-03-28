function handles=localizer_collect_data(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Performs GLM to identify voxels belonging to the target brain region.
%BCI data structure will be passed in as the argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
     handles.b.figures.preImageFile='';
     handles=initiate_figure_vis(handles);
    for current_cond=1:handles.b.proto.seq_length
        handles.b.Feedback.current_block=handles.b.proto.seqview.block{current_cond};
        handles.b.Feedback.current_cond=current_cond;
        handles.b.Feedback.current_volume= handles.b.Feedback.current_block(1);
        handles.b.ui.backcolor=handles.b.proto.seqview.color{current_cond};
        handles=bci_image_display(handles,'update_back' );
        for ii=handles.b.pre.dummy_volumes_skip+handles.b.Feedback.current_block(1):handles.b.pre.dummy_volumes_skip+handles.b.Feedback.current_block(2)
            if  strcmp(handles.b.pre.MR_scanner,'Siemens')
                handles.b.current_volume.fname_input_next=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,ii) '.dcm'];
            elseif strcmp(handles.b.pre.MR_scanner,'Philips')
                handles.b.current_volume.fname_input_next=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,ii) '.img'];
            end
            bci_ui_wait(handles.b.current_volume.fname_input_next);
            i1=ii-handles.b.pre.dummy_volumes_skip;
            if  strcmp(handles.b.pre.MR_scanner,'Siemens')
                handles.b.current_volume.hdr= spm_dicom_headers(handles.b.current_volume.fname_input_next);
                handles=spm_dicom_convert(handles);
                %            handles.b.current_volume.V = spm_create_vol(handles.b.current_volume.V);
                %            handles.b.current_volume.vol_data = spm_write_plane(handles.b.current_volume.V,handles.b.current_volume.volume,':');
                functional_image{i1}=handles.b.current_volume.fname; %#ok<AGROW>
                handles.b.current_volume.vol_data =handles.b.current_volume.V;
            elseif strcmp(handles.b.pre.MR_scanner,'Philips')
                functional_image{i1}=handles.b.current_volume.fname_input_next; %#ok<AGROW>
                handles.b.current_volume.vol_data = spm_vol(handles.b.current_volume.fname_input_next);
            end
            if ii==handles.b.pre.dummy_volumes_skip+1,
                handles.b.pre.normalization.ref_file=functional_image{i1};
                handles.b.pre.normalization.ref_file_vol_data=spm_vol(handles.b.pre.normalization.ref_file);
            else
                
                [handles]=sic_realign(handles);
                
                handles.b.Feedback.current_volume=ii-handles.b.pre.dummy_volumes_skip;
                handles.b.Feedback.current_para_tot(i1,:)=handles.b.current_volume.para(2,:);
                handles=plot_image_para(handles);
                handles.b.current_volume=[];
            end
        end
    end
    
    figure(handles.b.figures.image_vis_fig);
    if strcmp(handles.b.session_type,'Localizer Run')
        saveas(gcf,[handles.b.conf.localizer_path,filesep, handles.b.conf.sub_name,'_',num2str(handles.b.conf.run_num),'_','localizer_realign.jpg'])
    elseif  strcmp(handles.b.session_type,'Dummy Functional Run')
        saveas(gcf,[handles.b.conf.dummy_path,filesep, handles.b.conf.sub_name,'_',num2str(handles.b.conf.run_num),'_','dummy_realign.jpg'])
    end
   
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end