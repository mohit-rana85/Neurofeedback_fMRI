function h=fixation_figure
 
h=figure( 'MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off');
set(gca,'position',[0 0 1 1],'units','normalized','Color',[0 0 0]);
text(0.5,0.5,'+','FontSize',48,'Color',[1 1 1])
 