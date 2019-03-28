function [conf,status] = bci_generator(sub_name,exp_name,run_num,master_dir,watch_dir,target_dir,output_dir,rootpath)

% THIS VERSION SUPPORTS VB15

%initialize the conf again for returning at the end
conf.sub_name = sub_name;
conf.exp_name = exp_name;
conf.run_num = run_num;
conf.master_dir = master_dir;
conf.watch_dir = watch_dir;
conf.target_dir = target_dir;
conf.output_dir=output_dir;
conf.rootpath=rootpath;
conf.master = [master_dir filesep 'master.bci'];  

%create the target sub dir where the experiemntal results will be placed
conf.target_subname = [target_dir filesep sub_name filesep];
fprintf('\nTarget sub directory is: %s\n', conf.target_subname);
makedir(conf.target_subname); %make the first level of the target directory

%test whether the .mat file for the experiment already exists
conf.name = fullfile(conf.target_subname,sprintf('%s-%i', exp_name, run_num) );
if exist([conf.name '.mat']) == 2
    return
end

%copy the .prt file from the master dir to the target_subdir
conf.prt = [conf.name '.prt'] ;
copy( [master_dir filesep exp_name '.prt'], conf.prt);
conf.exp_num = sprintf( '%s%04i', exp_name, run_num );
conf.full_targetdir = [conf.target_subname];
makedir( conf.full_targetdir );            % 1) absolute path, 2) OK, shouldn't exist

%copy the .bci file
conf.master_bci = [master_dir filesep exp_name '.bci'];
conf.bci = [conf.name '.bci'];
copy(conf.master_bci, conf.bci);            %  copy to new name

%copy the .tbv file too
conf.tbv = [conf.name '.tbv' ];                % TBV config file
bci_read(conf.bci, 'TBV_Config', conf.tbv);        % // default TBV config file
 
%watch_subdir = []; %sprintf( '%s%04i', 'Ser', run_num );
%Until here is for the TRIO - RANGA

%create the subdirectory for the current series under the watch directory
% watch_subdir=[watch_dir filesep watch_subdir];
% makedir(watch_subdir); 

if exist( conf.tbv ) ~= 0
    disp(['\nFile "' conf.tbv '" already present, using existing copy.']);
    msgbox([ conf.tbv ' already present, Please check  the run number.'], 'Warning');
    status=0;
    return
else
 fid_in = fopen( [master_dir filesep exp_name '.tbv'], 'rt' );
 fid_out = fopen( conf.tbv, 'wt' );
 %conf.full_watchdir = [watch_dir];
 fprintf('\n\tTBV Watch  = %s\n\tTBV Target = %s\n', conf.full_watchdir, conf.full_targetdir);
 
 %Replace values specific to the current experiment in the TBV file
 bci_write_matchline( fid_in, fid_out, 'Title', ['"' exp_name '"'] );
 bci_write_matchline( fid_in, fid_out, 'WatchFolder', [ '"' conf.full_watchdir '"'] );
 bci_write_matchline( fid_in, fid_out, 'TargetFolder', [ '"' conf.full_targetdir '"']);
 bci_write_matchline( fid_in, fid_out, 'FirstFileName', [ '"' conf.firstFileName '"']);
 bci_write_matchline( fid_in, fid_out, 'DicomFirstVolumeNr', num2str(run_num));
 bci_write_matchline( fid_in, fid_out, 'SlicePrefix', ['"' conf.exp_num '-"'] );
 bci_write_matchline( fid_in, fid_out, 'ProjectName', ['"' conf.exp_num  '.fmr"']);
 bci_write_matchline( fid_in, fid_out, 'StimulationProtocol', ['"' conf.prt '"']);
 bci_write_matchline( fid_in, fid_out, 'FeedbackTargetFolder', [ '"' conf.full_targetdir '"']);
 bci_write_matchline( fid_in, fid_out, '', '' ); % // copy rest of lines //
 fclose( fid_in );
 fclose( fid_out );
end

fprintf('\nGeneration of config files complete. Now you could modify:\n');
d = dir( [conf.name '.*'] );
d = {d.name};
fprintf(['\t' strrep([conf.target_subname],'\','\\') '%s\n'], d{:} );   % de-ESC
fprintf('to fit your specific needs.\n');
status=1;
return

%_______________________________________________________________________
function copy( from, to ) % 1) check for existence, 2) force b/o mapped drive
if exist(from) ~= 2
    error(['File "' from '" does not exist.']);
end
if exist(to) ~= 0 & exist(to) ~= 7      % misses if target spec is a folder
    disp(['File "' to '" already present, using existing copy.']);
else
    copyfile( from, to, 'f' );  % force: mapped drive is "write protect" (?)
end
return

%_______________________________________________________________________
function bci_write_matchline( fid_in, fid_out, field, new )
% BCI_WRITE_MATCHLINE Copy lines from fid_in to fid_out until found "field:"
%   In this case ignore line, write out "field: new" instead.
len = length(field);
while ~feof(fid_in)
    line = fgetl(fid_in);
    if strncmp( line, [field ':'], len +1 )         % if found NameTag:
        c = min( find( ~isspace(line(len+2:end)) ) );     % find first nonspace
        fprintf(fid_out, '%s%s\n', line(1:c+len), new );  % write out new value
        break
    else
        fprintf(fid_out, '%s\n', line);             % else copy full line
    end
end
