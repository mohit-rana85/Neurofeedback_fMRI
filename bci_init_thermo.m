function varargout = bci_init_thermo( background,handles)
%BCI_INIT_THERMO - initialize figure window for data display
%   use existing active figure window, so user can rely on window position
%   calculate dimensions of common protocol & data axes, return if needed

% 
% v0.2  2003-05-06  Simon Bock <sbock@uni-tuebingen.de>    

%Axes dimensions; note these values are changed again in draw_thermo()
% thermo_ax.l = 0.4;
% thermo_ax.b = 0.05; 
% thermo_ax.w = 0.2;
% thermo_ax.h = 0.4;
try
  thermo_ax.l = 0.4;
  thermo_ax.b = 0.2;
  thermo_ax.w = 0.2;
  thermo_ax.h = 0.6;
magic.window_size = [ 232 300 560 350 ];% my default "Figure Win Position"

%_______________________________________________________________________
% read optional Window Position data, use default if not in 'master.bci'
if nargout
%    window_size = str2num( bci_read( master_bci, 'Window', 2 ) );
 %   if isempty( window_size )
        window_size = magic.window_size;
  %  end
    h = gcf;
    window_oldUnits = get( h,'Units');      % remember this...
    set( h,'Units','Pixels');
    set( h,'Position', window_size);
    set( h, 'Units', window_oldUnits);      % restore window properties
end
%_______________________________________________________________________
delete( get(gcf, 'Children') );         % clear all existing contents

set( gcf, 'MenuBar', 'none');           % unneeded; unwanted brightness

set( gcf, 'BackingStore', 'off');           % schneller
set( gcf, 'Color', background );
%set( gcf, 'Colormap', '');
set( gcf, 'RendererMode', 'manual');    % für 'DoubleBuffer'
set( gcf, 'Renderer', 'painters');      % für 'DoubleBuffer'
set( gcf, 'DoubleBuffer', 'on');        %  sonst flackert es !!
%set( gcf, 'ShareColors', 'off');            % genau meine Farben
set( gcf, 'MinColormap', length(get(gcf,'ColorMap')) ); % nett zum System

%_______________________________________________________________________

if nargout == 1
    varargout(1) = {thermo_ax};
end
catch ME
    handles=error_log_display(handles,ME);
end