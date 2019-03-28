function [ data, proto, perf ] = bci_protocol( proto, base,b,handles)
%BCI_PROTOCOL Read stimulation protocol & display it to subject

% feedback array 'data' will be set up with stimulation protocol conditions
%   column1: condition nr. // column2: block nr. within condition
%   - read from 'filename'.
% new fields of proto are
%   .count      - number of conditions
%   .cond( count ).???  - .color, .blocks
%               // should all be read from *.prt file, not hardcoded //
%
% v0.4  2003-04-11  Simon Bock <sbock@uni-tuebingen.de>

%bci_ui_wait( proto.file ); % wait until regular file is there
try
    if ~exist(proto.file) %#ok<EXIST>
        proto.file =[b.conf.master_dir,filesep, 'feedback.prt'];
    end
    fid = fopen( proto.file, 'rt');   % text mode (matlab does the '\r\n' stuff)
    
    % I could read the 'NrOfConditions' with bci_read(), but I have no way of
    %   knowing where my condition data (unfortunately all in free form) starts.
    proto.count = bci_str2int( bci_read_matchline( fid, 'NrOfConditions' ));
    % So I assume it starts just after the 'NrOfConditions' entry ;-) // danger //
    for c = 1:proto.count
        proto.cond(c).name = read_no_empty(fid);                % just to check //
        proto.cond(c).blocks = bci_str2int( read_no_empty(fid));% blocks/condition
        for b = 1:proto.cond(c).blocks
            proto.cond(c).block{b} = str2num( read_no_empty(fid) ); % volume range
            % set up the feedback array 'data': data( 1:4, 1:volumes )
            % row 1 - condition number // 1 == pause
            data( 1, proto.cond(c).block{b}(1):proto.cond(c).block{b}(2) ) = c;
            % row 2 - block condition within condition
            data( 2, proto.cond(c).block{b}(1):proto.cond(c).block{b}(2) ) = b;
        end
        
        proto.cond(c).color= str2num( bci_read_matchline( fid, 'Color' ));
        try                        % do we have an override entry for this color ?
            proto.cond(c).color = proto.colors( c, : );       % then use it...
        catch
        end
        proto.cond(c).color = proto.cond(c).color / 255;  % matlabs [0 1] ranges...
        
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
    proto.seqview.cond = str2num( bci_read_matchline( fid, 'ConditionSequence' ));
    proto.seq_length = size(proto.seqview.cond, 2); %number of columns
    cur_block(1:proto.count) = 0; %initialize the cursor for the condition block as each condition has multiple blocks
    for s = 1:proto.seq_length
        cur_cond = proto.seqview.cond(s);
        cur_block(cur_cond) = cur_block(cur_cond) + 1; % increment the cursor
        proto.seqview.block{s} = proto.cond(cur_cond).block{cur_block(cur_cond)};
        proto.seqview.color{s} = proto.cond(cur_cond).color;
        %  proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
        
    end
    % proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    % proto.seqview.cond_image{s} = proto.cond(cur_cond).cond_image;
    %
    %read in the performance criteria
    %
    handles.b.perf.criteria = str2num( bci_read_matchline( fid, 'PerformanceCriteria' ));
    handles.b.perf.regulation=str2num(bci_read_matchline( fid, 'Down_UP_Regulation' ));
    handles.b.perf.feedback_con_del=str2num(bci_read_matchline( fid, 'Feedback_con_del' ));
    handles.b.roi.volumes_skip=str2num(bci_read_matchline( fid, 'NrOfVolumeToSkip' ));
    handles.b.roi.volumes=str2num(bci_read_matchline( fid, 'NrOfVolumes' ));
    handles.b.pre.column=str2num(bci_read_matchline( fid, 'NrOfColumns' ));
    handles.b.pre.row=str2num(bci_read_matchline( fid, 'NrOfRows' ));
    handles.b.roi.count_str=(bci_read_matchline( fid, 'ROI_count' ));
    handles.b.roi.count=str2num(handles.b.roi.count_str);
    handles.b.pre.motion_artifact_trans_mm=str2num(bci_read_matchline( fid, 'Motion_translation_threshold' ));
    handles.b.pre.motion_artifact_degree=str2num(bci_read_matchline( fid, 'Motion_degree_threshold' ));
    handles.b.pre.correl_window=str2num(bci_read_matchline( fid, 'Correl_window' ));
    handles.b.roi.TR=str2num(bci_read_matchline( fid, 'Repetition_Time' ));
    fclose(fid);
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

