function handles=norm_parameters(handles)
try
    h = waitbar(0,'Please wait...');
    
    if handles.b.conf.session>1 || ( handles.b.conf.session==1 && handles.b.Feedback.dummy_idx>1)
        VG1=spm_vol(handles.b.pre.normalization.initial_functional_image);
        VF1=spm_vol(handles.b.pre.normalization.spm_mean_img);
        x1 = spm_coreg(VG1,VF1,handles.b.pre.coreg_flag);
        handles.b.pre.normalization.current_M  = spm_matrix(x1);
        MM1= spm_get_space(handles.b.pre.normalization.spm_mean_img);
        spm_get_space(handles.b.pre.normalization.spm_mean_img, handles.b.pre.normalization.current_M\MM1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Coregistering mean images...';
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        handles.b.pre.normalization.ref_file_vol_data=spm_vol(handles.b.pre.normalization.spm_mean_img);
    else
        handles.b.pre.normalization.ref_file_vol_data=spm_vol(handles.b.pre.normalization.spm_mean_img);
    end
   % if handles.b.conf.session==1
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Coregistering mean image with the structural image ...';
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        
        VG = spm_vol(handles.b.pre.normalization.spm_mean_img);
        if isfield(handles.b.pre.normalization,'extracted_anatomical_image')
            VF=spm_vol(handles.b.pre.normalization.extracted_anatomical_image);
        else
            VF= handles.b.pre.normalization.extract_brain;
        end
        %VF=VF1{1};
        clear VF1
        PO = [handles.b.pre.normalization.extracted_anatomical_image;handles.b.pre.normalization.gm_anatomical_image;handles.b.pre.normalization.wm_anatomical_image];
        PO1={handles.b.pre.normalization.spm_mean_img;handles.b.pre.normalization.extracted_anatomical_image;handles.b.pre.normalization.gm_anatomical_image;handles.b.pre.normalization.wm_anatomical_image};
        spm('defaults','fMRI')
        waitbar(1/5);
        x  = spm_coreg(VG,VF,handles.b.pre.coreg_flag);
      
        M  = spm_matrix(x);  
            MM = zeros(4,4,numel(PO));
            for j=1:size(PO,1)
                MM(:,:,j) = spm_get_space(PO(j,:));
            end
            for j=1:size(PO,1)
                spm_get_space(PO(j,:), M\MM(:,:,j));
            end
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Coregisteration done..';
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
            flags=handles.b.pre.realign_rs_opt;
            flags.mean=0;
            flags.prefix='';
            sic_reslice( PO1 ,flags );
        % [out(1).sn{1},out(1).isn{1}]   = spm_prep2sn(res);
        %  [pth,nam]     = fileparts( handles.b.pre.anatomical_image);
        % out(1).snfile{1} = fullfile(pth,[nam '_seg_sn.mat']);
        %  handles.b.pre.norm_para_sn=out(1).snfile{1};
        %  savefields(out(1).snfile{1},out(1).sn{1});
        %  out(1).isnfile{1} = fullfile(pth,[nam '_seg_inv_sn.mat']);
        %     handles.b.pre.norm_para_inv=out(1).isnfile{1};
        %     savefields(out(1).isnfile{1},out(1).isn{1});
        %     spm_preproc_write(cat(2,out.sn{:}),handles.b.pre.output);
        % handles.b.pre.norm_para=load(handles.b.pre.norm_para_sn);
        waitbar(2/5);
        handles.b.pre.normalization.norm_defs.coreg_matrix=M;
        handles.b.pre.normalization.norm_defs.comp{1}.def =  handles.b.pre.normalization.norm_def;
        handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.vox =  [3,3, 3];
        handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.bb  =[ -78  -112   -70;    78    76    85];
        [pth,nn,et]=fileparts(handles.b.pre.normalization.gm_anatomical_image);[pth1,nn1,et1]=fileparts(handles.b.pre.normalization.wm_anatomical_image);
        handles.b.pre.normalization.norm_defs.out{1}.pull.fnames  ={[pth,filesep,nn,et];[pth1,filesep,nn1,et1]};
        
        handles.b.pre.normalization.norm_defs.out{1}.pull.savedir.savesrc = 1;
        handles.b.pre.normalization.norm_defs.out{1}.pull.interp  = 7;
        handles.b.pre.normalization.norm_defs.out{1}.pull.mask    = 1;
        handles.b.pre.normalization.norm_defs.out{1}.pull.fwhm    = [0 0 0];
        handles.b.pre.normalization.norm_defs.out{1}.pull.prefix  = 'w';
        Nii = nifti(handles.b.pre.normalization.norm_defs.comp{1}.def);
        vx  = sqrt(sum(Nii.mat(1:3,1:3).^2));
        o   = Nii.mat\[0 0 0 1]';
        o   = o(1:3)';
        dm  = size(Nii.dat);
        bb  = [-vx.*(o-1) ; vx.*(dm(1:3)-o)];
        II=spm_vol(handles.b.pre.normalization.norm_defs.comp{1}.def);
        handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.vox(~isfinite(handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.vox)) = vx(~isfinite(handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.vox));
        handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.bb(~isfinite(handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.bb)) = bb(~isfinite(handles.b.pre.normalization.norm_defs.comp{2}.idbbvox.bb));
        [handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat] = get_comp(handles.b.pre.normalization.norm_defs);
        handles.b.pre.normalization.norm_mat=II.mat;
        [handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk]= pull_def(handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull);
        % Guess filenames
        % sopts = [handles.b.pre.output.GM;handles.b.pre.output.WM;handles.b.pre.output.CSF];
        %
        % [VO,dat]=sic_write_sn([handles.b.pre.grey_matter_file],handles.b.pre.norm_para,handles.b.pre.norm_flag);
        % VO = spm_create_vol(VO);
        % VO = spm_write_plane(VO,dat,':');
        % [VO2,dat2]=sic_write_sn(handles.b.pre.white_matter_file,handles.b.pre.norm_para,handles.b.pre.norm_flag);
        % VO2= spm_create_vol(VO2);
        % VO2 = spm_write_plane(VO2,dat2,':');
        % [VO1,dat1]=sic_write_sn(handles.b.pre.spm_mean_img,handles.b.pre.norm_para,handles.b.pre.norm_flag);
        % VO1 = spm_create_vol(VO1);
        % handles.b.pre.mean_VOI = spm_write_plane(VO1,dat1,':');
        waitbar(3/5);
        
        [out,dat,NO] =write_file([handles.b.pre.normalization.norm_defs.out{1}.pull.fnames{1},',',num2str(1)],handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
        NO.dat(:,:,:,1,1,1) = dat;
        clear dat NO
        [out,dat,NO] =write_file([handles.b.pre.normalization.norm_defs.out{1}.pull.fnames{2},',',num2str(1)],handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
        NO.dat(:,:,:,1,1,1) = dat;
        clear dat NO
        [p,f,ext]=fileparts(handles.b.pre.normalization.spm_mean_img);
        [out,dat,NO] =write_file([p,filesep,f,ext ,',',num2str(1)],handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
        NO.dat(:,:,:,1,1,1) = dat;
        handles.b.localizer.P=[p,filesep,'w',f,ext];
        clear dat NO 
        [p,f,ext]=fileparts(handles.b.pre.normalization.extracted_anatomical_image);
        [out,dat,NO] =write_file([p,filesep,f,ext ,',',num2str(1)],handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
        NO.dat(:,:,:,1,1,1) = dat;
        clear dat NO
       % try
            img_f1=spm_vol(fullfile(p ,['w',f,ext ]));
            img_f = spm_read_vols(img_f1);
            img =  spm_read_vols(spm_vol([ pth,filesep,'w',nn,et]));
            img1 =  spm_read_vols(spm_vol([ pth1,filesep,'w',nn1,et1]));
%         catch
%             img_f = load_untouch_nii(fullfile(p ,['w',f,ext ]));
%             img =  load_untouch_nii([ pth,filesep,'w',nn,et]);
%             img1 =  load_untouch_nii([ pth1,filesep,'w',nn1,et1]);
       % end
        clear pth nn et pth1 nn1 et1;
        % screen_res = get(0,'screensize');
        % anatomy_vis_mask =figure('MenuBar','none','NumberTitle', 'off','Color',[0.5 0.5 0.5],'resize','off','Name','Anatomy visualization', 'Position', [round( screen_res(3)*0.63),round( screen_res(4)*0.05),600, 400]);
        % ax=subplot(1,3,1);
        % set(ax,'xticklabel',[]);set(ax,'yticklabel',[]);
        % set(ax,'XTick',[]);set(ax,'YTick',[]);
        % ax2=subplot(1,3,2);
        % set(ax2,'xticklabel',[]);set(ax2,'yticklabel',[]);
        % set(ax2,'XTick',[]);set(ax2,'YTick',[]);
        %
        % ax3=subplot(1,3,3);
        % set(ax3,'xticklabel',[]);set(ax3,'yticklabel',[]);
        % set(ax3,'XTick',[]);set(ax3,'YTick',[]);
        % for ii=1:size(img.img,3)
        %     axis(ax)
        %     imshow(rot90(img.img(:,:,ii)),[0 1]);
        %      axis(ax2)
        %     imshow(rot90(img1.img(:,:,ii)),[0 1]);
        %      axis(ax3)
        %     imshow(rot90(img_f.img(:,:,ii)),[0 1500]);
        %     pause(0.1)
        % end
        % close(anatomy_vis_mask)
        waitbar(4/5);
        i11=0;
        img_f(isnan(img_f)) = 0 ;
        img_f( (img_f<0)) = 0 ;
        for in=1:size(img_f,3)
            nn=find(img_f(:,:,in)>100);
            % figure, imshow(img_f.img(:,:,in),[1 ,1000])
            if ( size(nn,1)/(size(img_f,2)*size(img_f,1)))>0.05
                i11=i11+1;
                handles.b.pre.func_planes(i11)=in;
            end
        end
        vox_grey=(img(:)>0.2); vox_white=(img1(:)>0.2);
        tot_vox=vox_grey+vox_white;
        handles.b.pre.normalization.mean_VOI.mat=img_f1.mat;
        handles.b.pre.normalization.mean_VOI.dim=img_f1.dim;
        handles.b.pre.normalization.start_voxel=(handles.b.pre.func_planes(1)-1)*size(img_f,2)*size(img_f,1)+1;
        handles.b.pre.normalization.end_voxel=handles.b.pre.func_planes(end)*size(img_f,2)*size(img_f,1);
        handles.b.pre.normalization.global_voxels =zeros((size(img_f,1)*size(img_f,2)*size(img_f,3)),1) ;
        handles.b.pre.normalization.global_voxels(handles.b.pre.normalization.start_voxel:handles.b.pre.normalization.end_voxel)=(tot_vox(handles.b.pre.normalization.start_voxel:handles.b.pre.normalization.end_voxel)>0);
        handles.b.pre.normalization.hdr.dim_init=handles.b.pre.hdr.dim;
        handles.b.pre.normalization.hdr.dim=img_f1.dim;
        %PG = deblank(fullfile(p,'templates','T1.nii'));
        % VG = spm_vol(PG);
        % VF = spm_vol(structural_image);
        % spm_segment(VF,VG,seg_flag);
        if handles.b.conf.session==1
            normalization=handles.b.pre.normalization;
            save(handles.b.pre.ori.norm_mat_file,'normalization');
            clear normalization;
        end
   % end
    close(h)
    
    handles.b.iserror=0;
    
    % str=which('spm_segment.m');
    % [p,a,e]=fileparts(str);
    % template = deblank(fullfile(p,'apriori','grey.nii'));
    % [pth,nm,xt] = fileparts(deblank(structural_image));
    % source = fullfile(pth,['m' nm xt]);
    % matname= fullfile(pth,[nm '_seg1_sn' '.mat']);
    %
    % spm_normalise(template, source, matname,'','',norm_flag);
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end
