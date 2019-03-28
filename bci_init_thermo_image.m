function handles=bci_init_thermo_image(handles)
%global constants
try
    
    window_size = [232 300 760 450 ];
    %  end
    h = gcf;
    window_oldUnits = get( h,'Units');      % remember this...
    set( h,'Units','Pixels');
    set( h,'Position', window_size);
    set( h, 'Units', window_oldUnits);
    
    delete( get(gcf, 'Children') );         % clear all existing contents
    
    set( gcf, 'MenuBar', 'none');           % unneeded; unwanted brightness
    
    set( gcf, 'BackingStore', 'off');           % schneller
    set( gcf, 'Color', 'k');
    %set( gcf, 'Colormap', '');
    set( gcf, 'RendererMode', 'manual');    % für 'DoubleBuffer'
    set( gcf, 'Renderer', 'painters');      % für 'DoubleBuffer'
    set( gcf, 'DoubleBuffer', 'on');        %  sonst flackert es !!
    %set( gcf, 'ShareColors', 'off');            % genau meine Farben
    set( gcf, 'MinColormap', length(get(gcf,'ColorMap')) ); % nett zum System
    %assign arguments passed
    
    handles.b.ui.thermo.color =  handles.b.ui.thermo_color;
    handles.b.ui.backcolor = 'k';
    
    %last graphic object
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
    if handles.b.proto.Nr_images > 0
        handles.b.ui.thermo_ax.l = 0.78;
        handles.b.ui.thermo_ax.b = 0.3;
        handles.b.ui.thermo_ax.w = 0.2;
        handles.b.ui.thermo_ax.h = 0.4;
    else
        handles.b.ui.thermo_ax.l = 0.4;
        handles.b.ui.thermo_ax.b = 0.2;
        handles.b.ui.thermo_ax.w = 0.2;
        handles.b.ui.thermo_ax.h = 0.6;
    end
    figure(handles.b.figures.feedback_fig );
    % handle.b.ui.thermo_panel=uipanel('BackgroundColor','w','HighlightColor','k','BorderType','none','position',[handles.b.ui.thermo_ax.l,handles.b.ui.thermo_ax.b,handles.b.ui.thermo_ax.w,handles.b.ui.thermo_ax.h]);
    % uistack(handle.b.ui.thermo_panel,'bottom')
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
    %set the current figure
    if handles.b.flag.isShaping
        if handles.b.proto.cond_images
            handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', 'k'); %background of the axes
        else
            handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', handles.b.ui.backcolor); %background of the axes
            
        end
        handles.b.ui.thermo.Xo = [(f.cx-handles.b.ui.thermo.wo) (f.cx+handles.b.ui.thermo.wo) (f.cx+handles.b.ui.thermo.wo) (f.cx-handles.b.ui.thermo.wo)]; %in anticlockwise direction
        handles.b.ui.thermo.Yo = [(f.cy-handles.b.ui.thermo.ho) (f.cy-handles.b.ui.thermo.ho) (f.cy+handles.b.ui.thermo.ho) (f.cy+handles.b.ui.thermo.ho)];
        
        %inside outline of thermo
        handles.b.ui.thermo.Xi = [(f.cx-handles.b.ui.thermo.wi) (f.cx+handles.b.ui.thermo.wi) (f.cx+handles.b.ui.thermo.wi) (f.cx-handles.b.ui.thermo.wi)]; %in anticlockwise direction
        handles.b.ui.thermo.Yi = [(f.cy-handles.b.ui.thermo.hi) (f.cy-handles.b.ui.thermo.hi) (f.cy+handles.b.ui.thermo.hi) (f.cy+handles.b.ui.thermo.hi)];
        
        
        
    else
        handles.b.ui.thermo_ax.handle = axes('Position', [handles.b.ui.thermo_ax.l handles.b.ui.thermo_ax.b handles.b.ui.thermo_ax.w handles.b.ui.thermo_ax.h], 'Color', handles.b.ui.thermo_color); %background of the axes
        %handles.b.ui.proto = handles.b.ui.thermo_ax.handle; %this handle is checked in bci_results, but needs to be cleaned up
        
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
    
    %compute the coords of the condition image
    handles.b.ui.img.w = 0.08;
    handles.b.ui.img.h = 0.12;
    handles.b.ui.img.x = handles.b.ui.thermo_ax.l - handles.b.ui.thermo_ax.w*0.5;
    handles.b.ui.img.y = handles.b.ui.thermo_ax.b  + handles.b.ui.thermo_ax.h/2 - handles.b.ui.img.h/2;
    handles.b.ui.img.cond_axhandle = axes('Position', [handles.b.ui.img.x handles.b.ui.img.y handles.b.ui.img.w handles.b.ui.img.h], 'Color', handles.b.ui.thermo_color);
    % axis off; %Modification_RANGA_Mar17_2006
    handles.b.ui.last_gobjects.thermo(4) = handles.b.ui.thermo_ax.handle; %you should delete the image handle too later on
    handles.b.ui.last_gobjects.thermo(5) = handles.b.ui.img.cond_axhandle;
    
    %compute the coords of the stimulus image
    handles.b.ui.s_img.w=0.65;
    handles.b.ui.s_img.h=0.8;
    handles.b.ui.s_img.x= handles.b.ui.thermo_ax.l - handles.b.ui.thermo_ax.w*3.8;
    handles.b.ui.s_img.y= handles.b.ui.thermo_ax.b  - handles.b.ui.img.h*1.5;
    handles.b.ui.del_image = axes('Position', [handles.b.ui.s_img.x handles.b.ui.s_img.y handles.b.ui.s_img.w handles.b.ui.s_img.h], 'Color',  handles.b.ui.thermo_color);
    % axis off;
    if handles.b.flag.isref_zero
        aa=1;
    else
        aa=2;
    end
    %call the function that computes the coords of all the max grads and stores it
    handles=create_grads(handles.b.figures.feedback_fig, handles.b.ui, fix(handles.b.ui.thermo_grads/aa), 1,handles,aa); %the second argument forces creation for the first time
    xx=get(handles.b.ui.thermo_ax.handle,'ylim');
    %handles.b.ui.last_gobjects.thermo(3) = line(cl.X, cl.Y, 'LineStyle', cl.linestyle, 'Color',  cl.color);
    handles.b.ui.last_gobjects.thermo(3) = line(cl.X, xx(1)+ones(1,2)*((xx(2)-xx(1))/2), 'LineStyle', cl.linestyle, 'Color',  cl.color);
    
    %draw the centerline
    uistack(handles.b.ui.last_gobjects.thermo(3) ,'top');
    %  figure(gcf); %set the current fig
    %  axes(handles.b.ui.thermo_ax.handle); %background of the axes
    % status = 1;
    % uistack(handles.b.ui.last_gobjects.thermo(3) ,'top')
    
    %thermo_ax = ui.thermo_ax;
    %set(gcf, 'Color', handles.b.ui.thermo_color); %Modification_RANGA_Mar17_2006
    axis off; %Modification_RANGA_Mar17_2006
    return;
catch ME
    handles=error_log_display(handles,ME);
end
