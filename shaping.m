

function handles=shaping(handles,volume)
try
    if handles.b.Feedback.current_block(1)==volume
        TRs=handles.b.proto.seqview.block{handles.b.Feedback.current_cond-1}(1):handles.b.proto.seqview.block{handles.b.Feedback.current_cond-1}(2);
        for ii=1:size(handles.b.proto.seqview.data,2)-1
            handles.b.shaping.unique_TR{ii}= unique(handles.b.proto.seqview.data(TRs,ii),'sorted');
            if strcmp(handles.b.shaping.regulation, 'upregulation')
                handles.b.Feedback.mean_baseline_roi( 1,ii)=nanmean(handles.b.shaping.unique_TR{ii}(1:handles.b.shaping.choose_TR));
                handles.b.Feedback.std_baseline_roi( 1,ii)=nanstd(handles.b.shaping.unique_TR{ii}(1:handles.b.shaping.choose_TR));
            else
                handles.b.Feedback.mean_baseline_roi( 1,ii)=nanmean(handles.b.shaping.unique_TR{ii}(end-handles.b.shaping.choose_TR+1:end));
                handles.b.Feedback.std_baseline_roi( 1,ii)=nanstd(handles.b.shaping.unique_TR{ii}(end-handles.b.shaping.choose_TR+1:end));
            end
            handles.b.Feedback.idx_shaping(ii)=1;
        end
       
    else
        if handles.b.Feedback.blockData(volume-1)>0
           
         for ii=1:size(handles.b.proto.seqview.data,2)-1
            if strcmp(handles.b.shaping.regulation, 'upregulation')
                if length(handles.b.shaping.unique_TR{ii})< handles.b.Feedback.idx_shaping(ii)+handles.b.shaping.choose_TR
                     handles.b.Feedback.idx_shaping(ii)=handles.b.Feedback.idx_shaping(ii)+1;
                end
                handles.b.Feedback.mean_baseline_roi( 1,ii)=nanmean(handles.b.shaping.unique_TR{ii}(handles.b.Feedback.idx_shaping(ii):handles.b.Feedback.idx_shaping(ii)+handles.b.shaping.choose_TR));
                handles.b.Feedback.std_baseline_roi( 1,ii)=nanstd(handles.b.shaping.unique_TR{ii}(handles.b.Feedback.idx_shaping(ii):handles.b.Feedback.idx_shaping(ii)+handles.b.shaping.choose_TR));
            else
                if length(handles.b.shaping.unique_TR{ii})< handles.b.Feedback.idx_shaping(ii)+handles.b.shaping.choose_TR
                     handles.b.Feedback.idx_shaping(ii)=handles.b.Feedback.idx_shaping(ii)+1;
                end
                handles.b.Feedback.mean_baseline_roi( 1,ii)=nanmean(handles.b.shaping.unique_TR{ii}(end-(handles.b.shaping.choose_TR+handles.b.Feedback.idx_shaping(ii)):end-handles.b.Feedback.idx_shaping(ii)));
                handles.b.Feedback.std_baseline_roi( 1,ii)=nanstd(handles.b.shaping.unique_TR{ii}(end-(handles.b.shaping.choose_TR+handles.b.Feedback.idx_shaping(ii)):end-handles.b.Feedback.idx_shaping(ii)));
            end
         end
        end
    end        
      
catch ME
    figure(handles.b.figures.figure_session_log);
     handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack(1).line),' in ', ME.stack(1).name,': ',ME.message];
     set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));

end