function handles = bci_view( handles)
%BCI_VIEW Display one data window of fMRI ROI data output of TBV/ extract
%BOLD values from masks.

% volumes gives the number of volumes read with this protocol.
% Structure images consists of the fields.
% based on the previous bci_data() function
% // SWB just a hack - switch off text display of insturction/protocol
%______________________________________________________________________
%initialization/configuratio
%iin=0;
try
    %%%%%%%% realignment
    skip = sqrt(sum(handles.b.pre.normalization.ref_file_vol_data.mat(1:3,1:3).^2)).^(-1)*handles.b.pre.realign_opt.sep;
    d    = handles.b.pre.normalization.ref_file_vol_data.dim(1:3);
    handles.b.pre.normalization.lkp = handles.b.pre.realign_opt.lkp;
    rand('state',0); % want the results to be consistant.
    if d(3) < 3,
        handles.b.pre.normalization.lkp = [1 2 6];
        [x1,x2,x3] = ndgrid(1:skip(1):d(1)-.5, 1:skip(2):d(2)-.5, 1:skip(3):d(3));
        x1   = x1 + rand(size(x1))*0.5;
        x2   = x2 + rand(size(x2))*0.5;
    else
        [x1,x2,x3]=ndgrid(1:skip(1):d(1)-.5, 1:skip(2):d(2)-.5, 1:skip(3):d(3)-.5);
        x1   = x1 + rand(size(x1))*0.5;
        x2   = x2 + rand(size(x2))*0.5;
        x3   = x3 + rand(size(x3))*0.5;
    end;
    
    handles.b.pre.normalization.x1   = x1(:);
    handles.b.pre.normalization.x2   = x2(:);
    handles.b.pre.normalization.x3   = x3(:);
    clear x1 x2 x3
    % Possibly mask an area of the sample volume.
    %-----------------------------------------------------------------------
    
    handles.b.pre.normalization.wt = [];
    
    % Compute rate of change of chi2 w.r.t changes in parameters (matrix A)
    %-----------------------------------------------------------------------
    V   = smooth_vol(handles.b.pre.normalization.ref_file_vol_data,handles.b.pre.realign_opt.interp,handles.b.pre.realign_opt.wrap,handles.b.pre.realign_opt.fwhm);
    handles.b.pre.normalization.deg = [handles.b.pre.realign_opt.interp*[1 1 1]' handles.b.pre.realign_opt.wrap(:)];
    
    [G,dG1,dG2,dG3] = spm_bsplins(V,handles.b.pre.normalization.x1,handles.b.pre.normalization.x2,handles.b.pre.normalization.x3,handles.b.pre.normalization.deg);
    clear V
    handles.b.pre.normalization.A0 = make_A(handles.b.pre.normalization.ref_file_vol_data.mat,handles.b.pre.normalization.x1,handles.b.pre.normalization.x2,handles.b.pre.normalization.x3,dG1,dG2,dG3,handles.b.pre.normalization.wt,handles.b.pre.normalization.lkp);
    
    handles.b.pre.normalization.b  = G;
    if ~isempty(handles.b.pre.normalization.wt), handles.b.pre.normalization.b = handles.b.pre.normalization.b.*handles.b.pre.normalization.wt; end;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.b.Feedback.base_diff=[];
    handles.b.flag.feed_go=0;money=0;
    handles.b.Feedback.money(1:handles.b.proto.seq_length)=0;  handles.b.Feedback.money_cont(1: handles.b.proto.seqview.block{handles.b.proto.seq_length}(2))=0;
%     handles.b.shaping.index=0;
    % handles.b.ui.thresh_feed=0;
    handles.b.Feedback.total_money=0;
    handles.b.Feedback.not_vol_incl=0;
    handles.b.figures.displayingImage=0; %this value is set inside bci_display_image
    handles.b.figures.preImageFile = 0; handles.b.figures.preImageHandle = 0; %initialize
    set(handles.bcigui,'visible','on');
    set(handles.b.figures.image_vis_fig,'visible','on');
    set(handles.b.figures.fHand_plot_data,'visible','on');set(handles.b.figures.feedback_fig,'visible','on');
    uiwait(msgbox('Please arrange the feddback window as needed. Please press OK to proceed for beginning BCI feedback task'));
    
    if(strcmp(handles.b.ui.feedbacktype, 'SEAWORLD'))  && (handles.b.ui.image == 0)
        draw_seaworld(handles.b.isTransfer);
        %close(handles.b.figures.feedback_fig);
    elseif handles.b.flag.iscon_del_feedback && handles.b.ui.image>0
        
        handles= bci_image_display(handles, 'first' );
        %     handles=bci_init_thermo_image(handles);
        handles = draw_thermo(handles);
        update_thermo(handles.b.figures.feedback_fig , handles.b.ui, 0, [1 0 0],handles);  %update background color to indicate type of condition
        if handles.b.proto.cond_images
            display_condimage(handles.b.proto.cond(handles.b.proto.seqview.cond(1)).cond_images.data,handles)
        end
    elseif handles.b.flag.isDelayed
        set(handles.b.figures.feedback_fig,'visible','on');
        handles= bci_image_display(handles, 'first' );
        if handles.b.proto.cond_images
            display_condimage(handles.b.proto.cond(handles.b.proto.seqview.cond(1)).cond_images.data,handles)
        end
    elseif(strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
        set(handles.b.figures.feedback_fig,'visible','on');
        handles = draw_thermo(handles);
        update_thermo(handles.b.figures.feedback_fig , handles.b.ui, 0, [1 0 0],handles);  %update background color to indicate type of condition
        
        if handles.b.proto.cond_images
            display_condimage(handles.b.proto.cond(handles.b.proto.seqview.cond(1)).cond_images.data,handles)
        end
    end
    %ask the user to get ready
    % set(handles.bcigui,'visible','off');
    set(handles.b.figures.figure_session_log,'position',[10, round(handles.b.pre.screen_res(4)*0.33),round(handles.b.pre.screen_res(3)*0.3),round(handles.b.pre.screen_res(4)*0.3)]);
    set(handles.session_log,'position',[1  1,round(handles.b.pre.screen_res(3)*0.3),round(handles.b.pre.screen_res(4)*0.3)]);
    if handles.b.flag.multi_base
        base_TR=zeros(1,length(handles.b.pre.base_cat));
    end
    
    if handles.b.flag.TBV
        %open .ert file and wait for data
        bci_ui_wait( handles.b.roi.file,handles );        % wait until regular file is there
        fid = fopen( handles.b.roi.file, 'rt');   % text mode (matlab does the '\r\n' stuff)
        file_position = -1; %initialize
    else
        if  strcmp(handles.b.pre.MR_scanner,'Siemens')
            fname_input_next_first=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,1) '.dcm'];
        elseif strcmp(handles.b.pre.MR_scanner,'Philips')
            fname_input_next_first=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,1) '.img'];
        end
        if  handles.b.flag.istesting
            [filename, path_file]=uigetfile('*.mat','Please select the file with Synthetic data ');
            if  ~ischar(filename)||~ischar(path_file)
                file_path=[num2str(filename),num2str(path_file)];
            else
                file_path=[path_file,filename];
            end
            if exist(file_path,'file')~=2
                 pre = '<HTML><FONT color="';
                 post = '</FONT></HTML>';
                 figure(handles.b.figures.figure_session_log);
                 handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= [pre ,rgb2Hex( [235 53 53] ), '">' ,'Error at line ','112',' in ', 'Wrong file selected' , post];
                 set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
                 handles.b.iserror=1;
                 return
            else
                test_data=load(file_path);
            end
            pause(handles.b.roi.volumes_skip*handles.b.roi.TR);
        else
            bci_ui_wait(fname_input_next_first,handles);
        end
        
        %img=load_nii(fname_input_next_first);
        %         if size( handles.b.pre.func_planes,2)>(handles.b.pre.row*handles.b.pre.column)
        %             x = inputdlg(['Enter the rows and columns for visualization (Total planes:' , num2str(size(handles.b.pre.func_planes,2)),'):'],...
        %                 'Example : 4 5' );
        %             data = str2num(x{1});
        %             handles.b.pre.row=data(1); handles.b.pre.column=data(2);
        %         end
        %         handles=initiate_figure_vis(handles);
        %         handles=plot_data_initiate(handles);
        if  strcmp(handles.b.pre.MR_scanner,'Siemens')
            fname_input_next=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,handles.b.roi.volumes_skip+1) '.dcm'];
        elseif strcmp(handles.b.pre.MR_scanner,'Philips')
            fname_input_next=[handles.b.conf.watch_dir, filesep, sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,handles.b.roi.volumes_skip+1) '.img'];
        end
        if  ~handles.b.flag.istesting
            bci_ui_wait(fname_input_next,handles);
        end
    end
    
    %for each condition in the protocol
    for current_cond = 1:handles.b.proto.seq_length
        handles.b.Feedback.current_block = handles.b.proto.seqview.block{current_cond};
        handles.b.Feedback.current_cond=current_cond;
        handles.b.ui.backcolor= handles.b.proto.seqview.color{current_cond};
        % feed=handles.b.perf.criteria(current_cond);
        % num_cond=max(handles.b.proto.seqview.cond);
        % current_image = handles.b.proto.seqview.cond_image{current_cond};
        if (strcmp(handles.b.ui.feedbacktype, 'SEAWORLD'))
            step=0;
        end
        %for each time point within the current block, get the effective ROI
        if ( handles.b.perf.criteria(current_cond)==1 ||  handles.b.perf.criteria(current_cond)==2) && handles.b.ui.inter_TR~=0
            handles.Feedback.feedback_TR=handles.b.Feedback.current_block(1)-1+handles.b.ui.inter_TR:handles.b.ui.inter_TR:handles.b.Feedback.current_block(2);
            handles.b.Feedback.not_vol_incl= handles.Feedback.feedback_TR;
            handles.b.Feedback.TR_4_current_feedback=[];
            iin=0;
        end
        handles.b.Feedback.blockData = zeros(handles.b.Feedback.current_block(2)-handles.b.Feedback.current_block(1)+1, 1); %initilize first to zeros
        volume_index = 0;
        
        for volume = handles.b.Feedback.current_block(1) :handles.b.Feedback.current_block(2)
            tic
            if handles.b.flag.isstimulate
                tt=cputime;
            end
            %condition beginning or not for the seaworld
            if(volume == handles.b.Feedback.current_block(1))
                handles.b.flag.is_new_start = 'YES';
            else
                handles.b.flag.is_new_start = 'NO';
            end
            handles.b.Feedback.current_volume=volume;
            if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                handles.b.Feedback.grads_cont(volume)=0;
            end
            volume_index = volume_index + 1;
            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('\nTimepoint: %d\n', volume);
            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
            %Display the stimulus image
            if strcmp(handles.b.flag.is_new_start,'YES')
                if  handles.b.ui.image ~= 0
                    handles=bci_image_display(handles,'No' );
                    if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                        update_thermo(handles.b.figures.feedback_fig , handles.b.ui, 0, [1 0 0],handles);  %update background color to indicate type of condition
                        
                    end
                elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&& ~(handles.b.perf.criteria(current_cond)==2)
                    if handles.b.flag.iscon_del_feedback
                        handles=bci_image_display(handles,'update_back' );
                    end
                    update_thermo(handles.b.figures.feedback_fig , handles.b.ui, 0, [1 0 0],handles);  %update background color to indicate type of condition
                end
                
                if ( handles.b.ui.SHOW_REWARD && handles.b.flag.isContinuous)
                    set(  handles.b.figures.high_limit, 'visible','on');
                    set( handles.b.figures.low_limit, 'visible','on');
                    set(  handles.b.figures.cum_feed, 'visible','on');
                end
            end
            
            if ~handles.b.flag.TBV %if we are not using TBV
                if  ~handles.b.flag.istesting
                    if  strcmp(handles.b.pre.MR_scanner,'Siemens')
                        fname_file=[sprintf(handles.b.pre.input_filename,handles.b.conf.run_num,volume+handles.b.roi.volumes_skip) '.dcm'];
                        handles.b.current_volume.fname_input_next=[handles.b.conf.watch_dir, filesep, fname_file];
                        bci_ui_wait(handles.b.current_volume.fname_input_next);
                        handles.b.current_volume.hdr= spm_dicom_headers(handles.b.current_volume.fname_input_next);
                        handles=spm_dicom_convert(handles);
                        tt(1,volume)=toc;
                    elseif strcmp(handles.b.pre.MR_scanner,'Philips')
                        fname_file=[sprintf(handles.b.pre.input_filename,handles.b.conf.sub_name,volume+handles.b.roi.volumes_skip) '.img'];
                        functional_image{volume}=[handles.b.conf.Feed_path, filesep, fname_file];
                        bci_ui_wait(functional_image{volume} );
                        handles.b.current_volume.V= spm_vol(functional_image{volume});
                    end
                    if handles.b.flag.isrealignment_ref_run && volume== handles.b.roi.volumes_skip+1
                        handles.b.pre.normalization.ref_file_vol_data_run=handles.b.current_volume.V;
                    end
                    % PL{1}=[ handles.b.pre.ref_file; functional_image{volume}];
                    if volume==1
                        aa=  spm_imatrix(handles.b.current_volume.V.mat/handles.b.pre.normalization.ref_file_vol_data.mat);
                        aa=(round(aa*100))/100;
                        set( handles.b.figures.Feedback_TextBox,'string',['X:   ',num2str(aa(1)),'   ','Y:   ',num2str(aa(2)),'   ','Z:   ',num2str(aa(3)),'   ','Pitch:   ',num2str(aa(4)),'   ','Roll:   ',num2str(aa(5)),'   ','Yaw:   ',num2str(aa(6)),'   ']);
                    end
                    if handles.b.conf.session>1
                        %                     %%%%%%%%% co-regester image to sesssion 1 mean image
                        handles.b.current_volume.V.mat= (handles.b.pre.normalization.current_M\handles.b.current_volume.V.mat);
                        handles.b.current_volume.V.private.mat=handles.b.current_volume.V.mat;
                        handles.b.current_volume.V.private.mat0=handles.b.current_volume.V.mat;
                        %handles.b.current_volume.V.mat0= (handles.b.pre.normalization.current_M\handles.b.current_volume.V.mat);
                    end
                    
                    handles=sic_realign2(handles);
                    
                    %%%%%%%%% co-regester image to anatomy
                    handles.b.current_volume.V.mat= (handles.b.pre.normalization.norm_defs.coreg_matrix\handles.b.current_volume.V.mat);
                    handles.b.current_volume.V.mat0= (handles.b.pre.normalization.norm_defs.coreg_matrix\handles.b.current_volume.V.mat);
                    tt(2,volume)=toc;
                    
                    if (handles.b.flag.isnormalization) || ~handles.b.flag.isClassification
                        if volume>1
                            handles.b.Feedback.current_para_tot_ori(volume,:)=handles.b.current_volume.para;
                            handles.b.Feedback.current_para_tot(volume,:)= handles.b.Feedback.current_para_tot_ori(volume,:)- handles.b.Feedback.current_para_tot_ori(1,:);
                            handles.b.Feedback.para_mean=nanmean(handles.b.Feedback.current_para_tot); handles.b.Feedback.para_std=std(handles.b.Feedback.current_para_tot);
                        else
                            handles.b.Feedback.current_para_tot_ori(volume,:)=handles.b.current_volume.para;
                            handles.b.Feedback.current_para_tot(volume,:)=zeros(1,size(handles.b.Feedback.current_para_tot_ori,2));
                            handles.b.Feedback.para_mean= handles.b.Feedback.current_para_tot(volume,:);handles.b.Feedback.para_std=0;
                        end
                        
                        [out,handles.b.current_volume.volume_norm,NO] =write_file(handles.b.current_volume.V,handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
                        tt(3,volume)=toc;
                        
                        %[handles.b.current_volume.V_norm,handles.b.current_volume.volume_norm]= sic_write_sn(handles.b.Feedback.realign(2),handles.b.pre.norm_para,handles.b.pre.norm_flag);
                        %                 [pp,nn,ext]=fileparts(functional_image{volume});functional_image{volume}
                        %                 normalized_file=[handles.b.conf.feed_path,filesep,'w',nn,ext];
                        %                 bci_ui_wait( normalized_file );
                        %                 try
                        %                     handles.b.Feedback.current_hdr= load_nii(normalized_file);
                        %                 catch
                        %                     handles.b.Feedback.current_hdr=load_untouched_nii(normalized_file);
                        %                 end
                        handles.b.current_volume.volume_norm(isnan(handles.b.current_volume.volume_norm)) = 0 ;
                        img=handles.b.current_volume.volume_norm(:);
                    elseif (handles.b.flag.isrealignment) || ~handles.b.flag.isClassification
                        img=handles.b.Feedback.realign(2).private.dat(:);
                    end
                    
                    if ~handles.b.flag.isClassification
                        handles.b.proto.seqview.ori_data(volume,:)= (sum(double(repmat(img,[1,length(handles.b.roi.count)+1])).*double([handles.b.roi.mask_vox_ss,handles.b.pre.normalization.global_voxels ])))./sum(double([handles.b.roi.mask_vox_ss,handles.b.pre.normalization.global_voxels ]));
                        if volume>8
                            per_an= ((handles.b.proto.seqview.ori_data(volume,:)- handles.b.proto.seqview.ori_data_base)./handles.b.proto.seqview.ori_data_base)*100;
                            handles.b.proto.seqview.per_global(volume,1)=per_an(1,end);
                            handles.b.proto.seqview.per_ROI(volume,:)=per_an(1,1:end-1);
                            %%%%%% motion correction based on regulation
                            if  sum(abs(handles.b.Feedback.current_para_tot(volume,:))> (handles.b.Feedback.para_mean+ handles.b.pre.threshold_motion*handles.b.Feedback.para_std))>0
                                handles.b.proto.seqview.data(volume,:) = handles.b.proto.seqview.ori_data(volume-1,:);
                            else
                                handles.b.proto.seqview.data(volume,:) = handles.b.proto.seqview.ori_data(volume,:);
                            end
                        elseif volume>1
                            per_an= ((handles.b.proto.seqview.ori_data(volume,:)- mean(handles.b.proto.seqview.ori_data(1:volume,:)))./mean(handles.b.proto.seqview.ori_data(1:volume,:)))*100;
                            handles.b.proto.seqview.per_global(volume,1)=per_an(1,end);
                            handles.b.proto.seqview.per_ROI(volume,:)=per_an(1,1:end-1);
                            handles.b.proto.seqview.data(volume,:) = handles.b.proto.seqview.ori_data(volume,:);
                            if volume==8
                                handles.b.proto.seqview.ori_data_base= mean(handles.b.proto.seqview.ori_data(1:volume,:));
                            end
                        else
                            handles.b.proto.seqview.data = handles.b.proto.seqview.ori_data(volume,:);
                            handles.b.proto.seqview.per_global(volume)=0;
                            handles.b.proto.seqview.per_ROI(volume,:)=zeros(1,length(handles.b.roi.count));
                            handles.b.Feedback.para_mean=1;
                            handles.b.Feedback.para_std=2;
                        end
                        %                     if handles.b.flag.isShaping &&  ~handles.b.perf.criteria(current_cond)==0
                        %
                        %                         if  handles.b.ui.inter_TR>0
                        %                             if sum(volume ~=handles.b.Feedback.not_vol_incl)==0 || handles.b.perf.criteria(current_cond)==9
                        %                                 handles.b.shaping.index=handles.b.shaping.index +1;
                        %                                 handles.b.shaping.volume_index(handles.b.shaping.index)=volume;
                        %                             end
                        %                         else
                        %                             handles.b.shaping.index=handles.b.shaping.index +1;
                        %                             handles.b.shaping.volume_index(handles.b.shaping.index)=volume;
                        %                         end
                        %                     end
                    else %%% classification code
                    end
                else %%% is testing code
                     handles.b.proto.seqview.per_global(volume)=0;
                     handles.b.proto.seqview.data(volume,:)=test_data.data(:,volume)';
                     handles.b.proto.seqview.per_ROI(volume,length(handles.b.roi.count))=0;
                     handles.b.Feedback.current_para_tot(volume,:)=zeros(6,1);
                    % pause(handles.b.roi.TR-0.2);
                end
                
            else %execute when ROI data is read from _plots.ert file
                if(file_position ~= -1)
                    status = fseek(fid, file_position, 'bof');
                end
                [handles.b.proto.seqview.data(volume,:), file_position,handles.b.proto] = bci_readplot(fid, volume, handles.b.roi, handles.b.proto,handles);
            end
            if handles.b.flag.isClassification
                if handles.b.flag.Classification.istraining_data
                    handles.b.pre.training_data(:,volume)=img;
                    handles.b.pre.training_label(1,volume)= handles.b.proto.seqview.cond (current_cond);
                    if handles.b.flag.Classification.iscreate_model
                        
                    end
                else
                end
                
                
                
                
                
            else
                if(volume>=handles.b.pre.correl_window)&& ( handles.b.flag.isposcorrelation||handles.b.flag.isnegcorrelation)   %if there is enough data, compute correlation coefficient
                    correl_matrix=corrcoef(handles.b.proto.seqview.data(volume-(handles.b.pre.correl_window-1):volume,handles.b.roi.correl_rois(1)),handles.b.proto.seqview.data(volume-(handles.b.pre.correl_window-1):volume,handles.b.roi.correl_rois(2)));
                    handles.b.Feedback.correl_per_volume(volume)=correl_matrix(1,2);
                    %  plot(handles.b.figures.aHand,handles.b.Feedback.correl_per_volume,'color',[1,0,0],'LineWidth',3);
                    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('\nCorrelation Coefficient %3.1f\n', correl_matrix(1,2));
                    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                end
                
                if  (current_cond+1)<=length(handles.b.perf.criteria)
                    if ( handles.b.flag.isposcorrelation||handles.b.flag.isnegcorrelation) && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback)&& volume==handles.b.Feedback.current_block(2) && handles.b.perf.criteria(current_cond+1)==2
                        
                        correl_matrix=corrcoef(handles.b.proto.seqview.data(handles.b.Feedback.current_block(1): handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(1)),handles.b.proto.seqview.data( handles.b.Feedback.current_block(1): handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(2)));
                        handles.b.Feedback.correl_delayed=correl_matrix(1,2);
                        %correl=rand; %for debug
                        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('\n Delayed Correlation Coefficient %3.1f\n', handles.b.Feedback.correl_delayed(current_cond));
                        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                    end
                end
                if  (current_cond+2)<=length(handles.b.perf.criteria)
                    if  handles.b.flag.iscoefcorr && handles.b.flag.isDelayed && volume==handles.b.Feedback.current_block(2) &&  handles.b.perf.criteria(current_cond+2)==2
                        correl_matrix=corrcoef(handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):  handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(1)),handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):  handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(1)));
                        handles.b.Feedback.basline_corr_coef=correl_matrix(1,2);
                    elseif handles.b.flag.iscoefcorr && handles.b.flag.isDelayed && volume==handles.b.Feedback.current_block(2) && handles.b.perf.criteria(current_cond+1)==2
                        correl_matrix=corrcoef(handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):  handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(1)),handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):  handles.b.Feedback.current_block(2),handles.b.roi.correl_rois(1)));
                        handles.b.Feedback.regulation_corr_coef=correl_matrix(1,2);
                    end
                    
                end
                %if it is the last volume of the baseline block compute the
                %mean baseline_roi
                if handles.b.flag.multi_base
                    if  handles.b.perf.criteria(current_cond)==9
                        for iin1=1: size(handles.b.pre.base_cat,2)
                            ss=strfind(handles.b.proto.seqview.image_name{handles.b.Feedback.current_cond}{1},filesep);
                            aa=strfind( handles.b.proto.seqview.image_name{handles.b.Feedback.current_cond}{1}(ss(end)+1:end),handles.b.pre.base_cat{1,iin1});
                            if iscell(aa)
                                if ~isempty(aa{1})
                                    base_TR(iin1)=base_TR(iin1)+1;
                                    handles.b.Feedback.base_diff(base_TR(iin1),:,iin1)=handles.b.proto.seqview.data(volume,1:end-1);
                                    break
                                end
                            else
                                if ~isempty(aa)
                                    base_TR(iin1)=base_TR(iin1)+1;
                                    handles.b.Feedback.base_diff(base_TR(iin1),:,iin1)=handles.b.proto.seqview.data(volume,1:end-1);
                                    break
                                end
                            end
                        end
                    end
                    clear aa
                    if length(handles.b.perf.criteria)>current_cond+1
                        if handles.b.perf.criteria(current_cond+1)==1 || handles.b.perf.criteria(current_cond+1)==2
                            aa=nanmean(handles.b.Feedback.base_diff,1);
                            handles.b.Feedback.base_diff_mean= reshape(aa,[size(aa,2),size(aa, 3), 1]);
                            clear aa;
                            aa=std(handles.b.Feedback.base_diff,1) ;
                            handles.b.Feedback.base_diff_std= reshape(aa,[size(aa,2),size(aa, 3), 1]);
                            clear aa;
                        end
                    end
                elseif handles.b.flag.isShaping  && (  handles.b.perf.criteria(current_cond)==1 ||  handles.b.perf.criteria(current_cond)==2)
                    handles=shaping(handles,volume);
                elseif  handles.b.perf.criteria(current_cond)==9 &&  volume==handles.b.Feedback.current_block(2)
                    handles.b.Feedback.mean_baseline_roi =nanmean(handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):handles.b.Feedback.current_block(2),1:end-1),1);
                    handles.b.Feedback.std_baseline_roi=std(handles.b.proto.seqview.data( handles.b.Feedback.current_block(1):handles.b.Feedback.current_block(2),1:end-1),1);
                end
                %             if (handles.b.magic.debug == 1)
                %                 handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Raw Effective ROI: %3.6f\n', handles.b.proto.seqview.data(volume,:));
                %                 set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                %             end
                
                if handles.b.flag.multi_base
                    if handles.b.perf.criteria(current_cond)==1 || handles.b.perf.criteria(current_cond)==2
                        for iin1=1: size(handles.b.pre.base_cat,2)
                             ss=strfind(handles.b.proto.seqview.image_name{handles.b.Feedback.current_cond}{1},filesep);
                             aa=strfind( handles.b.proto.seqview.image_name{handles.b.Feedback.current_cond}{1}(ss(end)+1:end),handles.b.pre.base_cat{1,iin1});
                            %aa=strfind( handles.b.proto.seqview.image_name{handles.b.Feedback.current_cond},handles.b.pre.base_cat{1,iin1});
                            if ~isempty(aa)
                                handles.b.Feedback.mean_baseline_roi=handles.b.Feedback.base_diff_mean(:,iin1)';
                                handles.b.Feedback.std_baseline_roi=handles.b.Feedback.base_diff_std(:,iin1)';
                                break
                            end
                        end
                    end
                end
                if (handles.b.flag.isDelayed )
                    if  (current_cond+1)<=length(handles.b.perf.criteria)
                        if ( handles.b.perf.criteria(current_cond)==1||handles.b.perf.criteria(current_cond)==2) && volume==handles.b.Feedback.current_block(2)
                            
                            handles.b.Feedback.mean_regulation_roi= nanmean(handles.b.proto.seqview.data(handles.b.Feedback.current_block(1): handles.b.Feedback.current_block(2),1:end-1),1);
                        end
                    end
                    
                elseif ( handles.b.flag.isContinuous )
                    if  handles.b.perf.criteria(current_cond)~=9
                        if   handles.b.flag.isupregulation && handles.b.perf.regulation(current_cond)==1
                            handles.b.Feedback.blockData(volume)=(handles.b.proto.seqview.data(volume,1:end-1)- handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi;
                        elseif handles.b.flag.isdownregulation && handles.b.perf.regulation(current_cond)==2
                            handles.b.Feedback.blockData(volume)= (handles.b.Feedback.mean_baseline_roi-handles.b.proto.seqview.data(volume,1:end-1))./handles.b.Feedback.std_baseline_roi;
                        elseif handles.b.flag.iscon_del_feedback
                            if handles.b.perf.regulation(current_cond)==1
                                handles.b.Feedback.blockData(volume)=(handles.b.proto.seqview.data(volume,1:end-1)- handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi;
                            elseif handles.b.perf.regulation(current_cond)==2
                                handles.b.Feedback.blockData(volume)= (handles.b.Feedback.mean_baseline_roi-handles.b.proto.seqview.data(volume,1:end-1))./handles.b.Feedback.std_baseline_roi;
                            end
                        end
                    end
                elseif handles.b.flag.iscon_del_feedback
                    if  handles.b.perf.criteria(current_cond)~=9
                        if handles.b.perf.criteria(current_cond)==1
                            if   handles.b.flag.isupregulation && handles.b.perf.regulation(current_cond)==1
                                handles.b.Feedback.blockData(volume)=(handles.b.proto.seqview.data(volume,1:end-1)-handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi*handles.b.roi.count';
                            elseif handles.b.flag.isdownregulation && handles.b.perf.regulation(current_cond)==2
                                handles.b.Feedback.blockData(volume)=(handles.b.Feedback.mean_baseline_roi-handles.b.proto.seqview.data(volume,1:end-1))./handles.b.Feedback.std_baseline_roi*handles.b.roi.count';
                            elseif handles.b.flag.iscon_del_feedback
                                if handles.b.perf.regulation(current_cond)==1
                                    handles.b.Feedback.blockData(volume)=(handles.b.proto.seqview.data(volume,1:end-1)-handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi*handles.b.roi.count';
                                elseif handles.b.perf.regulation(current_cond)==2
                                    handles.b.Feedback.blockData(volume)=(handles.b.Feedback.mean_baseline_roi-handles.b.proto.seqview.data(volume,1:end-1))./handles.b.Feedback.std_baseline_roi*handles.b.roi.count';
                                end
                            end
                        end
                        % if (current_cond+1)<=length(handles.b.perf.criteria)
                        %    if handles.b.perf.criteria(current_cond+1)==2
                        if  (current_cond+1)<=length(handles.b.perf.criteria)
                            if  volume==handles.b.Feedback.current_block(2)
                                handles.b.Feedback.mean_regulation_roi= mean(handles.b.proto.seqview.data(handles.b.Feedback.current_block(1): handles.b.Feedback.current_block(2),1:end-1));
                            end
                        end
                        %   end
                        %end
                    end
                    
                    
                end
                %regulation moving average
                if   handles.b.perf.feedback_con_del(current_cond)==1
                    if(volume>=handles.b.Feedback.current_block(1)+ handles.b.ui.VOLUMES_TO_AVG-1)  && ~handles.b.flag.isDelayed
                        handles.b.Feedback.mean_regulation_roi_moving(volume) = mean(handles.b.Feedback.blockData((volume-handles.b.ui.VOLUMES_TO_AVG)+1:volume)); %avg of last few volumes
                        
                    else
                        handles.b.Feedback.mean_regulation_roi_moving(volume)=mean(handles.b.Feedback.blockData(handles.b.Feedback.current_block(1):volume));
                        
                    end
                    if (handles.b.magic.debug == 1)
                        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Moving Average: %3.6f\n',  handles.b.Feedback.mean_regulation_roi_moving(volume));
                        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                    end
                end
                %%%Compute Thermometer Graduations based on the correlation
                %%%coefficient and the actual BOLD in the roi1
                %NOTE: The below is for additive contrast i.e., [1 1] in the .bci file
                %The following has to be generalized for both additive and
                %subtractive contrasts
                if  (current_cond+1)<=length(handles.b.perf.criteria)  && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) && volume==handles.b.Feedback.current_block(2)
                    if  handles.b.flag.isDelayed && handles.b.flag.iscoefcorr && handles.b.flag.isupregulation && volume==handles.b.Feedback.current_block(2)
                        handles.b.Feedback.money(current_cond) = (((handles.b.Feedback.regulation_corr_coef -handles.b.Feedback.basline_corr_coef )*handles.b.ui.roi_threshold_reward)*handles.b.ui.euros_perbold);
                    elseif  handles.b.flag.isDelayed && handles.b.flag.iscoefcorr && handles.b.flag.isdownregulation && volume==handles.b.Feedback.current_block(2)
                        handles.b.Feedback.money(current_cond)= (((handles.b.Feedback.basline_corr_coef -handles.b.Feedback.regulation_corr_coef )*handles.b.ui.roi_threshold_reward)*handles.b.ui.euros_perbold);
                    elseif handles.b.ui.SHOW_REWARD && (handles.b.perf.regulation(current_cond)==1) && handles.b.flag.isposcorrelation &&  (handles.b.perf.criteria(current_cond+1)==2) && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isupregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) % postively correlated-upregulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_regulation_roi -handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*(1+handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif  handles.b.ui.SHOW_REWARD && (handles.b.perf.regulation(current_cond)==2) && handles.b.flag.isposcorrelation &&   (handles.b.perf.criteria(current_cond+1)==2)  && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isdownregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) % postively  correlated-down-regulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_baseline_roi -handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*(1+handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif handles.b.ui.SHOW_REWARD && (handles.b.perf.regulation(current_cond)==1)&& handles.b.flag.isnegcorrelation &&  (handles.b.perf.criteria(current_cond+1)==2) && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isupregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) % negatively correlated-upregulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_regulation_roi -handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*(1-handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif  handles.b.ui.SHOW_REWARD && (handles.b.perf.regulation(current_cond)==2)&& handles.b.flag.isnegcorrelation &&   (handles.b.perf.criteria(current_cond+1)==2)  && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isdownregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) %  negatively correlated-down-regulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_baseline_roi -handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*(1-handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif handles.b.ui.SHOW_REWARD  && (handles.b.perf.regulation(current_cond)==1) && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isupregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback) %upregulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_regulation_roi -handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif  handles.b.ui.SHOW_REWARD && (handles.b.perf.regulation(current_cond)==2)  && volume==handles.b.Feedback.current_block(2) && handles.b.flag.isdownregulation && (handles.b.flag.isDelayed || handles.b.flag.iscon_del_feedback)  % down-regulation-delayed or both-reward
                        handles.b.Feedback.money(current_cond) = ((handles.b.Feedback.mean_baseline_roi -handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold;
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&&  (handles.b.perf.regulation(current_cond)==1)&& handles.b.flag.isposcorrelation &&  handles.b.perf.criteria(current_cond+1)==2 && (handles.b.flag.isDelayed) && volume==handles.b.Feedback.current_block(2)  % up-rgulation postively correlated- continuous or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  (((handles.b.Feedback.mean_regulation_roi -handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi )*handles.b.roi.count'*((1+handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward));
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&&  handles.b.flag.isnegcorrelation &&(handles.b.perf.regulation(current_cond)==1)&&  handles.b.perf.criteria(current_cond+1)==2&& (handles.b.flag.isDelayed) && volume==handles.b.Feedback.current_block(2)% up-rgulation negatively correlated- continuos or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  (((handles.b.Feedback.mean_regulation_roi -handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi)*handles.b.roi.count'*((1-handles.b.Feedback.correl_delayed )*handles.b.ui.roi_threshold_reward));
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) && (handles.b.perf.regulation(current_cond)==1)   &&(handles.b.flag.isDelayed) && volume==handles.b.Feedback.current_block(2) %up-rgulation Delayed or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  ((handles.b.Feedback.mean_regulation_roi-handles.b.Feedback.mean_baseline_roi)./handles.b.Feedback.std_baseline_roi)*handles.b.roi.count'*handles.b.ui.roi_threshold_reward;
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&&  (handles.b.perf.regulation(current_cond)==2)&& handles.b.flag.isposcorrelation &&  handles.b.perf.criteria(current_cond+1)==2 && (handles.b.flag.isDelayed)&& volume==handles.b.Feedback.current_block(2) % down-rgulation postively correlated- continuous or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  (((handles.b.Feedback.mean_baseline_roi-handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi)*handles.b.roi.count'*handles.b.roi.count'*((1+handles.b.Feedback.correl_delayed)*handles.b.ui.roi_threshold_reward));
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&& (handles.b.perf.regulation(current_cond)==2)&&  handles.b.flag.isnegcorrelation &&  handles.b.perf.criteria(current_cond+1)==2&& (handles.b.flag.isDelayed) && volume==handles.b.Feedback.current_block(2)% down-rgulation negatively correlated- continuos or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  (((handles.b.Feedback.mean_baseline_roi-handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi)*handles.b.roi.count'*((1-handles.b.Feedback.correl_delayed)*handles.b.ui.roi_threshold_reward));
                        
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) && (handles.b.perf.regulation(current_cond)==2)   &&(handles.b.flag.isDelayed) && volume==handles.b.Feedback.current_block(2) %down-rgulation Delayed or both-thermormeter
                        handles.b.Feedback.grads_delayed(current_cond) =  ((handles.b.Feedback.mean_baseline_roi-handles.b.Feedback.mean_regulation_roi)./handles.b.Feedback.std_baseline_roi)*handles.b.roi.count'*handles.b.ui.roi_threshold_reward;
                        
                    end
                end
                if handles.b.perf.criteria(current_cond)==1
                    if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&&  handles.b.flag.isposcorrelation &&  handles.b.perf.criteria(current_cond)==1 && (handles.b.flag.isContinuous|| handles.b.flag.iscon_del_feedback) % postively correlated- continuous or both-thermormeter
                        handles.b.Feedback.grads_cont(volume)  = (handles.b.Feedback.mean_regulation_roi_moving(volume)*((1+handles.b.Feedback.correl_per_volume(volume))*handles.b.ui.roi_threshold));
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))&&  handles.b.flag.isnegcorrelation &&  handles.b.perf.criteria(current_cond)==1&& (handles.b.flag.isContinuous|| handles.b.flag.iscon_del_feedback) % negatively correlated- continuos or both-thermormeter
                        handles.b.Feedback.grads_cont(volume)  = (handles.b.Feedback.mean_regulation_roi_moving(volume)*((1-handles.b.Feedback.correl_per_volume(volume))*handles.b.ui.roi_threshold));
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) &&  handles.b.perf.criteria(current_cond)==1 && (handles.b.flag.isContinuous|| handles.b.flag.iscon_del_feedback) % continuos or both-thermormeter
                        handles.b.Feedback.grads_cont(volume) = (handles.b.Feedback.mean_regulation_roi_moving(volume))*handles.b.ui.roi_threshold;
                    elseif  handles.b.ui.SHOW_REWARD &&  handles.b.perf.criteria(current_cond)&& handles.b.flag.isContinuous %% continuos or both-thermormeter
                        handles.b.Feedback.money_cont(volume) = (handles.b.Feedback.mean_regulation_roi_moving(volume)*handles.b.ui.roi_threshold_reward*handles.b.ui.euros_perbold);
                    end
                end
                %             if (handles.b.magic.debug == 1)
                %                 handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Mean Baseline ROI: %3.6f\n', handles.b.Feedback.mean_baseline_roi);
                %                 set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                %             end
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%% Stimuli  presentation %%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if(strcmp(handles.b.flag.isTransfer, 'NO')) && ~handles.b.flag.Classification.istraining_data &&( handles.b.perf.criteria(current_cond)==1 ||  handles.b.perf.criteria(current_cond)==2)%feeback only when it is not a transfer mode
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%  writing stimuli %%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if handles.b.flag.iscon_del_feedback || handles.b.flag.isContinuous
                    if handles.b.ui.inter_TR==0 %%%if the feedback is provided continously
                        if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                            
                            if handles.b.flag.isref_zero
                                grads=fix(handles.b.Feedback.grads_cont(volume));
                                grads1=grads+round(handles.b.ui.thermo_grads) ;
                            else
                                grads=fix(handles.b.Feedback.grads_cont(volume));
                                grads1=grads+round(handles.b.ui.thermo_grads/2) ;
                            end
                            if grads1>handles.b.ui.thermo_grads+1
                                grads1=handles.b.ui.thermo_grads+1;
                            elseif grads1<0
                                grads1=0;
                            end
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_fb,'%s\n', num2str(grads1));
                            else
                                save([ handles.b.conf.output_dir, filesep, 'feedback.mat'], 'grads1');
                            end
                            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Graduations : %d\n', grads);
                            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                        end
                        
                    else %%%if the feedback is after a n|||umber of TR
                        if sum(volume==(handles.Feedback.feedback_TR))==0
                            if handles.b.perf.regulation(current_cond)==1 && handles.b.flag.istrend_reg
                                if  handles.b.Feedback.grads_cont(volume)> 0
                                    iin=iin+1;
                                    handles.b.Feedback.TR_4_current_feedback(iin)=volume;
                                    
                                end
                            elseif handles.b.perf.regulation(current_cond)==2 && handles.b.flag.istrend_reg
                                if  handles.b.Feedback.grads_cont(volume)> 0
                                    iin=iin+1;
                                    handles.b.Feedback.TR_4_current_feedback(iin)=volume;
                                    
                                end
                            elseif ~handles.b.flag.istrend_reg
                                iin=iin+1;  handles.b.Feedback.TR_4_current_feedback(iin)=volume;
                                
                            end
                            if iin>=handles.b.ui.thresh_feed
                                handles.b.flag.feed_go=1;
                            end
                            %  if sum(volume==(handles.Feedback.feedback_TR-2))>0
                            if handles.b.flag.istrend_reg && handles.b.flag.feed_go && ~isempty(handles.b.Feedback.TR_4_current_feedback)
                                if handles.b.flag.isref_zero
                                    grads=mean(handles.b.Feedback.grads_cont(handles.b.Feedback.TR_4_current_feedback));
                                    grads1=gards+round(handles.b.ui.thermo_grads);
                                else
                                    grads=mean(handles.b.Feedback.grads_cont(handles.b.Feedback.TR_4_current_feedback));
                                    grads1=grads+round(handles.b.ui.thermo_grads/2);
                                end
                                if grads1>handles.b.ui.thermo_grads+1
                                    grads1=handles.b.ui.thermo_grads+1;
                                elseif grads1<0
                                    grads1=0;
                                end
                                if handles.b.flag.isfeed_text
                                    TR_feed= volume<handles.Feedback.feedback_TR;
                                    nanaam=find(TR_feed==0);
                                    if isempty(nanaam)
                                        TT=1;
                                    else
                                        TT=max(nanaam)+1;
                                    end
                                    fprintf(handles.b.ui.fid_inter,'%s\n', [num2str(handles.Feedback.feedback_TR(TT)+handles.b.roi.volumes_skip),': ',num2str(grads1)]);
                                    handles.b.flag.feed_go=0;iin=0;
                                    disp(['TR: ' num2str(handles.Feedback.feedback_TR(TT)+handles.b.roi.volumes_skip)])
                                else
                                    TR_feed= volume<handles.Feedback.feedback_TR;
                                    nanaam=find(TR_feed==0);
                                    if isempty(nanaam)
                                        TT=1;
                                    else
                                        TT=max(nanaam)+1;
                                    end
                                    feedback=[num2str(handles.Feedback.feedback_TR(TT)+handles.b.roi.volumes_skip),' : ', num2str(grads1)];
                                    save([ handles.b.conf.output_dir, filesep, 'intermediate.mat'], 'feedback');
                                end
                            elseif ~handles.b.flag.istrend_reg
                                if handles.b.flag.isref_zero
                                    grads=mean(handles.b.Feedback.grads_cont(handles.b.Feedback.TR_4_current_feedback));
                                    grads1=gards+round(handles.b.ui.thermo_grads);
                                else
                                    grads=mean(handles.b.Feedback.grads_cont(handles.b.Feedback.TR_4_current_feedback));
                                    grads1=grads+round(handles.b.ui.thermo_grads/2);
                                end
                                if grads1>handles.b.ui.thermo_grads+1
                                    grads1=handles.b.ui.thermo_grads+1;
                                elseif grads1<0
                                    grads1=0;
                                end
                                if handles.b.flag.isfeed_text
                                    fprintf(handles.b.ui.fid_inter,'%s\n', [num2str(volume+2 + handles.b.roi.volumes_skip),' : ', grads1]);
                                else
                                    feedback=[num2str(volume+2+handles.b.roi.volumes_skip),' : ', num2str(grads1)];
                                    save([ handles.b.conf.output_dir, filesep, 'intermediate.mat'], 'feedback');
                                end
                            end
                            
                            %   end
                        else
                            handles.b.Feedback.TR_4_current_feedback(1:end-1)=[];
                            handles.b.flag.feed_go=0;
                            iin=0;
                        end
                    end
                    if (handles.b.ui.SHOW_REWARD && handles.b.flag.isContinuous) || ((handles.b.perf.feedback_con_del(current_cond)==1|| handles.b.perf.feedback_con_del(current_cond)==2) && handles.b.ui.SHOW_REWARD && volume==handles.b.Feedback.current_block(2) )
                        TR_feed= volume<handles.b.proto.seqview.reward_TR;
                        nanaam=find(TR_feed==0);
                        if isempty(nanaam)
                            TT=1;
                        else
                            TT=max(nanaam)+1;
                        end
                        
                        if handles.b.Feedback.money(current_cond)<=0 ||  handles.b.Feedback.money_cont(volume)<=0
                            money=0;
                        elseif handles.b.Feedback.money(current_cond)>0 && volume==handles.b.Feedback.current_block(2) &&  (handles.b.perf.feedback_con_del(current_cond+1)==2 )
                            money=handles.b.Feedback.money(current_cond);
                            
                            handles.b.Feedback.total_money=handles.b.Feedback.total_money+money;
                        elseif handles.b.ui.SHOW_REWARD && handles.b.flag.isContinuous
                            money=handles.b.Feedback.money_cont(volume);
                            handles.b.Feedback.total_money=handles.b.Feedback.total_money+money;
                        end
                        if handles.b.perf.reward_seq(current_cond+1)==3 && handles.b.flag.iscon_del_feedback
                            money= sum(handles.b.Feedback.grads_cont(handles.b.Feedback.grads_cont>0))*handles.b.ui.euros_perbold;
                            % money=handles.b.Feedback.total_money;
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                        elseif  handles.b.perf.reward_seq(current_cond+1)==2
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                        elseif handles.b.perf.reward_seq(current_cond+1)==3 && handles.b.flag.isDelayed
                            money=sum(handles.b.Feedback.money(handles.b.Feedback.money>0));
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n', [num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                        elseif handles.b.perf.reward_seq(current_cond+1)==3 && handles.b.flag.isContinuous
                            money=sum(handles.b.Feedback.money_cont(handles.b.Feedback.money_cont>0));
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n', [num2str(volume+1),':', num2str(money)]);
                            else
                                feedback=[num2str(volume+1),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                        end
                        
                        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Reinforcement : %d\n',  money);
                        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                    end
                    
                elseif handles.b.flag.isDelayed
                    if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) && volume==handles.b.Feedback.current_block(2) &&  handles.b.perf.feedback_con_del(current_cond+1)==2
                        if handles.b.flag.isref_zero
                            grads=handles.b.Feedback.grads_delayed(volume);
                            grads1=grads+round(handles.b.ui.thermo_grads);
                        else
                            grads=handles.b.Feedback.grads_delayed(volume);
                            grads1=grads+round(handles.b.ui.thermo_grads/2);
                        end
                        if grads1>handles.b.ui.thermo_grads+1
                            grads1=handles.b.ui.thermo_grads+1;
                        elseif grads1<0
                            grads1=0;
                        end
                        fprintf(handles.b.ui.fid_fb,'%s\n', num2str(grads1));
                        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Graduations : %d\n', grads);
                        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                        
                    elseif handles.b.ui.SHOW_REWARD
                        TR_feed= volume<handles.b.proto.seqview.reward_TR;
                        nanaam=find(TR_feed==0);
                        if isempty(nanaam)
                            TT=1;
                        else
                            TT=max(nanaam)+1;
                        end
                        if handles.b.Feedback.money(current_cond)<=0 && volume==handles.b.Feedback.current_block(2) &&  handles.b.perf.feedback_con_del(current_cond+1)==2
                            money=0;
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Reinforcement : %d\n',  money);
                            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                            
                        elseif handles.b.Feedback.money(current_cond)>0 && volume==handles.b.Feedback.current_block(2) &&  handles.b.perf.feedback_con_del(current_cond+1)==2
                            money=handles.b.Feedback.money(current_cond);
                            handles.b.Feedback.total_money=handles.b.Feedback.total_money+money;
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Reinforcement : %d\n',  money);
                            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                            
                        elseif handles.b.Feedback.money(current_cond)<=0 && volume==handles.b.Feedback.current_block(2)  &&  handles.b.flag.isDelayed
                            money=0;
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Reinforcement : %d\n',  money);
                            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                            
                        elseif handles.b.Feedback.money(current_cond)>0 && volume==handles.b.Feedback.current_block(2) &&  handles.b.flag.isDelayed
                            money=handles.b.Feedback.money(current_cond);
                            handles.b.Feedback.total_money=handles.b.Feedback.total_money+money;
                            if handles.b.flag.isfeed_text
                                fprintf(handles.b.ui.fid_money,'%s\n',[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)]);
                            else
                                feedback=[num2str(handles.b.proto.seqview.reward_TR(TT)+handles.b.roi.volumes_skip),':', num2str(money)];
                                save([ handles.b.conf.output_dir, filesep, 'money.mat'], 'feedback');
                            end
                            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= sprintf('Reinforcement : %d\n',  money);
                            set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
                            
                        end
                    end
                elseif   (strcmp(handles.b.ui.feedbacktype, 'SEAWORLD'))
                    if grads>0
                        step=step+1;
                        isActivation='YES';
                    end
                    update_seaworld(step, grads, isActivation, is_new_start, handles.b.flag.isTransfer);
                end
            end
            
            handles.b.Feedback.delta_t(volume)=toc;
            if handles.b.Feedback.delta_t(volume)>2*handles.b.roi.TR
                beep
                pre = '<HTML><FONT color="';
                post = '</FONT></HTML>';
                figure(handles.b.figures.figure_session_log);
                %handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=' test  ';
                handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [pre ,rgb2Hex( [255 128 0] ), '">' ,'Processing time is too high. Please restart the neurofeedback run',post];
                set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
                
            end
          if  ~handles.b.flag.istesting  
            NO.dat(:,:,:,1,1,1) = handles.b.current_volume.volume_norm;
          end
          tt(4,volume)=toc;
            %             t3(volume)= t2(volume)-t1(volume);
            %             t3(volume)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%% Update Stimuli %%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ( handles.b.perf.feedback_con_del(current_cond)==1 ||  handles.b.perf.feedback_con_del(current_cond)==2)
                if handles.b.flag.iscon_del_feedback
                    if handles.b.ui.inter_TR==0
                        if  handles.b.perf.feedback_con_del(current_cond)==2 && volume==handles.b.Feedback.current_block(1)
                            handles=bci_image_display(handles,'update_back' );
                            handles=bci_image_display(handles,  money);
                        elseif handles.b.perf.feedback_con_del(current_cond)==1 && volume==handles.b.Feedback.current_block(1) && handles.b.proto.Nr_images==0
                            handles=bci_image_display(handles,'update_back' );
                            update_thermo(handles.b.figures.feedback_fig, handles.b.ui, grads, [1 0 0],handles); %activation
                        elseif handles.b.perf.feedback_con_del(current_cond)==1
                            update_thermo(handles.b.figures.feedback_fig, handles.b.ui,grads, [1 0 0],handles); %activation
                        end
                    elseif handles.b.perf.feedback_con_del(current_cond)==2 && volume==handles.b.Feedback.current_block(1)
                        handles=bci_image_display(handles,'update_back' );
                        handles=bci_image_display(handles,  money);
                    elseif handles.b.perf.feedback_con_del(current_cond)==1
                        if sum(handles.b.Feedback.not_vol_incl == volume)>0
                            grads= mean(handles.b.Feedback.grads_cont(handles.b.Feedback.TR_4_current_feedback));
                            update_thermo(handles.b.figures.feedback_fig, handles.b.ui,grads, [1 0 0],handles); %activation
                        else
                            update_thermo(handles.b.figures.feedback_fig, handles.b.ui,0, [1 0 0],handles); %activation
                            
                        end
                    end
                elseif (handles.b.flag.isDelayed &&  handles.b.perf.feedback_con_del(current_cond)==2) && volume==handles.b.Feedback.current_block(1)
                    handles=bci_image_display(handles,'update_back' );
                    if handles.b.ui.SHOW_REWARD
                        handles=bci_image_display(handles , money);
                    elseif (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                        update_thermo(handles.b.figures.feedback_fig, handles.b.ui, grads, [1 0 0],handles); %activation
                    end
                elseif handles.b.ui.inter_TR>0
                    if sum( handles.b.Feedback.not_vol_incl == volume)>0 &&   (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                        
                        handles=bci_image_display(handles,'update_back' );
                        update_thermo(handles.b.figures.feedback_fig, handles.b.ui, grads, [1 0 0],handles); %activation
                    elseif sum( handles.b.Feedback.not_vol_incl == volume)>0 &&  handles.b.ui.SHOW_REWARD
                        handles=bci_image_display(handles,'update_back' );
                        handles=bci_image_display(handles , money);
                    end
                elseif handles.b.flag.isContinuous && (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) && handles.b.ui.SHOW_REWARD
                    update_thermo(handles.b.figures.feedback_fig,handles.b.ui,grads,[1,0,0],handles);
                    set(handles.b.figures.cum_feed,'string', num2str(handles.b.Feedback.total_money));
                elseif handles.b.flag.isContinuous && (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                    update_thermo(handles.b.figures.feedback_fig, handles.b.ui, grads, [1 0 0],handles); %activation
                end
            end
            
            %plot data in real-time
            %         handles.b.current_volume.V = spm_create_vol(handles.b.current_volume.V);
            %         handles.b.current_volume.V= spm_write_plane(handles.b.current_volume.V,handles.b.current_volume.volume,':');
            %         handles.b.current_volume.V_norm = spm_create_vol(handles.b.current_volume.V_norm);
            %         handles.b.current_volume.V_norm= spm_write_plane(handles.b.current_volume.V_norm,handles.b.current_volume.volume_norm,':');
            %         if ((handles.b.flag.isrealignment) ||         ~handles.b.flag.isClassification) &&        ~handles.b.flag.isnormalization
            %             handles.b.Feedback.current_volume.vol_reg = spm_create_vol(hhandles.b.Feedback.current_volume.vol_reg);
            %             handles.b.Feedback.current_volume.vol_reg= spm_write_plane(handles.b.Feedback.current_volume.vol_reg,handles.b.Feedback.current_volume.volume_realgn,':');
            %         else
            %              handles.b.current_volume.V = spm_create_vol(handles.b.current_volume.V);
            %         handles.b.current_volume.V= spm_write_plane(handles.b.current_volume.V,handles.b.current_volume.volume,':');
            %         handles.b.current_volume.V_norm = spm_create_vol(handles.b.current_volume.V_norm);
            %         handles.b.current_volume.V_norm= spm_write_plane(handles.b.current_volume.V_norm,handles.b.current_volume.volume_norm,':');
            % %
            %         end
            
            
            tt(5,volume)=toc;
            if  ~handles.b.flag.istesting
                handles=plot_image_para(handles);
            end
            if (handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation) && strcmp(handles.b.ui.feedbacktype , 'THERMOMETER')
                axes(handles.b.figures.aHand_ROIs)
                for ii=1:length(handles.b.roi.count)
                    set(handles.b.figures.R(ii),'YData',handles.b.proto.seqview.per_ROI(1:handles.b.Feedback.current_volume,1));
                    uistack(handles.b.figures.R(ii),'top');
                end
                % drawnow
                axes( handles.b.figures.aHand_global)
                set(handles.b.figures.global,'YData', handles.b.proto.seqview.per_global(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.global,'top');
                %  drawnow
                axes(handles.b.figures.aHand_correl)
                set(handles.b.figures.correl,'YData', handles.b.Feedback.correl_per_volume(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.correl,'top');
                %    drawnow
                axes(handles.b.figures.aHand_feedback)
                set(handles.b.figures.feedback,'YData',handles.b.Feedback.grads_cont(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.feedback,'top');
                %  drawnow
                
            elseif strcmp(handles.b.ui.feedbacktype , 'THERMOMETER')
                axes(handles.b.figures.aHand_ROIs)
                for ii=1:length(handles.b.roi.count)
                    set(handles.b.figures.R(ii),'YData',handles.b.proto.seqview.per_ROI(1:handles.b.Feedback.current_volume,ii));
                    uistack(handles.b.figures.R(ii),'top');
                end
                % drawnow
                axes( handles.b.figures.aHand_global)
                set(handles.b.figures.global,'YData', handles.b.proto.seqview.per_global(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.global,'top');
                % drawnow
                axes(handles.b.figures.aHand_feedback)
                set(handles.b.figures.feedback,'YData',handles.b.Feedback.grads_cont(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.feedback,'top');
                %   drawnow
                
            elseif (handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation)
                axes(handles.b.figures.aHand_ROIs)
                for ii=1:length(handles.b.roi.count)
                    set(handles.b.figures.R(ii),'YData',handles.b.proto.seqview.per_ROI(1:handles.b.Feedback.current_volume,ii));
                    uistack(handles.b.figures.R(ii),'top');
                end
                %   drawnow
                axes( handles.b.figures.aHand_global)
                set(handles.b.figures.global,'YData', handles.b.proto.seqview.per_global(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.global,'top');
                %  drawnow
                axes(handles.b.figures.aHand_correl)
                set(handles.b.figures.correl,'YData', handles.b.Feedback.correl_per_volume(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.correl,'top');
                %  drawnow
                
            else
                axes(handles.b.figures.aHand_ROIs)
                for ii=1:length(handles.b.roi.count)
                    set(handles.b.figures.R(ii),'YData',handles.b.proto.seqview.per_ROI(1:handles.b.Feedback.current_volume,ii));
                    uistack(handles.b.figures.R(ii),'top');
                end
                % drawnow
                axes( handles.b.figures.aHand_global)
                set(handles.b.figures.global,'YData', handles.b.proto.seqview.per_global(1:handles.b.Feedback.current_volume,1));
                uistack(handles.b.figures.global,'top');
                %  drawnow
            end
            tt(6,volume)=toc;
            %         if handles.b.flag.isShaping
            %             axes(handles.b.figures.aHand_ROIs)
            %             set( handles.b.figures.aHand_mean_line,'YData',ones(handles.b.roi.volumes,1)*handles);
            %         end
            
            if handles.b.flag.isstimulate
                pause(handles.b.roi.TR-(cputime-tt));
            end
            
        end %end of volume loop
        
        
    end %end of cond loop
    
    
    
    % if handles.b.ui.SHOW_REWARD
    %     %     while 1
    %     %         if exist ([ handles.b.conf.full_targetdir 'feedback-',num2str(handles.b.conf.run_num-i111),'.mat'])==2 %#ok<EXIST>
    %     %             previous_last_run =load([ handles.b.conf.full_targetdir 'feedback-',num2str(handles.b.conf.run_num-i111),'.mat']);
    %     %         end
    %     %         if (handles.b.conf.run_num-i111)==0
    %     %             previous_last_run.Feedback.reward.total_reward=0;
    %     %             break;
    %     %         elseif ~isempty(previous_last_run)
    %     %             break;
    %     %         end
    %     %         i111=i111+1;
    %     %     end
    % end
    save([ handles.b.conf.target_subj_path,filesep, 'feedback-',num2str(handles.b.conf.run_num),'.mat'],'handles');
    
    
    
    %delete the thermo
    if(strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')) && (current_cond > 1)
        delete_thermo(handles);
    end
    
    if(strcmp(handles.b.ui.feedbacktype, 'SEAWORLD')) && (current_cond > 1) && (handles.b.ui.image == 0)
        delete_seaworld;
    end
    
    
    
    % if(strcmp(handles.b.ui.simtype, 'MANUAL'))
    %     set(handles.b.figures.feedback_fig, 'KeyPressFcn', 'default'); %reset keyboard controls, IMPORTANT!
    % end
    
    % if  handles.b.ui.SHOW_REWARD
    %     Feedback.reward.total_reward=sum(Feedback.reward.current_reward);
    %     fprintf('Total Reinforcement : %d\n',  Feedback.reward.total_reward);
    %     if (previous_last_run.Feedback.reward.total_reward +Feedback.reward.total_reward)>handles.b.ui.MAX_EUROS
    %         msgbox('Subject reaches the maximum limit of reinforcement', 'Warning');
    %     else
    %         Feedback.reward.total_reward=previous_last_run.Feedback.reward.total_reward +Feedback.reward.total_reward;
    %     end
    % end
    
    %fclose( fid ); %close the file
    if handles.b.flag.isfeed_text
        fclose(handles.b.ui.fid_fb);
        fclose(handles.b.ui.fid_money);
        fclose(handles.b.ui.fid_inter);
        copyfile([handles.b.conf.output_dir filesep 'feedback.txt'],[handles.b.conf.target_subj_path,filesep, 'feedback-',num2str(handles.b.conf.run_num),'.txt']);
        copyfile([handles.b.conf.output_dir filesep 'money.txt'],[handles.b.conf.target_subj_path,filesep, 'money-',num2str(handles.b.conf.run_num),'.txt']);
        copyfile([handles.b.conf.output_dir filesep 'intermediate.txt'],[handles.b.conf.target_subj_path,filesep, 'intermediate-',num2str(handles.b.conf.run_num),'.txt']);
        copyfile([handles.b.conf.output_dir filesep 'current_run.txt'],[handles.b.conf.target_subj_path,filesep, 'current_run-',num2str(handles.b.conf.run_num),'.txt']);
        delete ([handles.b.conf.output_dir filesep 'feedback.txt'],[handles.b.conf.output_dir filesep 'money.txt'],[handles.b.conf.output_dir filesep 'intermediate.txt'],[handles.b.conf.output_dir,filesep,'current_run.txt']);
    end
    %set(handles.bcigui,'visible','on');
    close(handles.b.figures.feedback_fig);
    close(handles.b.figures.fHand_plot_data);
    close(handles.b.figures.image_vis_fig);
    if handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation
        handles.b.figures=rmfield(handles.b.figures,{'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig',...
            'global','R','aHand_global','aHand_ROIs','fHand_plot_data','aHand_correl'});
    else
        handles.b.figures=rmfield(handles.b.figures,{'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig',...
            'global','R','aHand_global','aHand_ROIs','fHand_plot_data'});
    end
    
    % hold off
    if  handles.b.flag.isdiagnosis
        aa(1,:)=tt(1,:);
        aa(2,:)=tt(2,:)-tt(1,:);
        aa(3,:)=tt(3,:)-tt(2,:);
        aa(4,:)=tt(4,:)-tt(3,:);
        aa(5,:)=tt(5,:)-tt(4,:);
        aa(6,:)=tt(6,:)-tt(5,:);
        aa=aa*1000;
        figure
        hold on
        handles.b.quality.original=aa;
        handles.b.quality.mean=mean(aa,2);
        handles.b.quality.std=std(aa');
        bar(1:6,mean(aa,2)')
        errorbar(1:6,mean(aa,2)',std(aa'),'.')
        set(gca, 'XTICKLABEL',{'','Dicom','Realign','Normalization','Feedback','Update_stim','Update_feed'}) ;
        %set(gca, 'XTickLabelRotation', 45);
        
    end
    
    %%%%%%%%%%%%%%%% creat model %%%%%%%%%%%%%%%%%%%%
    if handles.b.flag.isClassification && handles.b.flag.Classification.iscreate_model
        
    end
    
    
    
    
    
    %PLOT the correlation values
    % fig3=figure;
    % plot(grads_vector(20:end));
    % title('Correlated activity of ROI1 & ROI2');
    %
    
    handles.b.iserror=0;
    return
catch ME
    save([ handles.b.conf.target_subj_path,filesep, 'feedback-',num2str(handles.b.conf.run_num),'.mat'],'handles');
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
    close(handles.b.figures.feedback_fig);
    close(handles.b.figures.fHand_plot_data);
    close(handles.b.figures.image_vis_fig);
    return
end
%------------------------------------------
% function out=time_out_in(filename)
% t = clock;out=0;
% while(exist(filename)~=2 )
% %     if (etime(clock,t) >2*handles.b.roi.TR),
% %         %disp([message filename]);
% %         % error('Time out');
% %         out=1;
% %         break;
% %     end
%     pause(0.01);
% end


