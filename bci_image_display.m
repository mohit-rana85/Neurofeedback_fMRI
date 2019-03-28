function handles= bci_image_display(handles,grads )
%BCI_IMAGE_DISPLAY Read stimulus image to display on top of feedback window

% // besser wäre eine Lookup-Table zur Anzeige: in b.data(1,:) = BildNr //
% structure 'images' will contain
%   .count:     Anzahl Bilder
%   .volume{}:  Zur Messung von welchem Volume anzeigen ?
%   .data{}:    Bilddaten
%   .map{}:     Colormap dazu - aber bisher war alles Truecolor...
%
%   
try
   
    if strcmp(grads,'No')
        if isfield(handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images , 'volume')
            % find( [ handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.volume{:} ] == handles.b.Feedback.current_volume )       % gibts bessere Wege dafür ?
            if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                uistack(handles.b.ui.thermo_ax.handle,'top');
                set(handles.b.ui.thermo_ax.handle,'visible','on');
            end
            figure(handles.b.figures.feedback_fig);
            for i = 1:handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).blocks
                if ~isempty(handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.volume{i}) & find( handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.volume{i} == handles.b.Feedback.current_volume )
                    % a colormap would seriously impact our other image: the plot window ! //
                    %            colormap( images.map{i} );
                    handles.b.figures.displayingImage = 1;
                    if ~strcmp(handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.image_file{i}, handles.b.figures.preImageFile)
                        oldAxis = gca;
                        figure(handles.b.figures.feedback_fig);
                        axes( handles.b.ui.del_image );
                        handles.b.figures.preImageHandle = image(  handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.data{i} );
                        axis off                            % Property ('Visible','off' );
                        axes( oldAxis );
                        break% restore active axis
                    end
                    handles.b.figures.preImageFile = handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).images.image_file{i};
                    %fprintf( '\tVolume %3i, Image Nr %i\n', volume, i );
                    % break
                else
                     handles.b.figures.displayingImage = 0;
                end
            end
        else %if there is no stimulus image to display delete the previous
            if isfield (handles.b.figures, 'displayingImage')
                if ( handles.b.figures.displayingImage)
                    set( handles.b.figures.preImageHandle, 'Visible', 'off');
                end
            end
            if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
                uistack(handles.b.ui.thermo_ax.handle,'bottom');
                %delete_grads;
                set(handles.b.ui.thermo_ax.handle,'visible','off');
            end
            a(:,:,1)=zeros(720,540)* handles.b.ui.backcolor(1);a(:,:,2)=zeros(720,540)* handles.b.ui.backcolor(2);a(:,:,3)=zeros(720,540)* handles.b.ui.backcolor(3);
            axes( handles.b.ui.del_image );
            handles.b.ui.del_image_handle=image(a);
            axis off;
            handles.b.figures.preImageFile = [];
            handles.b.figures.displayingImage = 0;
        end
    elseif strcmp(grads,'update_back')
        if handles.b.perf.feedback_con_del(handles.b.Feedback.current_cond)==2
            a(:,:,1)=zeros(720,540)* handles.b.ui.backcolor(1);a(:,:,2)=zeros(720,540)* handles.b.ui.backcolor(2);a(:,:,3)=zeros(720,540)* handles.b.ui.backcolor(3);
            axes( handles.b.ui.del_image );
            handles.b.ui.del_image_handle=image(a);
            axis off;
        elseif handles.b.proto.cond_images || handles.b.perf.feedback_con_del(handles.b.Feedback.current_cond)~=2
            a(:,:,1)=ones(720,540)* handles.b.ui.backcolor(1);a(:,:,2)=ones(720,540)* handles.b.ui.backcolor(2);a(:,:,3)=ones(720,540)* handles.b.ui.backcolor(3);
            axes( handles.b.ui.del_image );
            handles.b.ui.del_image_handle=image(a);
            axis off;
        end
        
    elseif isfield(handles.b.ui,'del_image')
        
        %axes(ui.thermo_ax.handle)
        if strcmp(grads,'first')
            axes( handles.b.ui.del_image );
            handles.b.ui.del_image_handle=image(zeros(720,540));
            
            
            %set(preImageHandle, 'Visible', 'off');
            set(handles.b.ui.del_image_handle, 'Visible', 'off'); axis off ;
            pause(0.1);
            
            set(gcf, 'Color','k');
            return
        end
        % set(ui.del_image_handle, 'Visible', 'off');
        if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
            uistack(handles.b.ui.thermo_ax.handle,'bottom');
            %delete_grads;
            set(handles.b.ui.thermo_ax.handle,'visible','off');
        end
        axes( handles.b.ui.del_image );
        n=axis;
        text(((n(2)-n(1))/2)-50,((n(4)-n(3))/2)-20 ,[num2str(grads) ,handles.b.ui.currency],'FontName','Arial', 'Color','white' ,'FontSize',44, 'FontWeight','BOLD','BackgroundColor','k')
        axis off                            % Property ('Visible','off' );
        axes( gca );
        
        
        
        
    elseif handles.b.flag.isDelayed
        set( handles.b.figures.preImageHandle, 'Visible', 'off');
        if (strcmp(handles.b.ui.feedbacktype, 'THERMOMETER'))
            uistack(handles.b.ui.thermo_ax.handle,'bottom');
            %delete_grads;
            set(handles.b.ui.thermo_ax.handle,'visible','off');
        end
        axes( handles.b.ui.del_image );
        n=axis;
        text(((n(2)-n(1))/2)-50,((n(4)-n(3))/2)-20 ,[num2str(grads) ,' Euro'],'FontName','Arial', 'Color','white' ,'FontSize',44, 'FontWeight','BOLD','BackgroundColor','k')
        axis off                            % Property ('Visible','off' );
        axes( gca );
        
        
        
    end
     if handles.b.proto.cond_images && ~strcmp(grads,'first')
        display_condimage(handles.b.proto.cond(handles.b.proto.seqview.cond(handles.b.Feedback.current_cond)).cond_images.data,handles)
    end
catch ME
    handles=error_log_display(handles,ME);
end
% h = text(.5,.5,'xxXXXxx','HorizontalAlignment','center')
