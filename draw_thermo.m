function handles = draw_thermo(handles)
%function that handles drawing the thermometer
%input args: max number of grads and color
%the sequence of actions:
%draw_thermo, update_thermo, delete_thermo, delete_frame
%returns ax with the handles too
%global constants
try

%assign arguments passed

handles.b.ui.thermo.color = 'k';


%last graphic objects drawn

handles.b.ui.last_gobjects.update = 0; %initialization before an update
handles.b.ui.last_gobjects.thermo = 0;
handles.b.ui.last_gobjects.image = 0;

% last_gobjects.thermo -  the entire list of thermo objects drawn last
% last_gobjects.update - the update last made, to be deleted before every new update
% last_gobjects.fh - last figure handle; later write a function for deleting figure

%Set current axes depending on whether localizer images need to be
%displayed or not; if images are displayed the screen is divided to set two
%axes one below the other.
%NOTE that setting axes currently is done in too many placed! This needs a
%bit of cleaning up! Ranga.
if handles.b.ui.image ~= 0
    %     ui.thermo_ax.l = 0.4;
    %     ui.thermo_ax.b = 0.05;
    %     ui.thermo_ax.w = 0.2;
    %     ui.thermo_ax.h = 0.4;
  
else
    handles.b.ui.thermo_ax.l = 0.4;
    handles.b.ui.thermo_ax.b = 0.2;
    handles.b.ui.thermo_ax.w = 0.2;
    handles.b.ui.thermo_ax.h = 0.6;
end

%thermo centerline coords
%all these dimensions are with respect (ax.l,ax.b) as the origin (0,0)
f.cx = handles.b.ui.thermo_ax.w/2;
f.cy = handles.b.ui.thermo_ax.h/2;
cl.X = [0 handles.b.ui.thermo_ax.w]; %dotted center line
cl.Y = [handles.b.ui.thermo_ax.h/2 handles.b.ui.thermo_ax.h/2];
cl.linestyle = '--'; %dashed line
cl.color = [1 0 0]; %white line on black background

%thermo dimensions
handles.b.ui.thermo.ho = handles.b.ui.thermo_ax.h; %thermo outside box height
handles.b.ui.thermo.wo = handles.b.ui.thermo_ax.w;
t = handles.b.ui.thermo_ax.w*0.25; %gap between outer and inner boxes of thermo
handles.b.ui.thermo.hi = handles.b.ui.thermo.ho - 2*t;
handles.b.ui.thermo.wi = handles.b.ui.thermo.wo - 2*t;

%set the current fig and axes
figure(handles.b.figures.feedback_fig ); %set the current figure
if handles.b.flag.isShaping
    if handles.b.proto.cond_images
        handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', 'k'); %background of the axes
    else
        handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', handles.b.ui.backcolor); %background of the axes
        
    end
    
    
    
else
    handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', handles.b.ui.thermo_color); %background of the axes
    handles.b.ui.proto = handles.b.ui.thermo_ax.handle; %this handle is checked in bci_results, but needs to be cleaned up
    
    %outside outline of thermo
    handles.b.ui.thermo.Xo = [(f.cx-handles.b.ui.thermo.wo/2) (f.cx+handles.b.ui.thermo.wo/2) (f.cx+handles.b.ui.thermo.wo/2) (f.cx-handles.b.ui.thermo.wo/2)]; %in anticlockwise direction
    handles.b.ui.thermo.Yo = [(f.cy-handles.b.ui.thermo.ho/2) (f.cy-handles.b.ui.thermo.ho/2) (f.cy+handles.b.ui.thermo.ho/2) (f.cy+handles.b.ui.thermo.ho/2)];
    
    %inside outline of thermo
    handles.b.ui.thermo.Xi = [(f.cx-handles.b.ui.thermo.wi/2) (f.cx+handles.b.ui.thermo.wi/2) (f.cx+handles.b.ui.thermo.wi/2) (f.cx-handles.b.ui.thermo.wi/2)]; %in anticlockwise direction
    handles.b.ui.thermo.Yi = [(f.cy-handles.b.ui.thermo.hi/2) (f.cy-handles.b.ui.thermo.hi/2) (f.cy+handles.b.ui.thermo.hi/2) (f.cy+handles.b.ui.thermo.hi/2)];
    
    % %draw the thermometer both outside and inside outlines
    handles.b.ui.last_gobjects.thermo(1) = patch(handles.b.ui.thermo.Xo, handles.b.ui.thermo.Yo, handles.b.ui.thermo.color);
    handles.b.ui.last_gobjects.thermo(2) = patch(handles.b.ui.thermo.Xi, handles.b.ui.thermo.Yi, [1 1 1]);
    
    
end
%draw the centerline
handles.b.ui.last_gobjects.thermo(3) = line(cl.X, cl.Y, 'LineStyle', cl.linestyle, 'Color',  cl.color);
if  handles.b.proto.cond_images
    %compute the coords of the condition image
    handles.b.ui.img.w = 0.1;
    handles.b.ui.img.h = 0.15;
    handles.b.ui.img.x = handles.b.ui.thermo_ax.l + handles.b.ui.thermo_ax.w*1.2;
    handles.b.ui.img.y = handles.b.ui.thermo_ax.b  + handles.b.ui.thermo_ax.h/2 - handles.b.ui.img.h/2;
    handles.b.ui.img.axhandle = axes('Position', [handles.b.ui.img.x handles.b.ui.img.y handles.b.ui.img.w handles.b.ui.img.h], 'Color', handles.b.ui.thermo_color);
    axis off; %Modification_RANGA_Mar17_2006
    last_gobjects.thermo(4) = handles.b.ui.thermo_ax.handle; %you should delete the image handle too later on
    last_gobjects.thermo(5) = handles.b.ui.img.axhandle;
end
if handles.b.flag.isref_zero
    aa=1;
else
    aa=2;
end
%call the function that computes the coords of all the max grads and stores it
handles=create_grads(handles.b.figures.feedback_fig, handles.b.ui, fix(handles.b.ui.thermo_grads/aa), 1,handles,aa); %the second argument forces creation for the first time

status = 1;

thermo_ax = handles.b.ui.thermo_ax;
set(gcf, 'Color', handles.b.ui.thermo_color); %Modification_RANGA_Mar17_2006
axis off; %Modification_RANGA_Mar17_2006
return;

catch ME
    handles=error_log_display(handles,ME);
end