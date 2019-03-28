function handles=plot_data_initiate(handles)
try
    if ~isfield(handles.b.figures,'fHand_plot_data')
        set(0,'units','pixels')
        %Obtains this pixel information
        handles.b.pre.screen_res = get(0,'screensize');
        ind_correl_y=[-1 1 1 -1 ];
        color_line=handles.b.pre.color_map_mask(2: size(handles.b.roi.MNI,1)+1,:);
        handles.b.figures.feedback_fig=figure('Name','Feedback','MenuBar','none','NumberTitle', 'off','Position', [10, round(handles.b.pre.screen_res(4)*0.63),round(handles.b.pre.screen_res(3)*0.3),round(handles.b.pre.screen_res(4)*0.3)],'visible','off');
        if (handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation) && strcmp(handles.b.ui.feedbacktype , 'THERMOMETER')
            handles.b.figures.fHand_plot_data=figure('Name','Feedback information','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off','position' ,[round(handles.b.pre.screen_res(3)*0.67),round(handles.b.pre.screen_res(4)*0.05),round(handles.b.pre.screen_res(3)*0.33), round(handles.b.pre.screen_res(4)*0.92)]);
            %  hold on;
            
            handles.b.figures.aHand_ROIs=subplot(3,2,1); % radar map
            handles.b.figures.aHand_mean_bar=subplot(3,2,2);% bar_mean BOLD values
            handles.b.figures.aHand_feedback=subplot(3,2,3:4);% feedback
            handles.b.figures.aHand_correl=subplot(3,2,5:6); % correlation
            
            if handles.b.flag.isref_zero
                nn=1;
                ind_thermo_y=[-1*handles.b.ui.thermo_grads,handles.b.ui.thermo_grads,handles.b.ui.thermo_grads,-1*handles.b.ui.thermo_grads];
            else
                nn=2;
                ind_thermo_y=[-1*handles.b.ui.thermo_grads/2,handles.b.ui.thermo_grads/2,handles.b.ui.thermo_grads/2,-1*handles.b.ui.thermo_grads/2];
            end
            %         handles=spider_plot(handles,'Marker', 'o', 'LineStyle', '-','LineWidth', 3, 'MarkerSize', 5);
            for ii=1:length(handles.b.roi.count)
                handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color',color_line(ii,:),'LineWidth',2);
                % hold on
                if ii ==1
                    hold(handles.b.figures.aHand_ROIs, 'on');
                end
                %  handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color','r','LineWidth',2);
            end
            axes(handles.b.figures.aHand_mean_bar);
            hold on;
            for ini=1:handles.b.proto.count
                handles.b.figures.aHand_bar(ini)=bar(ini,0,'parent', handles.b.figures.aHand_mean_bar,'facecolor',  handles.b.proto.cond(ini).color, 'EdgeColor',handles.b.proto.cond(ini).color);
            end
            
            if handles.b.flag.isShaping
                handles.b.figures.aHand_mean_line=plot(1:handles.b.roi.volumes,NaN,'--r','LineWidth',3);
            end
            
            x=1:handles.b.roi.volumes;handles.b.proto.seqview.data(handles.b.roi.volumes,1:length(handles.b.roi.count)+1)=0 ;
            handles.b.Feedback.correl_per_volume(handles.b.roi.volumes,1)=0;
            handles.b.Feedback.grads_cont(handles.b.roi.volumes,1)=0;
            
            
            
            handles.b.figures.correl=plot(handles.b.figures.aHand_correl,nan,'color','w','LineWidth',2);
            handles.b.figures.feedback=plot(handles.b.figures.aHand_feedback,nan,'color','w','LineWidth',2);
            hold(handles.b.figures.aHand_correl, 'on');
            hold(handles.b.figures.aHand_feedback, 'on');
            %         hold(handles.b.figures.aHand_global, 'on');
            
            
            
            for i = 1: length(handles.b.proto.line_graph.seqview)
                if i==1
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                else
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                end
                %             axes(handles.b.figures.aHand_ROIs);
                %             % patch(xx,ind_ROI_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                %             patch(xx,ind_ROI_y, handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                axes(handles.b.figures.aHand_correl);
                %patch(xx,ind_correl_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_correl_y, handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                axes(handles.b.figures.aHand_feedback);
                % patch(xx,ind_thermo_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_thermo_y, handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                %             axes(handles.b.figures.aHand_global);
                %             % patch(xx,ind_global_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                %             patch(xx,ind_global_y, handles.b.proto.line_graph.seqview_color{1,i}(1:3));
            end
            %         set(handles.b.figures.aHand_global,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            %         set(handles.b.figures.aHand_global,'YLim',[-3 3]);
            set(handles.b.figures.aHand_correl,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_correl,'YLim',[-1 1]);
            set(handles.b.figures.aHand_feedback,'YLim',[-1*round(handles.b.ui.thermo_grads/nn), round(handles.b.ui.thermo_grads/nn)]);
            set(handles.b.figures.aHand_feedback,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            %         set(handles.b.figures.aHand_ROIs,'YLim',[-3 , 3] );
            %         set(handles.b.figures.aHand_ROIs,'XLim',[1 handles.b.proto.seqview.block{1,end}(2)]);
            %         axes(handles.b.figures.aHand_global)
            %         title('Percentage change in global BOLD value')
            axes(handles.b.figures.aHand_correl)
            title('Correlation betwen ROIs')
            axes(handles.b.figures.aHand_feedback)
            title('Feedback')
            %         axes(handles.b.figures.aHand_ROIs)
            %         title('Percentage change in ROIs BOLD value')
            %         hh=legend({'ROI1','ROI2'},'Location','southoutside','Orientation','horizontal');
            %         set(hh,'color',[0.6 0.6 0.6]);
        elseif strcmp(handles.b.ui.feedbacktype , 'THERMOMETER')
            handles.b.figures.fHand_plot_data=figure('Name','Feedback information','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off','position' ,[round(handles.b.pre.screen_res(3)*0.67),round(handles.b.pre.screen_res(4)*0.05),round(handles.b.pre.screen_res(3)*0.33), round(handles.b.pre.screen_res(4)*0.92)]);
            % hold on;
            handles.b.figures.aHand_ROIs=subplot(3,1,1);
            
            handles.b.figures.aHand_feedback=subplot(3,1,2);
            
            handles.b.figures.aHand_global=subplot(3,1,3);
            
            x=1:handles.b.roi.volumes;handles.b.proto.seqview.data(handles.b.roi.volumes,1:length(handles.b.roi.count)+1)=0 ;
            handles.b.proto.seqview.per_global(handles.b.roi.volumes,1)=0; handles.b.Feedback.correl_per_volume(handles.b.roi.volumes,1)=0;
            handles.b.Feedback.grads_cont(handles.b.roi.volumes,1)=0;
            for ii=1:length(handles.b.roi.count)
                handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color',color_line(ii,:),'LineWidth',2);
                % hold on
                if ii ==1
                    hold(handles.b.figures.aHand_ROIs, 'on');
                end
                %  handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color', color_line(ii),'LineWidth',2);
            end
            if handles.b.flag.isShaping
                handles.b.figures.aHand_mean_line=plot(1:handles.b.roi.volumes,NaN,'--k','LineWidth',3);
            end
            handles.b.figures.global=plot(handles.b.figures.aHand_global,nan,'color','w', 'LineWidth',2);
            handles.b.figures.feedback=plot(handles.b.figures.aHand_feedback,nan,'color','w','LineWidth',2);
            hold(handles.b.figures.aHand_feedback, 'on');
            hold(handles.b.figures.aHand_global, 'on');
            
            if handles.b.flag.isref_zero
                nn=1;
                ind_thermo_y=[-1*handles.b.ui.thermo_grads,handles.b.ui.thermo_grads,handles.b.ui.thermo_grads,-1*handles.b.ui.thermo_grads];
            else
                nn=2;
                ind_thermo_y=[-1*handles.b.ui.thermo_grads/2,handles.b.ui.thermo_grads/2,handles.b.ui.thermo_grads/2,-1*handles.b.ui.thermo_grads/2];
            end
            ind_global_y=[-3 3 3 -3 ];
            ind_ROI_y=[-3 3 3 -3];%handles.b.pre.average_BOLD;
            
            for i = 1: length(handles.b.proto.line_graph.seqview)
                if i==1
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                else
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                end
                axes(handles.b.figures.aHand_ROIs);
                % patch(xx,ind_ROI_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_ROI_y,handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                axes(handles.b.figures.aHand_feedback);
                % patch(xx,ind_thermo_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_thermo_y,handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                axes(handles.b.figures.aHand_global);
                %patch(xx,ind_global_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_global_y,handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                
            end
            
            set(handles.b.figures.aHand_global,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_global,'YLim',[-3 3]);
            set(handles.b.figures.aHand_feedback,'YLim',[-1*round(handles.b.ui.thermo_grads/nn), round(handles.b.ui.thermo_grads/nn)]);
            set(handles.b.figures.aHand_feedback,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_ROIs,'YLim',[-3 , 3]);%+handles.b.pre.average_BOLD);
            set(handles.b.figures.aHand_ROIs,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            axes(handles.b.figures.aHand_global)
            title('Percentage change in global BOLD value')
            axes(handles.b.figures.aHand_feedback)
            title('Feedback')
            axes(handles.b.figures.aHand_ROIs)
            title('Percentage change in ROIs BOLD value')
            hh=legend(handles.b.pre.Label_radar,'Location','southoutside','Orientation','horizontal');
            set(hh,'color',[0.6 0.6 0.6]);
        elseif (handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation)
            handles.b.figures.fHand_plot_data=figure('Name','Feedback','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off','position',[round(handles.b.pre.screen_res(3)*0.67),round(handles.b.pre.screen_res(4)*0.05),round(handles.b.pre.screen_res(3)*0.33), round(handles.b.pre.screen_res(4)*0.92)]);
            handles.b.figures.aHand_ROIs=subplot(3,1,1);
            handles.b.figures.aHand_global=subplot(3,1,2);
            handles.b.figures.aHand_correl=subplot(3,1,3);
            
            ind_correl_y=[-1 1 1 -1 ];
            ind_global_y=[-3 3 3 -3 ];
            ind_ROI_y=[-3 3 3 -3];
            x=1:handles.b.roi.volumes;handles.b.proto.seqview.data(handles.b.roi.volumes,1:length(handles.b.roi.count)+1)=0 ;
            handles.b.proto.seqview.per_global(handles.b.roi.volumes,1)=0; handles.b.Feedback.correl_per_volume(handles.b.roi.volumes,1)=0;
            % handles.b.Feedback.grads_cont(handles.b.roi.volumes,1)=0;
            for ii=1:length(handles.b.roi.count)
                handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color',color_line(ii,:),'LineWidth',2);
                % hold on
                if ii ==1
                    hold(handles.b.figures.aHand_ROIs, 'on');
                end
                %   handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color', color_line(ii),'LineWidth',2);
            end
            if handles.b.flag.isShaping
                handles.b.figures.aHand_mean_line=plot(1:handles.b.roi.volumes,NaN,'--k','LineWidth',3);
            end
            handles.b.figures.global=plot(handles.b.figures.aHand_global,nan,'color','w', 'LineWidth',2);
            handles.b.figures.correl=plot(handles.b.figures.aHand_correl,nan,'color','w','LineWidth',2);
            %handles.b.figures.feedback=plot(handles.b.figures.aHand_feedback,x, handles.b.Feedback.grads_cont,'color','w','LineWidth',3);
            hold(handles.b.figures.aHand_correl, 'on');
            hold(handles.b.figures.aHand_global, 'on');
            axes(handles.b.figures.aHand_global)
            title('Percentage change in global BOLD value')
            axes(handles.b.figures.aHand_correl)
            title('Correlation betwen ROIs')
            axes(handles.b.figures.aHand_ROIs)
            title('Percentage change in ROIs BOLD value')
            hh=legend(handles.b.pre.Label_radar,'Location','southoutside','Orientation','horizontal');
            set(hh,'color',[0.6 0.6 0.6]);
            for i = 1: length(handles.b.proto.line_graph.seqview)
                if i==1
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                else
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                end
                axes(handles.b.figures.aHand_ROIs);
                % patch(xx,ind_ROI_y,'facecolor',b.proto.seqview.color{1,i}(1:3),'edgecolor', b.proto.seqview.color{1,i}(1:3));
                patch(xx,ind_ROI_y,  handles.b.proto.seqview.color{1,i}(1:3))
                axes(handles.b.figures.aHand_correl);
                %  patch(xx,ind_correl_y,'facecolor',b.proto.seqview.color{1,i}(1:3),'edgecolor', b.proto.seqview.color{1,i}(1:3));
                patch(xx,ind_correl_y,  handles.b.proto.seqview.color{1,i}(1:3)  )
                axes(handles.b.figures.aHand_global);
                %  patch(xx,ind_global_y,'facecolor',b.proto.seqview.color{1,i}(1:3),'edgecolor', b.proto.seqview.color{1,i}(1:3));
                patch(xx,ind_global_y, handles.b.proto.seqview.color{1,i}(1:3));
            end
            set(handles.b.figures.aHand_global,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_global,'YLim',[-3 3]);
            set(handles.b.figures.aHand_correl,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_correl,'YLim',[-1 1]);
            set(handles.b.figures.aHand_ROIs,'YLim',[-3 , 3]);
            set(handles.b.figures.aHand_ROIs,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            
        else
            handles.b.figures.fHand_plot_data=figure('Name','Feedback','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','visible','off','position',[[round(handles.b.pre.screen_res(3)*0.67),round(handles.b.pre.screen_res(4)*0.05),round(handles.b.pre.screen_res(3)*0.33), round(handles.b.pre.screen_res(4)*0.92)]]);
            
            handles.b.figures.aHand_ROIs=subplot(2,1,1);
            handles.b.figures.aHand_global=subplot(2,1,2);
            ind_global_y=[-3 3 3 -3 ];
            ind_ROI_y=[-3 3 3 -3];
            
            
            x=1:handles.b.roi.volumes;handles.b.proto.seqview.data(handles.b.roi.volumes,1:length(handles.b.roi.count)+1)=0 ;
            handles.b.proto.seqview.per_global(handles.b.roi.volumes,1)=0; %handles.b.Feedback.correl_per_volume(handles.b.roi.volumes,1)=0;
            % handles.b.Feedback.grads_cont(handles.b.roi.volumes,1)=0;
            for ii=1:length(handles.b.roi.count)
                handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color',color_line(ii,:),'LineWidth',2);
                % hold on
                if ii ==1
                    hold(handles.b.figures.aHand_ROIs, 'on');
                end
                % handles.b.figures.R(ii)=plot(handles.b.figures.aHand_ROIs,nan,'color', color_line(ii),'LineWidth',2);
            end
            if handles.b.flag.isShaping
                handles.b.figures.aHand_mean_line=plot(1:handles.b.roi.volumes,NaN,'--k','LineWidth',3);
            end
            handles.b.figures.global=plot(handles.b.figures.aHand_global, nan,'color','w', 'LineWidth',2);
            % handles.b.figures.correl=plot(handles.b.figures.aHand_correl,x, handles.b.Feedback.correl_per_volume,'color','w','LineWidth',3);
            % handles.b.figures.feedback=plot(handles.b.figures.aHand_feedback,x, handles.b.Feedback.grads_cont,'color','w','LineWidth',3);
            hold(handles.b.figures.aHand_global, 'on');
            
            axes(handles.b.figures.aHand_global)
            title('Percentage change in global BOLD value')
            axes(handles.b.figures.aHand_ROIs)
            title('Percentage change in ROIs BOLD value')
            L1 = line(ones(2),ones(2));
            set(L1,{'color'},{[1 0 0];[0 0 0]./255});
            hh=legend(handles.b.pre.Label_radar,'Location','southoutside','Orientation','horizontal');
            set(hh,'color',[0.6 0.6 0.6]);
            for i = 1: length(handles.b.proto.line_graph.seqview)
                if i==1
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                else
                    xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
                end
                axes(handles.b.figures.aHand_ROIs);
                % patch( xx, ind_ROI_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor',  handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch( xx, ind_ROI_y,handles.b.proto.line_graph.seqview_color{1,i}(1:3))
                axes(handles.b.figures.aHand_global);
                % patch(xx,ind_global_y,'facecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor',  handles.b.proto.line_graph.seqview_color{1,i}(1:3));
                patch(xx,ind_global_y,  handles.b.proto.line_graph.seqview_color{1,i}(1:3))
            end
            
            set(handles.b.figures.aHand_global,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            set(handles.b.figures.aHand_global,'YLim',[-3 3]);
            set(handles.b.figures.aHand_ROIs,'YLim',[-3 , 3]);
            set(handles.b.figures.aHand_ROIs,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
            
        end
    else
        axes(handles.b.figures.aHand_ROIs);
        ind_ROIs_y=[-5, 5, 5, -5];
        axes(handles.b.figures.aHand_ROIs)
        
        hh=legend(handles.b.pre.Label_radar,'Location','southoutside','Orientation','horizontal');
        set(hh,'color',[0.6 0.6 0.6]);
        
        for i = 1: length(handles.b.proto.line_graph.seqview)
            if i==1
                xx=[handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(1) handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
            else
                xx=[handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(1)-1 handles.b.proto.line_graph.seqview_block{i}(2) handles.b.proto.line_graph.seqview_block{i}(2)];
            end
            %  patch(xx,ind_ROIs_y,'facecolor',handles.b.proto.line_graph.seqview_color{1,i}(1:3),'edgecolor', handles.b.proto.line_graph.seqview_color{1,i}(1:3));
            patch(xx,ind_ROIs_y,handles.b.proto.line_graph.seqview_color{1,i}(1:3));
        end
        set(handles.b.figures.aHand_ROIs,'YLim',[-5 , 5]);
        set(handles.b.figures.aHand_ROIs,'XLim',[1 handles.b.proto.line_graph.seqview_block{1,end}(2)]);
        set(handles.b.figures.R1,'YData',handles.b.proto.seqview.data(1:handles.b.Feedback.current_volume,1));
        set(handles.b.figures.R2,'YData',handles.b.proto.seqview.data(1:handles.b.Feedback.current_volume,2));
        drawnow
    end
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end