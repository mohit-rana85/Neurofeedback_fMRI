function [handles,status] = bci_generator_no_TBV(handles)
try
    h = waitbar(0,'Please wait...');
    %test whether the .mat file for the experiment already exists
    if strcmp(handles.b.session_type,'Localizer Collect Data')||strcmp(handles.b.session_type,'Localizer Analysis')
        aa=[]; aa=dir([handles.b.conf.master_dir,filesep,'*localizer.prt']);
        handles.b.conf.current_proto_file=[handles.b.conf.master_dir,filesep, aa.name];
        aa=[]; aa=dir([handles.b.conf.master_dir,filesep,'*localizer.blocks']);
        handles.b.conf.current_proto_block_file=[handles.b.conf.master_dir,filesep,aa.name];
        close(h);
    else
        handles.b.conf.current_proto_file = fullfile(handles.b.conf.target_subj_path,sprintf('%s-%i.prt', handles.b.conf.exp_name, handles.b.conf.neuro_run_num) );
        handles.b.conf.current_proto_block_file=fullfile(handles.b.conf.master_dir,'feedback.blocks');
        
        % if exist( handles.b.conf.current_proto_file,'file' ) == 2
        %     msgbox()
        %     status=0;
        %     return
        % end
        fid_image_stim=fopen([handles.b.conf.master_dir, filesep,sprintf('Run_%02i.txt',handles.b.conf.neuro_run_num)],'rt');
        i1=0;change=0;
        while 1
            tline=fgetl(fid_image_stim);
            if tline==-1
                clear tline
                break;
            end
            if ~isempty(deblank(tline))
                i1=i1+1;
                handles.b.proto.stim_images{i1}=tline;
            end
            
        end
        waitbar(1/5);
        fid_in = fopen( [handles.b.conf.master_dir, filesep, handles.b.conf.exp_name '.prt'], 'rt' );
        fid_out = fopen( handles.b.conf.current_proto_file, 'wt' );
        %Replace values specific to the current experiment in the TBV file
        images_nr=0;xx=0;ii1=1;
        while 1
            tline=fgetl(fid_in);
            if tline==-1
                clear tline
                break;
            end
            
            if ~isempty(deblank(tline))
                if strcmp(tline(1:4),'Imag')
                    new_text='';ii1=ii1+1;waitbar(ii1/10);
                    if length(handles.b.proto.stim_images)>=images_nr+blocks && change
                        for ii=images_nr+1:images_nr+blocks
                            new_text=[new_text,handles.b.proto.stim_images{ii},';'];
                        end
                        images_nr=images_nr+blocks;
                    elseif ~change
                        new_text=tline(strfind(tline,':')+1:end);
                    elseif length(handles.b.proto.stim_images)==blocks && change
                        for ii=1:blocks
                            new_text=[new_text,handles.b.proto.stim_images{ii},'.jpg ;'];
                        end
                    else
                        new_text='';
                    end
                    fprintf(fid_out, '%s\n',  ['Image: ',new_text] ); change=0;
                elseif strcmp(tline(1:3),'Num')
                    blocks=str2num(tline(strfind(tline,':')+1:end));
                    fprintf(fid_out, '%s\n', tline);
                elseif strcmp(tline(1:3),'cha')
                    change=str2num(tline(strfind(tline, ':')+1:end));
                else
                    fprintf(fid_out, '%s\n', tline);
                    
                end
            end
        end
        close(h);
        fclose( fid_in );
        fclose( fid_out );
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'Generation of config file complete.' ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    status=1;
    return
catch ME
    handles=error_log_display(handles,ME);
end
% %_______________________________________________________________________
% function copy( from, to ) % 1) check for existence, 2) force b/o mapped drive
% if exist(from) ~= 2
%     error(['File "' from '" does not exist.']);
% end
% if exist(to) ~= 0 & exist(to) ~= 7      % misses if target spec is a folder
%     disp(['File "' to '" already present, using existing copy.']);
% else
%     copyfile( from, to, 'f' );  % force: mapped drive is "write protect" (?)
% end
% return

% %_______________________________________________________________________
% function bci_write_matchline( fid_in, fid_out, field, new )
% % BCI_WRITE_MATCHLINE Copy lines from fid_in to fid_out until found "field:"
% %   In this case ignore line, write out "field: new" instead.
% len = length(field);
% while ~feof(fid_in)
%     line = fgetl(fid_in);
%     if strncmp( line, [field ':'], len +1 )         % if found NameTag:
%         c = min( find( ~isspace(line(len+2:end)) ) );     % find first nonspace
%         fprintf(fid_out, '%s%s\n', line(1:c+len), new );  % write out new value
%         break
%     else
%         fprintf(fid_out, '%s\n', line);             % else copy full line
%     end
% end
