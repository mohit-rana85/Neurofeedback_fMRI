function b = init_datastruct(b,handles)
% Initialize main data struct 'b': collect information from config-files.


% Unfortunately, can use _only_ the TBV Config, all other interesting
%   files are not created until TBV is finished ( *.fmr, *.roi )
% use the *.fmr file name from it as base: assume all TBV files are the same
try
    b.basename = bci_read( b.conf.tbv, 'ProjectName', 1 );  % to add '_plots.ert'
    b.basename = b.basename( 2:end -1 );            % text was in "..." spaces
    [b.folder,b.basename] = fileparts( b.basename );        % TBV basename
    b.folder = bci_read( b.conf.tbv, 'TargetFolder', 1 );   % TBV output dir
    b.folder = b.folder( 2:end -1 );                % text was in "..." spaces
    b.roi.volumes = bci_str2int( bci_read( b.conf.tbv, 'NrOfVolumes', 1 )) - ...
        bci_str2int( bci_read( b.conf.tbv, 'NrOfVolumesToSkip', 1 ));
    b.roi.volumes_skip= bci_str2int( bci_read( b.conf.tbv, 'NrOfVolumesToSkip', 1 ));
    b.roi.columns= bci_str2int( bci_read( b.conf.tbv, 'NrOfColumns', 1 ));
    b.roi.rows= bci_str2int( bci_read( b.conf.tbv, 'NrOfRows', 1 ));
    
    b.roi.TR= (  bci_str2int( bci_read( b.conf.tbv, 'TR', 1 ))/1000);
    b.proto.file = bci_read( b.conf.tbv, 'StimulationProtocol', 1 );    % *.prt file
    b.proto.file = b.proto.file( 2:end-1 ); %to remove the double quotes
    % if given, override colors given in the *.prt file (#1: cond1, #2: cond2, ...)
    %b.proto.colors = str2num( bci_read( b.conf.bci, 'ConditionColors', 2 ));
    % use this vector to calculate sum of ROI data averages (1 = +100%)
    b.roi.count = str2num( bci_read( b.conf.bci, 'ROI_Count',0));
    % expect ROI data (='_plots.ert') file name to be this
    b.roi.file = fullfile( b.folder, [b.basename '_plots.ert']);
    % get mean and standard deviation from block x of first condition (= pause)
    %   ROI should be drawn now and optional localizer blocks ended - default=second
    b.roi.baseline = bci_str2int( bci_read( b.conf.bci, 'BaselineBlock', '2' ));
    b.roi.line = str2num( bci_read( b.conf.bci, 'LineColor', '255 255 0'));% def=y
    b.roi.line = b.roi.line / 255;              % matlab likes the [0 1] ranges...
    b.roi.stddev = str2num( bci_read( b.conf.bci, 'StdDevColor', '200 200 0'));
    b.roi.stddev = b.roi.stddev / 255;          % matlab likes the [0 1] ranges...
    b.roi.background = str2num( bci_read( b.conf.bci, 'Background', '0 0 0'));
    b.roi.background = b.roi.background / 255;  % matlab likes the [0 1] ranges...
    
    return;
catch ME
    handles=error_log_display(handles,ME);
end