function handles=bci_protocol_no_TBV(handles)
try
    %[ data, proto, perf ] = bci_protocol( proto, base,b)
    %BCI_PROTOCOL Read stimulation protocol & display it to subject
    h = waitbar(0,'Please wait...');
    % feedback array 'data' will be set up with stimulation protocol conditions
    %   column1: condition nr. // column2: block nr. within condition
    %   - read from 'filename'.
    % new fields of proto are
    %   .count      - number of conditions
    %   .cond( count ).???  - .color, .blocks
    %               // should all be read from *.prt file, not hardcoded //
    %%bci_ui_wait( proto.file ); % wait until regular file is there
    % if ~exist(handles.b.conf.proto_file) %#ok<EXIST>
    %     handles.b.conf.proto_file =[handles.b.conf.master_dir,filesep, 'feedback.prt'];
    % end
    fid = fopen( handles.b.conf.current_proto_file , 'rt');   % text mode (matlab does the '\r\n' stuff)
    if fid==-1
        return
    end
    % I could read the 'NrOfConditions' with bci_read(), but I have no way of
    %   knowing where my condition data (unfortunately all in free form) starts.
    handles.b.proto.Nr_images = bci_str2int( bci_read_matchline( fid, 'NrOfImages',handles));
    handles.b.ui.image=handles.b.proto.Nr_images;
    handles.b.proto.images.path = ( bci_read_matchline( fid, 'PathImages' ,handles));
    handles.b.proto.count = bci_str2int( bci_read_matchline( fid, 'NrOfConditions',handles ));
    % So I assume it starts just after the 'NrOfConditions' entry ;-) // danger //
    for c = 1:handles.b.proto.count
        waitbar(c/(handles.b.proto.count+2));
        handles.b.proto.cond(c).name = read_no_empty(fid);                % just to check //
        handles.b.proto.cond(c).blocks = bci_str2int( bci_read_matchline( fid, 'Num',handles ),handles);% blocks/condition
       % handles.b.proto.cond(c).change= bci_read_matchline( fid, 'change',handles );
        for b = 1:handles.b.proto.cond(c).blocks
            handles.b.proto.cond(c).block{b} = str2num( read_no_empty(fid)  ); % volume range
            % set up the feedback array 'data': data( 1:4, 1:volumes )
            % row 1 - condition number // 1 == pause
            handles.b.roi.data( 1, handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2) ) = c;
            % row 2 - block condition within condition
            handles.b.roi.data( 2, handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2) ) = b;
        end
        images=  ( bci_read_matchline( fid, 'Image' ));
        if length(images)>0
             handles.b.proto.reg_images=1;
            rr=strfind(images,';');
            for b = 1:handles.b.proto.cond(c).blocks
                if b==1
                    handles.b.proto.cond(c).images.image_file{b}=[handles.b.proto.images.path,filesep,images(1: rr(b)-1)];
                    [handles.b.proto.cond(c).images.data{b},handles.b.proto.cond(c).images.map{b}]=imread(handles.b.proto.cond(c).images.image_file{b});
                    handles.b.proto.cond(c).images.volume{b}= handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2);
                    handles.b.proto.cond(c).images.count=handles.b.proto.Nr_images;
                    handles.b.proto.cond(c).images.RAM.count=handles.b.proto.Nr_images;
                else
                    if length(rr)>1
                        handles.b.proto.cond(c).images.image_file{b}=[handles.b.proto.images.path,filesep,images(rr(b-1)+1: rr(b)-1)];
                        [handles.b.proto.cond(c).images.data{b},handles.b.proto.cond(c).images.RAM.map{b}]=imread(handles.b.proto.cond(c).images.image_file{b});
                        handles.b.proto.cond(c).images.volume{b}= handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2);
                    else
                        handles.b.proto.cond(c).images.image_file{b}=[handles.b.proto.images.path,filesep,images(1:(rr-1))];
                        [handles.b.proto.cond(c).images.data{b},handles.b.proto.cond(c).images.RAM.map{b}]=imread(handles.b.proto.cond(c).images.image_file{b});
                        handles.b.proto.cond(c).images.volume{b}= handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2);
                        
                    end
                end
            end
            handles.b.proto.cond(c).images.RAM.volume =handles.b.proto.cond(c).images.volume ;
        else
            handles.b.proto.reg_images=0;
        end
        cond_image=  ( bci_read_matchline( fid, 'Cond_img' ));
        if ~isempty(cond_image)
            handles.b.proto.cond_images=1;
            try
                handles.b.proto.cond(c).cond_images.image_file = ['./protocol images',filesep,cond_image] ;
                [handles.b.proto.cond(c).cond_images.data ,handles.b.proto.cond(c).images.RAM.map ]=imread(handles.b.proto.cond(c).cond_images.image_file);
            catch
                handles.b.proto.cond(c).cond_images.image_file = [handles.b.proto.images.path,filesep,cond_image] ;
                [handles.b.proto.cond(c).cond_images.data ,handles.b.proto.cond(c).images.RAM.map ]=imread(handles.b.proto.cond(c).cond_images.image_file);
                
            end
            % handles.b.proto.cond(c).cond_images.volume = handles.b.proto.cond(c).block{b}(1):handles.b.proto.cond(c).block{b}(2);
        else
            handles.b.proto.cond_images=0;
        end
        handles.b.proto.cond(c).color= str2num( bci_read_matchline( fid, 'Color',handles ));
        %     try                        % do we have an override entry for this color ?
        %         handles.b.proto.cond(c).color = proto.colors( c, : );       % then use it...
        %     catch
        %     end
        handles.b.proto.cond(c).color = handles.b.proto.cond(c).color / 255;  % matlabs [0 1] ranges...
        
        %read the protocol image, example: up-arrow, down-arrow, cross-hari etc
        %proto.cond(c).cond_image = bci_read_matchline(fid, 'Image');
    end
    
    % with this freeform data, I cannot know if I read the right thing.
    if feof(fid)    %   but assume that if we hit feof(fid) it's bad...
        fclose(fid);
        error([ 'Reached EOF while reading "' proto.file '". ' ...
            'Your protocol file is broken.' ]);
    end
    
    %
    %condition images information
    % if b
    % folder = bci_read_matchline(fid, 'ConditionImageFolder');
    % str = bci_read_matchline(fid, 'ConditionImageFiles'); %read the whole line containing all the filenames
    % substr = dlmstr(str, '\s'); %split the line read by space delimiter to get individual image file names
    % for i = 1:length(substr)
    %     cond_imagefile = [folder filesep char(substr(i))];
    %     proto.cond(i).cond_image = imread(cond_imagefile);
    %     proto.cond(i).cond_imginfo = imfinfo(cond_imagefile);
    % end
    % end
    %
    %protocol sequence view information to be extracted here
    %Ranga, 21-03-2005
    handles.b.proto.seqview.cond = str2num( bci_read_matchline( fid, 'ConditionSequence',handles ));
    handles.b.proto.seq_length = size(handles.b.proto.seqview.cond, 2); %number of columns
    cur_block(1:handles.b.proto.count) = 0; %initialize the cursor for the condition block as each condition has multiple blocks
    for s = 1:handles.b.proto.seq_length
        cur_cond = handles.b.proto.seqview.cond(s);
        cur_block(cur_cond) = cur_block(cur_cond) + 1; % increment the cursor
        handles.b.proto.seqview.block{s} = handles.b.proto.cond(cur_cond).block{cur_block(cur_cond)};
        handles.b.proto.seqview.color{s} = handles.b.proto.cond(cur_cond).color;
        if handles.b.proto.reg_images
        handles.b.proto.seqview.image_name{s}=handles.b.proto.cond(cur_cond).images.image_file(cur_block(cur_cond));
        end
        if  handles.b.proto.cond_images
            handles.b.proto.seqview.image_cond_name{s}=handles.b.proto.cond(cur_cond).cond_images.image_file(cur_block(cur_cond));
        end
        %  proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    end
     waitbar((handles.b.proto.count)/(handles.b.proto.count+2));
    % proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    % proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    %
    %read in the performance criteria
    %PerformanceCriteria
    handles.b.perf.criteria = str2num( bci_read_matchline( fid, 'PerformanceCriteria',handles ));
    handles.b.perf.regulation=str2num(bci_read_matchline( fid, 'Down_UP_Regulation',handles ));
    handles.b.perf.feedback_con_del=str2num(bci_read_matchline( fid, 'Feedback_con_del',handles ));
    handles.b.perf.reward_seq=str2num(bci_read_matchline( fid, 'Reward_sequence',handles ));
    if sum(handles.b.perf.reward_seq)>0
        ini=1;
        for ii=1:length(handles.b.perf.reward_seq)
            if handles.b.perf.reward_seq(ii)>0
               handles.b.proto.seqview.reward_TR(ini)=handles.b.proto.seqview.block{ii}(1);
               ini=ini+1;
            end
        end
    end
    handles.b.roi.volumes_skip=str2num(bci_read_matchline( fid, 'NrOfVolumeToSkip' ,handles));
    handles.b.roi.volumes=str2num(bci_read_matchline( fid, 'NrOfVolumes',handles ));
  %  if strcmp(handles.b.session_type,'Dummy Functional Run')|| ~handles.b.flag.isnormalization || strcmp(handles.b.session_type,'')
     handles.b.pre.column_init=str2num(bci_read_matchline( fid, 'NrOfColumns',handles ));
     handles.b.pre.row_init=str2num(bci_read_matchline( fid, 'NrOfRows',handles ));
   % end
    handles.b.roi.count_str=(bci_read_matchline( fid, 'ROI_count',handles ));
    handles.b.roi.count=str2num(handles.b.roi.count_str); %#ok<*ST2NM>
    handles.b.roi.background='k';
    handles.b.pre.motion_artifact_trans_mm=str2num(bci_read_matchline( fid, 'Motion_translation_threshold',handles )); %#ok<ST2NM>
    handles.b.pre.motion_artifact_degree=str2num(bci_read_matchline( fid, 'Motion_degree_threshold',handles )); %#ok<ST2NM>
    handles.b.pre.correl_window=str2num(bci_read_matchline( fid, 'Correl_window',handles )); %#ok<ST2NM>
    handles.b.roi.TR=str2num(bci_read_matchline( fid, 'Repetition_Time',handles )); %#ok<ST2NM>
    fclose(fid);
    waitbar((handles.b.proto.count+1)/(handles.b.proto.count+2));
    %%%%%%% reading information for blocks for the  behind line graphs
    
    fid = fopen( handles.b.conf.current_proto_block_file , 'rt');
    handles.b.proto.line_graph.block_count = str2num( bci_read_matchline( fid, 'Num_cond_Block',handles ));
    
    for ii=1:handles.b.proto.line_graph.block_count
        
        handles.b.proto.line_graph.block(ii).name=bci_read_matchline( fid, 'Block',handles );
        n=str2num( bci_read_matchline( fid, 'Num' ));
        for in=1:n
            handles.b.proto.line_graph.block(ii).TRs{in} = str2num( read_no_empty(fid)  ); % volume range
        end
        
        handles.b.proto.line_graph.block(ii).color=bci_read_matchline( fid, 'Color',handles );
        
    end
    handles.b.proto.line_graph.seqview = str2num( bci_read_matchline( fid, 'seqview',handles ));
    handles.b.proto.line_graph.seq_length = size(handles.b.proto.line_graph.seqview, 2); %number of columns
    cur_block(1:handles.b.proto.line_graph.block_count) = 0;
    for s = 1:handles.b.proto.line_graph.seq_length
        cur_cond = handles.b.proto.line_graph.seqview(s);
        cur_block(cur_cond) = cur_block(cur_cond) + 1; % increment the cursor
        handles.b.proto.line_graph.seqview_block{s} = handles.b.proto.line_graph.block(cur_cond).TRs{cur_block(cur_cond)};
        handles.b.proto.line_graph.seqview_color{s} = str2num(handles.b.proto.line_graph.block(cur_cond).color)/255;
        %  proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    end
    fclose (fid);
    waitbar((handles.b.proto.count+2)/(handles.b.proto.count+2));
    close(h)
catch ME
    handles=error_log_display(handles,ME);
end
%_______________________________________________________________________
function value = read_no_empty( fid )
while ~feof(fid)
    value = deblank( fgetl(fid));
    if ~isempty(value)
        return
    end
end
%_______________________________________________________________________

