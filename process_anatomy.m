function handles=process_anatomy(handles)
try
    h = waitbar(0,'Please wait...');
    fname_input=[];out=0;
    if strcmp(handles.b.pre.MR_scanner,'Siemens')
        
        for ii=1: handles.b.pre.NrOfSlices_Anatomy
            fname_input_next=[handles.b.conf.watch_dir filesep sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,ii),'.',handles.b.pre.file_format];
            if ii~=handles.b.pre.NrOfSlices_Anatomy
                bci_ui_wait(fname_input_next );
            else
                bci_ui_wait(fname_input_next );
            end
            
            if ii==1
                fname_input = fname_input_next;
            else
                fname_input=char(fname_input, fname_input_next);
            end
            if out==1
                break
            end
        end
        
        handles.b.current_volume.hdr= spm_dicom_headers(fname_input);
        handles=spm_dicom_convert(handles);
        if iscell(handles.b.current_volume.fname)
            handles.b.pre.anatomical_image=handles.b.current_volume.fname{1,1};
        else
            handles.b.pre.anatomical_image=handles.b.current_volume.fname;
        end
        %    [, s_name]=sic_spm8_dicom_convert(hdr,handles.b.conf.anatomy_path,handles.b.conf.sub_name);
    elseif strcmp(handles.b.pre.MR_scanner,'Philips')
        handles.b.pre.anatomical_image_ori=[handles.b.conf.watch_dir filesep sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,1) ,'.', handles.b.pre.file_format];
        while 1
            if  exist( handles.b.pre.anatomical_image_ori,'file')==2  
                break
            end
        end
        handles.b.pre.anatomical_image=[handles.b.conf.anatomy_path, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,1) ,'.', handles.b.pre.file_format];
        copyfile(handles.b.pre.anatomical_image_ori, handles.b.pre.anatomical_image)
    end
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Segmenting the structural image..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    waitbar(1/10)
    obj.image=  spm_vol(char(handles.b.pre.anatomical_image));
    tpm=['.\SPM\tpm\TPM.nii,1';
        '.\SPM\tpm\TPM.nii,2';
        '.\SPM\tpm\TPM.nii,3';
        '.\SPM\tpm\TPM.nii,4';
        '.\SPM\tpm\TPM.nii,5';
        '.\SPM\tpm\TPM.nii,6'];
    nit= 1;
    alpha= 12;
    bb=  NaN(2,3);
    vox =  3;
    cleanup =  1;
    mrf=1;
    spm_check_orientations(obj.image);
    tpm = spm_load_priors8(tpm); obj.tpm =tpm;
    obj.lkp  = [ 1     2     3     3     4     4     4     5     5     5     5     6     6];
    obj.fwhm= 0;
    obj.biasreg=1.0000e-03;
    obj.biasfwhm=60;
    obj.reg =[0    0.0010    0.5000    0.0500    0.2000];
    obj.samp =3;
    Affine  = eye(4);
    waitbar(2/10)
    Affine = spm_maff8(obj.image(1),obj.samp,(obj.fwhm+1)*16,tpm,Affine,'mni'); % Closer to rigid
    Affine = spm_maff8(obj.image(1),obj.samp, obj.fwhm,tpm,Affine,'mni');
    obj.Affine = Affine;
    handles.b.pre.res  = spm_preproc8(obj);
    %save( [ anatomy_file(end-4),'_seg8.mat' ],'-struct','res', '-v7.3');
    tmp1 = [1 0 0 0; 1  0 0 0 ; 1 0 0 0 ; 0 0 0 0 ;0 0 0 0;0 0 0 0];
    tmp2 = [1 1];
    tmp3 = [1 1];
    waitbar(3/10)
    spm_preproc_write8( handles.b.pre.res,tmp1,tmp2,tmp3, mrf, cleanup, bb, vox);
    %res = spm_preproc( handles.b.pre.anatomical_image,handles.b.pre.seg_flag);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Segmentation done..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    [path1,nam,ext]=fileparts(handles.b.pre.anatomical_image);
    handles.b.pre.normalization.norm_def=[path1,filesep,'y_',nam,ext];
    %%% imcalc
    flags.dmtx=0; flags.mask=0; flags.interp=1; flags.dtype=4;
    handles.b.pre.normalization.extracted_anatomical_image=[path1,filesep,'e_',nam,ext];
    handles.b.pre.normalization.wm_anatomical_image=[path1,filesep,'c2',nam,ext];
    handles.b.pre.normalization.gm_anatomical_image=[path1,filesep,'c1',nam,ext];
    handles.b.pre.normalization.extract_brain=spm_imcalc({handles.b.pre.normalization.gm_anatomical_image;handles.b.pre.normalization.wm_anatomical_image;[path1,filesep,'c3',nam,ext];[path1,filesep,'m',nam,ext]},handles.b.pre.normalization.extracted_anatomical_image,'(i1 + i2 + i3) .* i4',flags);
    mkdir([path1,filesep,'Original']);
    handles.b.pre.original_file_path=[path1,filesep,'Original'];
    handles.b.pre.ori.extracted_anatomical_image=[path1,filesep,'Original',filesep,'e_',nam,ext];
    handles.b.pre.ori.gm_anatomical_image=[path1,filesep,'Original',filesep,'c1',nam,ext];
    handles.b.pre.ori.wm_anatomical_image=[path1,filesep,'Original',filesep,'c2',nam,ext];
    handles.b.pre.ori.norm_mat_file=[ handles.b.pre.original_file_path ,filesep,'normalization.mat'];
    handles.b.pre.ori.norm_def=[path1,filesep,'Original',filesep,'y_',nam,ext];
    copyfile(handles.b.pre.normalization.extracted_anatomical_image,handles.b.pre.ori.extracted_anatomical_image );
    copyfile(handles.b.pre.normalization.gm_anatomical_image,handles.b.pre.ori.gm_anatomical_image );
    copyfile(handles.b.pre.normalization.wm_anatomical_image,handles.b.pre.ori.wm_anatomical_image );
    copyfile( handles.b.pre.normalization.norm_def, handles.b.pre.ori.norm_def);
    waitbar(9/10)
    handles.b.pre.ana_hdr= spm_vol([path1,filesep,'m',nam,ext]);
    handles.b.pre.ana_c1_hdr=  spm_vol([path1,filesep,'c1',nam,ext]);
    handles.b.pre.ana_c2_hdr=  spm_vol([path1,filesep,'c2',nam,ext]);
    handles.b.pre.ana_c3_hdr=  spm_vol([path1,filesep,'c3',nam,ext]);
    handles.b.pre.ana_ext_hdr=  spm_vol([path1,filesep,'e_',nam,ext]);
    handles.b.pre.ana_hdr_img=spm_read_vols(handles.b.pre.ana_hdr);
    handles.b.pre.ana_ext_hdr_img=spm_read_vols(handles.b.pre.ana_ext_hdr);
    handles.b.pre.ana_c1_hdr_img=spm_read_vols(handles.b.pre.ana_c1_hdr);
    handles.b.pre.ana_c2_hdr_img=spm_read_vols(handles.b.pre.ana_c2_hdr);
    handles.b.pre.norm_def=[path1,filesep,'y_',nam,ext];
    close(h)
    screen_res = get(0,'screensize');
    anatomy_vis =figure('MenuBar','none','NumberTitle', 'off','Color',[0 0 0 ],'resize','off','Name','Anatomy visualization', 'Position', [round( screen_res(3)*0.13),round( screen_res(4)*0.05),800, 400]);
    ax=axes;
    set(ax,'position',[0 0 1 0.9]);
    uicontrol('Style','text',...
        'Position',[0 375  800 25],...
        'FontSize',12,   'Parent',anatomy_vis,'ForegroundColor',[1 1 1],'BackgroundColor',[0 0 0],...
        'String','                     Original                               Extracted                                 Gray matter                            White matter              ');
    
    
    set(ax,'xticklabel',[]);set(ax,'yticklabel',[]);
    set(ax,'XTick',[]);set(ax,'YTick',[]);
    for ii=1:size(handles.b.pre.ana_hdr_img,3)
        image=[rot90(double(handles.b.pre.ana_hdr_img(:,:,ii))./max(max(double(handles.b.pre.ana_hdr_img(:,:,ii))))),rot90(double(handles.b.pre.ana_ext_hdr_img(:,:,ii))./max(max(double(handles.b.pre.ana_ext_hdr_img(:,:,ii))))),rot90(double(handles.b.pre.ana_c1_hdr_img(:,:,ii))./max(max(double(handles.b.pre.ana_c1_hdr_img(:,:,ii))))),rot90(double(handles.b.pre.ana_c2_hdr_img(:,:,ii))./max(max(double(handles.b.pre.ana_c1_hdr_img(:,:,ii)))))];
        figure(anatomy_vis)
        imshow( image ,[0 1])
        pause(0.01)
    end
    close(anatomy_vis)
    handles.b.iserror=0;
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end
