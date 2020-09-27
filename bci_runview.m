function handles = bci_runview(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes the display of feedback and generation of results for the given
%BCI data structure b passed in as the argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 try
    if strcmp(handles.b.session_type,'Anatomical Run')
        h=fixation_figure;
        mkdir([handles.b.conf.target_subj_path,filesep,'Anatomyf'])
        handles.b.conf.anatomy_path=[handles.b.conf.target_subj_path, filesep, 'Anatomyf'];
        handles.b.conf.out_volume_path=handles.b.conf.anatomy_path;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Extracting structurtal image ...' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        % disp('Extracting structurtal image ...');
        handles=process_anatomy(handles);
        if handles.b.iserror
            return;
        end
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Anatomical image constructed.' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        close(h);
        %disp('Anatomical image constructed.');
    elseif strcmp( handles.b.session_type,'Localizer Collect Data') 
         handles.b.figures.feedback_fig = figure('Name', 'Feedback','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off');
%          if ~isfield(handles.b.Feedback,'localizer_idx')
%               handles.b.Feedback.localizer_idx=1;
%          else
%              handles.b.Feedback.localizer_idx=handles.b.Feedback.localizer_idx+1;
%          end
         handles.b.conf.localizer_path=[handles.b.conf.target_subj_path, filesep, 'Localizer_',num2str(handles.b.Feedback.localizer_idx)];
         mkdir(handles.b.conf.localizer_path);
         handles = bci_images(handles);
         handles=localizer_collect_data(handles);
         handles.b.iserror=0;
         delete(handles.b.figures.image_vis_fig);
         delete( handles.b.figures.feedback_fig);
         handles.b.figures=rmfield(handles.b.figures,{'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig'});
    elseif strcmp( handles.b.session_type,'Localizer Analysis')
         h=fixation_figure;
         handles=localizer_analysis(handles);
         delete(h);
    elseif strcmp(handles.b.session_type,'Dummy Functional Run')
        if isfield(handles.b.pre.hdr,'dim_init')
            handles.b.pre.hdr.dim=handles.b.pre.hdr.dim_init;
        end
        handles.b.pre.column=handles.b.pre.column_init;
        handles.b.pre.row=handles.b.pre.row_init;
        handles=initiate_figure_vis(handles);
        h=fixation_figure;
        mkdir([handles.b.conf.target_subj_path,filesep ,'Dummy_', sprintf('%02d',handles.b.Feedback.dummy_idx)])
        handles.b.conf.dummy_path=[handles.b.conf.target_subj_path, filesep, 'Dummy_', sprintf('%02d',handles.b.Feedback.dummy_idx)];
        handles.b.conf.out_volume_path=handles.b.conf.dummy_path;
        %     if handles.b.conf.session>1
        %        mkdir([handles.b.conf.target_subj_path,filesep,'Anatomyf'])
        %        [~,nn,et]=fileparts(handles.b.pre.ori.gm_anatomical_image);
        %        handles.b.pre.gm_anatomical_image= [handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,nn,et];
        %        copyfile(handles.b.pre.ori.gm_anatomical_image, handles.b.pre.gm_anatomical_image);
        %        clear nn et;
        %        [~,nn,et]=fileparts(handles.b.pre.ori.wm_anatomical_image);
        %        handles.b.pre.wm_anatomical_image= [handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,nn,et];
        %        copyfile(handles.b.pre.ori.wm_anatomical_image, handles.b.pre.wm_anatomical_image)
        %          clear nn et;
        %        [~,nn,et]=fileparts(handles.b.pre.ori.extracted_anatomical_image);
        %        handles.b.pre.wm_anatomical_image= [handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,nn,et];
        %        copyfile(handles.b.pre.ori.extracted_anatomical_image, handles.b.pre.extracted_anatomical_image)
        %         clear nn et;
        %        [~,nn,et]=fileparts(handles.b.pre.ori.norm_def);
        %        handles.b.pre.norm_def= [handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,nn,et];
        %        copyfile(handles.b.pre.ori.norm_def, handles.b.pre.norm_def)
        %         clear nn et;
        %     end
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Realigning functional images ...' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        
        %disp('Realigning functional images ...');
        handles=dummy_functional(handles);
        if  handles.b.iserror
            return;
        end
        figure(handles.b.figures.image_vis_fig);
        saveas(gcf,[handles.b.conf.dummy_path,filesep, handles.b.conf.sub_name,'_',num2str(handles.b.conf.run_num),'_','dummy_realign.jpg'])
        delete(handles.b.figures.image_vis_fig);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Reallignment finished.' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Calculating Normalization parameters.' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        
        % disp('Reallignment finished.');
        %     if ~isfield(handles.b.pre,'anatomical_image')
        %         if strcmp(  handles.b.pre.anatomical_image,'')
        %             [file, paths]= uigetfile(handles.b.conf.anatomy_path);
        %             handles.b.pre.anatomical_image =fullfile(paths,file);
        %         end
        %     end
        handles=norm_parameters(handles);
        if  handles.b.iserror
            return;
        end
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Normalization parameters estimated.' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        close(h)
        handles.b.iserror=0;
        handles.b.figures=rmfield(handles.b.figures,{'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig'});
    else
        mkdir([handles.b.conf.target_subj_path,filesep ,'Feed_',sprintf('%03d',handles.b.Feedback.feed_idx)])
        handles.b.conf.feed_path=[handles.b.conf.target_subj_path, filesep,'Feed_',sprintf('%03d',handles.b.Feedback.feed_idx)];
        handles.b.conf.out_volume_path=handles.b.conf.feed_path;
        if size( handles.b.pre.func_planes,2)>(handles.b.pre.row*handles.b.pre.column)|| abs(size( handles.b.pre.func_planes,2)-(handles.b.pre.row*handles.b.pre.column))>handles.b.pre.column
            x = inputdlg(['Enter the rows and columns for visualization (Total planes:' , num2str(size(handles.b.pre.func_planes,2)),'):'],...
                'Example : 4 5' );
            data = str2num(x{1});
            handles.b.pre.row=data(1); handles.b.pre.column=data(2);
        end
        handles=initiate_figure_vis(handles);
        handles=plot_data_initiate(handles);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Feedback protocol started.' ;
        set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        handles.b.figures.feedback_fig = figure('Name', 'Feedback','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off');
        
        %fprintf('\nFeedback protocol started.\n');
        handles.b.mydate = datestr(now);
        if  handles.b.flag.iscon_del_feedback && handles.b.ui.image>0
            handles=bci_init_thermo_image(handles);
        elseif strcmp(handles.b.ui.feedbacktype, 'THERMOMETER')
            handles.b.ui.thermo_ax = bci_init_thermo(  handles.b.roi.background ,handles);
        elseif handles.b.flag.isDelayed
            handles = bci_images(handles); % read optional image files to display on top of feedback window
        else
        end
        if handles.b.flag.isfeed_text
            handles.b.ui.fid_fb=fopen([ handles.b.conf.output_dir filesep 'feedback.txt'], 'wt');
            handles.b.ui.fid_money=fopen([ handles.b.conf.output_dir filesep 'money.txt'], 'wt');
            handles.b.ui.fid_inter=fopen([ handles.b.conf.output_dir filesep 'intermediate.txt'], 'wt');
            %  handles.b.ui.fid_tot_money=fopen([ handles.b.conf.output_dir filesep 'total_money.txt'], 'wt');
        end
        
        if  handles.b.flag.isDelayed &&  handles.b.ui.image==0
            msgbox('Isdelayed option and the protocol in master directory does not match!', 'Error selecting options');
            return;
        end
        handles  = bci_view( handles);
        if  handles.b.iserror
            return;
        end
        % fprintf('\nFeedback protocol complete.\n');
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Feedback protocol complete.' ;
        set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        handles.b.iserror=0;
    end
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end

