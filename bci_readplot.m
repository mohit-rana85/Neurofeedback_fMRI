function [eff_roi, position1,prt] = bci_readplot(fid, timepoint, roi, prt,handles)
%This function returns the effective ROI computed from
%the _plots.ert file (produced by the TBV)
%for the timepoint specified; prt is the proto structure.
%Example: eff_roi = readplot(timepoint, roi, prt)
try
global PAUSE_VAL;
magic.noinsturction = 1;        % condition under feedback screen
magic.debug = 1;

%_______________________________________________________________________
%initialization/configuration
magic.plotdata = 1;
roi1=0;roi2=0; %initialize

eff_roi = 0; %initialize
gotcha_flag = 0; %eff_roi not found = 0, found = 1

% for detecting "the falling edge of the BaselineBlock signal" // better way ? //
last.plot = 0;      % = plot() - did we draw yet ? and clean up old line object.
last.is_base = 0;   % 0: outside BaselineBlock; 1: inside - logical/bool
last.roi_err = 0;   % is TBV ROI output # ~= # of elements in calc. vector ?

base = prt.cond(1).block{roi.baseline}(1);   % first volume of baseline block
pause on;                       % have to enable the delay...

while(1)
    %read volume data for each time point within the view
    tic;
    position1 = ftell(fid); %remember position
    volume = read_waitnoui(fid, 'TimePoint');  % volume number
    
    %continue to obtain more information if volume is equal to the required
    %time point
    if(volume == timepoint)
        count = read_waitnoui(fid, 'NrOfROIs');  % ROI count, '0' == no ROI yet
        if(magic.debug == 1)
            fprintf('NrOfROIs : %d\n', count); %for debug
        end
        if count > 0    % at least one ROI found, so read its data
            
            for r = 1:count       % cycle through ROIs
                roinum = read_waitnoui(fid, 'ROI');          % ROI from .ert file
                if(magic.debug == 1)
                    fprintf('ROI number : %d\n', roinum); %for debug
                end
                if r ~= roinum
                    fclose(fid);
                    error(['Something strange happened: expected ROI ' num2str(r) ', got ROI ' num2str(roinum) '.']);
                end
                
                avg_value = read_waitnoui(fid, 'AvgValue');      % mean data
                if(magic.debug == 1)
                    fprintf('ROI Value : %3.6f\n', avg_value); %for debug
                end
                
                % row 4 - ROI data value to the position 'volume' in array...
                prt.seqview.data( magic.plotdata+r, volume ) = avg_value; % save ROIs individual data as well
            end
            
            if count < length(roi.count) & ~last.roi_err
                if(magic.debug == 1)
                    fprintf(['Not enough ROIs\t\t from volume %3i (%i ROI in TBV'...
                        ', %i ROI expected)\n'],volume,count,length(roi.count) );
                end
                
                beep;
                last.roi_err = 1;
            elseif count > length(roi.count)
                if ~last.roi_err
                    if(magic.debug == 1)
                        fprintf(['Ignoring surplus ROI from volume %3i (%i ROI in '...
                            'TBV, %i ROI expected)\n'],volume,count,length(roi.count) );
                    end
                    last.roi_err = 1;
                end
                count = length(roi.count);
            elseif last.roi_err & count == length(roi.count)
                if(magic.debug == 1)
                    fprintf(['\t\t\t\t\t   to volume %3i (%i ROI read OK).\n'],...
                        volume,count );
                end
                last.roi_err = 0;
            end
        end
        
        %calculate effective ROI using the contrast
        if count == length(roi.count)
            if ~ max( prt.seqview.data(magic.plotdata+1:magic.plotdata+count, volume) == 0)
                prt.seqview.data(magic.plotdata,volume) = sum( ...  % sum up data weighted by roi.count vector
                    prt.seqview.data( magic.plotdata+1:magic.plotdata+count, volume) .* roi.count' );
                eff_roi = prt.seqview.data(magic.plotdata,volume);
                gotcha_flag = 1;
                if(magic.debug == 1)
                    fprintf('Effective ROI Value : %3.6f\n', prt.seqview.data(magic.plotdata,volume)); %for debug
                    
                end
                pause(PAUSE_VAL);
                return; %come out of the function
            end
        end
        
    elseif (volume > timepoint) %if the volume currently read is greater than the timepoint required..some problem!
        if(magic.debug == 1)
            fprintf('\nERROR: no data available for timepoint = %d!\n', timepoint);
        end
        return;
    end %end of if (volume == time point)
    
end %end of while loop

if(gotcha_flag == 0)
    fprintf('\nERROR: no data available for timepoint = %d!\n', timepoint);
end

%if it has reached here, it means effective roi was not computed
%successfully, so make eff_roi = 0
eff_roi = 0;

return
catch ME
    handles=error_log_display(handles,ME);
end

%_______________________________________________________________________
function value = read_waitnoui( fid, field)  % wait if value not there yet

while(1)
    position = ftell(fid);  % remember position to resume to on EOF
    value = str2double( bci_read_matchline( fid, field) );
    if feof(fid)            % better re-read if it was the last line
        %fprintf('\nPROBLEM: End of file encountered!\n\n');
        fseek( fid, position, 'bof');  % 'bof': relative to start
        t=toc;              % how much time has elapsed ?
        if t < 0.1          %   0.1 == WAITTIME Schleifenmindestdauer
            pause(0.1-t)    %   0.1 == WAITTIME Schleifenmindestdauer
        end
        tic;                % get a new time indicator...
    else
        return;             % everything in order...
    end
end
