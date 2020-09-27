function handles=dummy_functional(handles)
try
    
    functional_image={};
    
    set(handles.b.figures.image_vis_fig,'visible','on');
    functional_image{handles.b.pre.Dummy_volumes-handles.b.pre.dummy_volumes_skip}='';
    for ii=1:handles.b.pre.Dummy_volumes
        %ii=ii+1;
        if  strcmp(handles.b.pre.MR_scanner,'Siemens')
            handles.b.current_volume.fname_input_next=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,ii),'.', handles.b.pre.file_format];
        elseif strcmp(handles.b.pre.MR_scanner,'Philips')
            handles.b.current_volume.fname_input_next_ori=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,ii),'.',handles.b.pre.file_format];
            handles.b.current_volume.fname_input_next=[handles.b.conf.dummy_path, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,ii),'.',handles.b.pre.file_format];
            copyfile( handles.b.current_volume.fname_input_next_ori, handles.b.current_volume.fname_input_next);
        end
        bci_ui_wait(handles.b.current_volume.fname_input_next);
        
        if ii >handles.b.pre.dummy_volumes_skip
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
                handles.b.current_volume.V=handles.b.current_volume.vol_data ;
                handles.b.current_volume.volume= spm_read_vols(handles.b.current_volume.vol_data) ;
            end
            if ii==handles.b.pre.dummy_volumes_skip+1,
                handles.b.pre.normalization.ref_file=functional_image{i1};
                handles.b.pre.normalization.ref_file_vol_data=spm_vol(handles.b.pre.normalization.ref_file);
            else
          
                [handles]=sic_realign(handles);
               
                handles.b.Feedback.current_volume=ii-handles.b.pre.dummy_volumes_skip;
                %             try
                %                 handles.b.Feedback.current_hdr  = load_nii(functional_image{i1});
                %             catch
                %                 handles.b.Feedback.current_hdr  = load_untouch_nii(functional_image{i1});
                %             end
                
                handles.b.Feedback.current_para_tot(i1,:)=handles.b.current_volume.para(2,:);
                if  handles.b.Feedback.current_volume==2
                     aa=(round(handles.b.Feedback.current_para_tot(i1,:)*100))/100;
                     set( handles.b.figures.Feedback_TextBox_run,'string',['X:   ',num2str(aa(1)),'   ','Y:   ',num2str(aa(2)),'   ','Z:   ',num2str(aa(3)),'   ','Pitch:   ',num2str(aa(4)),'   ','Roll:   ',num2str(aa(5)),'   ','Yaw:   ',num2str(aa(6)),'   ']);
                end
                handles=plot_image_para(handles);
                handles.b.current_volume=[];
            end
            
        end
    end
    
    
    sic_reslice(functional_image,handles.b.pre.realign_rs_opt);
    
    [pth,nm,xt] = fileparts(deblank(functional_image{1}));
     handles.b.pre.normalization.spm_mean_img= [pth,filesep,'mean',nm,xt];
     if  handles.b.conf.session==1 && handles.b.Feedback.dummy_idx==1
         copyfile([pth,filesep,'mean',nm,xt], [handles.b.pre.original_file_path,filesep,'mean',nm,xt]);
         handles.b.pre.normalization.initial_functional_image=[handles.b.pre.original_file_path,filesep,'mean',nm,xt];
         handles.b.pre.ori.initial_mean_file=[handles.b.pre.original_file_path,filesep,'mean',nm,xt];
     end
     handles.b.iserror=0;
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end
% function out=time_out_in(filename,handles)
% t = clock;out=0;
% while(exist(filename)~=2 )
%     if (etime(clock,t) > 2*handles.b.roi.TR),
%         %disp([message filename]);
%         % error('Time out');
%         out=1;
%         break;
%     end
%     pause(0.01);
% end
% end
