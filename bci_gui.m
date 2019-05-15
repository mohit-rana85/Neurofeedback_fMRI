function varargout = bci_gui(varargin)
% BCI_GUI M-file for bci_gui.fig
%      BCI_GUI, by itself, creates a new BCI_GUI or raises the existing
%      singleton*.
%
%      H = BCI_GUI returns the handle to a new BCI_GUI or the handle to
%      the existing singleton*.
%
%      BCI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BCI_GUI.M with the given input arguments.
%
%      BCI_GUI('Property','Value',...) creates a new BCI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bci_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bci_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% handles.b.pre.current_hdr the above text to modify the response to help bci_gui

% Last Modified by GUIDE v2.5 06-Dec-2018 17:45:28

%to switch off the following warning
warning( 'off ');
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @bci_gui_OpeningFcn, ...
    'gui_OutputFcn',  @bci_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bci_gui is made visible.
function bci_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bci_gui (see VARARGIN)
%The opening titles...starring....:-)

%Note that the bci data structure 'b' is saved under the handles structure
clc;
numdays=daysact(datestr(now,'mm/dd/yy'),'12/31/2019');
if numdays<0
    h=msgbox({'Your subscription has expired','Please contact morana@uc.cl for further information'},'License Error','error','modal');
    set(h,'position',[100,400,300,80]);
    txt=findobj(h,'type','text');
    set(txt,'FontSize',12);uiwait(h);
    return
elseif numdays<15
    h=msgbox({['Your subscription will expire in ',num2str(numdays),' days'],'Please contact morana@uc.cl for further information'},'License Warning','warn','modal');
    set(h,'position',[100,400,300,80]);
    txt=findobj(h,'type','text');
    set(txt,'FontSize',12);uiwait(h);
end
warning( 'off'); %#ok<WNOFF>
if ~isdeployed
    handles.b.conf.current_dir=fileparts(which('bci_gui.m'));
    addpath(handles.b.conf.current_dir);
    addpath(genpath([handles.b.conf.current_dir,filesep,'SPM']))
    addpath(genpath([handles.b.conf.current_dir,filesep,'protocol images']))
    cd(handles.b.conf.current_dir);
else
    handles.b.conf.current_dir=pwd;
    % fileattrib([handles.b.conf.current_dir,filesep,'temp'],'+h -w','','s');
    %#MasterDirPB_Callback(hObject, eventdata, handles)
    %#neuro_stimuli_run_Callback(hObject, eventdata, handles)
    %#SourceDirectoryPB_Callback(hObject, eventdata, handles)
    %#TargetDirectoryPB_Callback(hObject, eventdata, handles)
    %#ExecuteGoPB_Callback(hObject, eventdata, handles)
    %#GenConfigFilesPB_Callback(hObject, eventdata, handles)
    %#SubNameEdit_Callback(hObject, eventdata, handles)
    %#ExpNameEdit_Callback(hObject, eventdata, handles)
    %#RunNumEdit_Callback(hObject, eventdata, handles)
    %#MasterDirEdit_Callback(hObject, eventdata, handles)
    %#SourceDirEdit_Callback(hObject, eventdata, handles)
    %#TargetDirEdit_Callback(hObject, eventdata, handles)
    %#ThermometerRB_Callback(hObject, eventdata, handles)
    %#GraduationsEdit_Callback(hObject, eventdata, handles)
    %#ThermoThresholdEdit_Callback(hObject, eventdata, handles)
    %#RewardRB_Callback(hObject, eventdata, handles)
    %#Euros_Callback(hObject, eventdata, handles)
    %#ThresholdEdit_Callback(hObject, eventdata, handles)
    %#TransferYES_Callback(hObject, eventdata, handles)
    %#TransferNO_Callback(hObject, eventdata, handles)
    %#EditVolumesToAvg_Callback(hObject, eventdata, handles)
    %#MaxLimitValue_Callback(hObject, eventdata, handles)
    %#Continuous_feedback_Callback(hObject, eventdata, handles)
    %#Delayed_feedback_Callback(hObject, eventdata, handles)
    %#seaworld_Callback(hObject, eventdata, handles)
    %#step_size_Callback(hObject, eventdata, handles)
    %#max_translation_Callback(hObject, eventdata, handles)
    %#output_feedback_dir_Callback(hObject, eventdata, handles)
    %#Output_feedback_Callback(hObject, eventdata, handles)
    %#correlation_pos_Callback(hObject, eventdata, handles)
    %#upregulation_Callback(hObject, eventdata, handles)
    %#downregulation_Callback(hObject, eventdata, handles)
    %#contrast_roi_Callback(hObject, eventdata, handles)
    %#Con_del_feedback_Callback(hObject, eventdata, handles)
    %#up_down_reg_Callback(hObject, eventdata, handles)
    %#neg_correlation_Callback(hObject, eventdata, handles)
    %#No_correlation_Callback(hObject, eventdata, handles)
    %#reward_threshold_Callback(hObject, eventdata, handles)
    %#sea_world_threshold_Callback(hObject, eventdata, handles)
    %#BOLD_Callback(hObject, eventdata, handles)
    %#corr_coef_Callback(hObject, eventdata, handles)
    %#intermediate_freq_Callback(hObject, eventdata, handles)
    %#session_type_Callback(hObject, eventdata, handles)
    %#session_log_Callback(hObject, eventdata, handles)
    %#shaping_Callback(hObject, eventdata, handles)
    %#block_avg_Callback(hObject, eventdata, handles)
    %#zero_Callback(hObject, eventdata, handles)
    %#half_Callback(hObject, eventdata, handles)
    %#SVM_Callback(hObject, eventdata, handles)
    %#RVM_Callback(hObject, eventdata, handles)
    %#SIC_Callback(hObject, eventdata, handles)
    %#SDC_Callback(hObject, eventdata, handles)
    %#Weights_Callback(hObject, eventdata, handles)
    %#per_simi_Callback(hObject, eventdata, handles)
    %#class_model_Callback(hObject, eventdata, handles)
    %#training_data_Callback(hObject, eventdata, handles)
    %#realign_Callback(hObject, eventdata, handles)
    %#norma_Callback(hObject, eventdata, handles)
    %#model_file_Callback(hObject, eventdata, handles)
    %#model_file_edit_Callback(hObject, eventdata, handles)
    %#session_align_Callback(hObject, eventdata, handles)
    %#run_align_Callback(hObject, eventdata, handles)
    %#bcigui_CloseRequestFcn(hObject, eventdata, handles)
    %#session_Callback(hObject, eventdata, handles)
    %#study_Callback(hObject, eventdata, handles)
end
%[b,status]=system_selection;
[config_file,config_path_file]=uigetfile([handles.b.conf.current_dir,filesep,'configuration_files',filesep,'*.mat'],'Please select the configuration file');
try
    b=load([config_path_file,config_file]);
    handles.b=b.b;
catch
    return
end

%    if status==0
%       return
%   end


clear b
if isdeployed
    handles.b.conf.current_dir=pwd;
else
    try
        handles.b.conf.current_dir=fileparts(which('bci_gui.m'));
    catch
        handles.b.conf.current_dir=fileparts(which('bci_gui.p'));
    end
end
handles.b.pre.screen_res = get(0,'screensize');
figure_position=get(handles.bcigui,'position');
if figure_position(4)+figure_position(4)*0.2<handles.b.pre.screen_res (4)
    handles.b.figures.figure_session_log=figure('Name','Session information','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','position',[figure_position(1),figure_position(2)-figure_position(4)*0.25,figure_position(3), figure_position(4)*0.2],'resize','off','visible','off','CloseRequestFcn',@(hObject,eventdata)bci_gui('session_close_fcn',hObject,eventdata,guidata(handles.bcigui)));
else
    handles.b.figures.figure_session_log=figure('Name','Session information','MenuBar', 'none', 'ToolBar', 'none','NumberTitle', 'off','position',[figure_position(1)+figure_position(3)+12,figure_position(2)+figure_position(4)*0.8 ,figure_position(3), figure_position(4)*0.2],'resize','off','visible','off','CloseRequestFcn',@(hObject,eventdata)bci_gui('session_close_fcn',hObject,eventdata,guidata(handles.bcigui)));
end
handles.session_log=uicontrol('Style','ListBox','FontWeight','BOLD','FontSize',12,'Parent',handles.b.figures.figure_session_log, 'TooltipString','Session information','Tag','session_log', 'ForegroundColor',[0 0 0],'BackgroundColor',[1,1,1],'position',[0,0,figure_position(3),figure_position(4)*0.2]);
try
    handles.b.ver = 2.0;
    handles.b.ui.simtype = 'NONE';
    handles.b.version = ['Tübingen fMRI-BCI Version ' sprintf('%.1f',handles.b.ver) ', October 2016.'];
    %fprintf('\n%s\n\n', handles.b.version );
    % pos=get(handles.bcigui,'Position');
    handles.tgroup = uitabgroup('Parent', handles.bcigui,'position',[0 0.277 0.999 0.28],'BackgroundColor',[0.5 0.5 0.5]);
    % jTabGroup = getappdata(handle(hTabGroup),'JTabbedPane');
    uistack(handles.text12,'top')
    handles.roi_feedback_tab= uitab('Parent', handles.tgroup, 'Title','ROI feedback' );
    handles.classification_tab = uitab('Parent', handles.tgroup, 'Title', 'Classification');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Feedback Freq.', ...
        'FontSize',9,     'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 135 90 15]);
    handles.Continuous_feedback=uicontrol('Style','radiobutton', 'String','Countinuous','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('Continuous_feedback_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback provided after each TR','Tag','Continuous_feedback', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[105 135 90 15]);
    handles.Delayed_feedback=uicontrol('Style','radiobutton', 'String','Delayed','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('Delayed_feedback_Callback',hObject,eventdata,guidata(hObject)) ,...
        'FontSize',9, 'TooltipString','Feedback provided after the end of reglation block','Tag','Delayed_feedback','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[205 135 80 15]);
    handles.Con_del_feedback=uicontrol('Style','radiobutton', 'String','Both','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('Con_del_feedback_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback provided both after each TR and end of the regulation block', 'Tag','Con_del_feedback', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[295 135 70 15]);
    uicontrol('Style','text', 'String','TR', ...
        'FontSize',9,   'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[375 135 40 15]);
    handles.intermediate_freq=uicontrol('Style','edit','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('intermediate_freq_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback provided after a number of TRs and how many TRs are used for threshold. Please mention only feedback freq., if you do not want to use threshold.','Tag','intermediate_freq','ForegroundColor',[0 0 0],'BackgroundColor',[1,1,1],'position',[420 135 50 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Regulation', ...
        'FontSize',9,    'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 113 90 15]);
    handles.upregulation=uicontrol('Style','radiobutton', 'String','Up-regulation','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('upregulation_Callback',hObject,eventdata,guidata(hObject)), ...
        'FontSize',9, 'TooltipString','Increase in BOLD signal as compare to the previous baseline block','Tag','upregulation', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[110 113 100 15]);
    handles.downregulation=uicontrol('Style','radiobutton', 'String','Down-regulation','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('downregulation_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Decrease in BOLD signal as compare to the previous baseline block','Tag','downregulation','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[220 113 120 15]);
    handles.up_down_reg=uicontrol('Style','radiobutton', 'String','Both','Parent',handles.roi_feedback_tab, 'Callback', @(hObject,eventdata)bci_gui('up_down_reg_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9,'TooltipString','If both upregulation and downregulation feedback is required', 'Tag','up_down_reg', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[370 113 80 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Correlation', ...
        'FontSize',9,    'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 91 90 15]);
    handles.correlation_pos=uicontrol('Style','radiobutton', 'String','Positive','Parent',handles.roi_feedback_tab, 'Callback', @(hObject,eventdata)bci_gui('correlation_pos_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Positive  correlation between two ROIs','Tag','correlation_pos', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[110 91 90 15]);
    handles.neg_correlation=uicontrol('Style','radiobutton', 'String','Negative','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('neg_correlation_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Negative  correlation between two ROIs','Tag','neg_correlation','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[210 91 90 15]);
    handles.No_correlation=uicontrol('Style','radiobutton', 'String','None','Parent',handles.roi_feedback_tab, 'Callback', @(hObject,eventdata)bci_gui('No_correlation_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9,  'TooltipString','No_correlation is required', 'Tag','No_correlation', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[310 91 80 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Preprocessing', ...
        'FontSize',9,   'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[5 69 90 15]);
    handles.realign_roi=uicontrol('Style','radiobutton', 'String','Realign','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('realign_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Preprocessing step only realignment','Tag','realign', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[100 69 70 15]);
    handles.norma_roi=uicontrol('Style','radiobutton', 'String','Norma','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('norma_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Preprocessing steps: Normalization and realignment ','Tag','norma','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[180 69 70 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Ref. Realign', ...
        'FontSize',9,    'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[260 69 80 15]);
    handles.session_roi=uicontrol('Style','radiobutton', 'String','Session','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('session_align_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9,  'TooltipString','First EPI of the session will be used as a reference','Tag','shaping', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[350 69 70 15]);
    handles.run_roi=uicontrol('Style','radiobutton', 'String','Run','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('run_align_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','First EPI of the run will be used as a reference','Tag','block_avg','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[430 69 60 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Baseline', ...
        'FontSize',9,    'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 47 90 15]);
    handles.shaping=uicontrol('Style','radiobutton', 'String','Shaping','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('shaping_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9,  'TooltipString','Compute Baseline BOLD value after every TR','Tag','shaping', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[110 47 80 15]);
    handles.block_avg=uicontrol('Style','radiobutton', 'String','Block Avg.','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('block_avg_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Baseline is calculated after the end of each baseline block','Tag','block_avg','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[200 47 80 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Input', ...
        'FontSize',9,   'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 25 90 15]);
    handles.BOLD=uicontrol('Style','radiobutton', 'String','BOLD','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('BOLD_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback is calculated based on change in BOLD values alone.','Tag','BOLD', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[110 25 70 15]);
    handles.corr_coef=uicontrol('Style','radiobutton', 'String','Corr. Coef.','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('corr_coef_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback is provided only based on the  correlation coefficient between two ROIs','Tag','corr_coef','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 25 80 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','ROI Contrast', ...
        'FontSize',9,      'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[285 25 90 15]);
    handles.contrast_roi=uicontrol('Style','edit','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('contrast_roi_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Contrast between ROI. e.g., for 3 ROIs : 1 1 -1','Tag','contrast_roi','ForegroundColor',[0 0 0],'BackgroundColor',[1,1,1],'position',[395 25 80 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Reference Bar', ...
        'FontSize',9,  'Parent',handles.roi_feedback_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 5 90 15]);
    handles.zero=uicontrol('Style','radiobutton', 'String','Zero','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('zero_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Mean baselline BOLD value is equivalent to zero number of bars','Tag','zero', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[110 5 70 15]);
    handles.half=uicontrol('Style','radiobutton', 'String','Half','Parent',handles.roi_feedback_tab, 'Callback',@(hObject,eventdata)bci_gui('half_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Mean baselline BOLD value is equivalent to half the number of bars','Tag','half','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 5 70 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         Classification         %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Classification Algorithm', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 135 150 15]);
    handles.SVM=uicontrol('Style','radiobutton', 'String','SVM','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('SVM_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Support Vector Machine','Tag','SVM', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 135 60 15]);
    handles.RVM=uicontrol('Style','radiobutton', 'String','RVM','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('RVM_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Relevance Vector Machine','Tag','RVM','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[280 135 60 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Classification Approach', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 113 150 15]);
    handles.SIC=uicontrol('Style','radiobutton', 'String','SIC','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('SIC_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Subject Independet classifier','Tag','SIC', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 113 60 15]);
    handles.SDC=uicontrol('Style','radiobutton', 'String','SDC','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('SDC_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Subject dependet classifier','Tag','SDC','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[280 113 60 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Classification Model', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 91 150 15]);
    handles.model_file=uicontrol('Style','pushbutton', 'String','Select file','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('model_file_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Subject Independet classifier','Tag','SIC', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 89 70 20],'Enable','off');
    handles.model_file_edit=uicontrol('Style','edit', 'String','','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('model_file_edit_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Subject dependet classifier','Tag','SDC','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[280 89 150 20],'Enable','off');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','TR', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[375 135 40 15]);
    handles.intermediate_freq_class=uicontrol('Style','edit','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('intermediate_freq_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback provided after a number of TRs and how many TRs are used for threshold. Please mention only feedback freq., if you do not want to use threshold.','Tag','intermediate_freq','ForegroundColor',[0 0 0],'BackgroundColor',[1,1,1],'position',[420 135 50 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Feedback', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 69 90 15]);
    handles.Weights=uicontrol('Style','radiobutton', 'String','Weights','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('Weights_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback computed using weights','Tag','Weights', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 69 70 15]);
    handles.per_simi=uicontrol('Style','radiobutton', 'String','% similarity','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('per_simi_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Feedback based on % similarlity from the standard pattern','Tag','per_simi','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[280 69 90 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Preprocessing', ...
        'FontSize',9,   'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[5 47 90 15]);
    handles.realign_class=uicontrol('Style','radiobutton', 'String','Realign','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('realign_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Preprocessing step only realignment','Tag','realign', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[100 47 70 15]);
    handles.norma_class=uicontrol('Style','radiobutton', 'String','Norma','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('norma_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Preprocessing steps: Normalization and realignment ','Tag','norma','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[180 47 70 15]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Ref. Realign', ...
        'FontSize',9,    'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[260 47 80 15]);
    handles.session_class=uicontrol('Style','radiobutton', 'String','Session','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('session_align_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9,  'TooltipString','First EPI of the session will be used as a reference','Tag','shaping', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[350 47 70 15]);
    handles.run_class=uicontrol('Style','radiobutton', 'String','Run','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('run_align_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','First EPI of the run will be used as a reference','Tag','block_avg','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[430 47 60 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.training_data=uicontrol('Style','Checkbox', 'String','Collecting data to train class.','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('training_data_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Collecting data for training classification model','Tag','training_data', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[20  5 180 15]);
    uicontrol('Style','text', 'String','Create classification Model', ...
        'FontSize',9,     'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[220  5 170 15]);
    handles.class_model=uicontrol('Style','pushbutton', 'String','Run','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('class_model_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Create Classification Model ','Tag','class_model','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[400  2 60 20]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', 'String','Reference Bar', ...
        'FontSize',9,  'Parent',handles.classification_tab,'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0,0.25],'position',[10 25 110 15]);
    handles.zero_class=uicontrol('Style','radiobutton', 'String','Zero','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('zero_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Mean baselline BOLD value is equivalent to zero number of bars','Tag','zero', 'ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[190 25 60 15]);
    handles.half_class=uicontrol('Style','radiobutton', 'String','Half','Parent',handles.classification_tab, 'Callback',@(hObject,eventdata)bci_gui('half_Callback',hObject,eventdata,guidata(hObject)),...
        'FontSize',9, 'TooltipString','Mean baselline BOLD value is equivalent to half the number of bars','Tag','half','ForegroundColor',[1 1 1],'BackgroundColor',[0.5,0.25,0.25],'position',[280 25 60 15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if handles.b.flag.TBV
        set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
        set(handles.session_type,'Enable','off');
        handles.b.session_type='None';
    elseif ~handles.b.flag.isClassification % no TBV no Classification
        if handles.b.flag.islocalizer 
            set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
            text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Dummy Functional Run';'Feedback Run'};
            set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        else
               set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
            text={'Select';'Anatomical Run';'Dummy Functional Run';'Feedback Run'};
            set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        end
    elseif handles.b.flag.isClassification %Classification
        set(handles.tgroup,'SelectedTab',handles.classification_tab );
        if handles.b.flag.Classification.isSIC
              text={'Select';'Anatomical Run';'Dummy Functional Run';'Classification Run'};
              set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);           
        elseif handles.b.flag.Classification.isSDC
            if handles.b.flag.islocalizer
                if handles.b.flag.isrealignment
                    text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                elseif handles.b.flag.isnormalization
                    text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                end
            else
                if handles.b.flag.isrealignment
                    text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                elseif handles.b.flag.isnormalization
                    text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                end
            end
        end
    end
    if ~isfield (handles.b.pre,'input_filename')
        if strcmp(handles.b.pre.MR_scanner,'Siemens')
            handles.b.pre.input_filename= '001_%06d_%06d';
        elseif strcmp(handles.b.pre.MR_scanner,'Philips')
            
            handles.b.pre.input_filename= '%s-ScanDRIN-ImageType016-Echo00001-CardPhase00001-Dyn%06d';
        end
    end
    if handles.b.flag.TBV || ~handles.b.flag.TBV
        if ~handles.b.flag.isClassification
            set(handles.intermediate_freq,'string',['[',num2str(handles.b.ui.inter_TR),',',num2str(handles.b.ui.thresh_feed),']']);
        else
            set(handles.intermediate_freq_class,'string',['[',num2str(handles.b.ui.inter_TR),',',num2str(handles.b.ui.thresh_feed),']']);
        end
        set(handles.contrast_roi,'string',handles.b.roi.count_str)
        set(handles.contrast_roi,'visible','on')
        if handles.b.flag.iscon_del_feedback
            set(handles.Con_del_feedback,'value',1);
        elseif handles.b.flag.isContinuous
            set(handles.Continuous_feedback,'value',1);
        elseif handles.b.flag.isDelayed
            set(handles.Delayed_feedback,'value',1);
        end
        if handles.b.flag.isupregulation
            set(handles.upregulation,'value',1);
        elseif handles.b.flag.isdownregulation
            set(handles.downregulation,'value',1);
        elseif handles.b.flag.isboth_up_down_regulation
            set(handles.up_down_reg,'value',1);
        end
        if handles.b.flag.isposcorrelation
            set(handles.correlation_pos,'value',1);
        elseif handles.b.flag.isnegcorrelation
            set(handles.neg_correlation,'value',1);
        else
            set(handles.No_correlation,'value',1);
        end
        if handles.b.flag.isBOLD
            set(handles.BOLD,'value',1);
        elseif handles.b.flag.iscoefcorr
            set(handles.corr_coef,'value',1);
        end
        if handles.b.flag.isShaping
            set(handles.shaping,'value',1);
        elseif handles.b.flag.isblock_avg
            set(handles.block_avg,'value',1);
        end
        if strcmp(handles.b.ui.feedbacktype,'THERMOMETER')
            if ~handles.b.flag.isClassification
                if  handles.b.flag.isref_zero
                    set(handles.zero,'value',1);
                else
                    set(handles.half,'value',1);
                end
            else
                if  handles.b.flag.isref_zero
                    set(handles.zero_class,'value',1);
                else
                    set(handles.half_class,'value',1);
                end
            end
        else
            set (handles.zero,'Enable','off');
            set (handles.half,'Enable','off');
            set (handles.zero_class,'Enable','off');
            set (handles.half_class,'Enable','off');
        end
    elseif handles.b.flag.isClassification
        if handles.b.flag.Classification.isSVM
            set(handles.SVM,'value',1);
        elseif handles.b.flag.Classification.isRVM
            set(handles.RVM,'value',1);
        end
        if handles.b.flag.Classification.isper_simi
            set(handles.per_simi,'value',1);
        elseif handles.b.flag.Classification.isWeights
            set(handles.Weights,'value',1);
        end
        if handles.b.flag.Classification.isSIC
            set(handles.SIC,'value',1);
            set (handles.training_data,'Enable','off');
            set (handles.class_model,'Enable','off');
            set (handles.model_file,'Enable','on');
            set (handles.model_file_edit,'Enable','on');
            handles.b.flag.Classification.iscreate_model=false;
            handles.b.flag.Classification.istraining_data=false;
            handles.b.flag.Classification.isnormalization =true;
            set(handles.norma,'value',1);
        elseif handles.b.flag.Classification.isSDC
            set(handles.SDC,'value',1);
            handles.b.flag.Classification.istraining_data=true;
            set(handles.training_data,'value',1);
            handles.b.flag.Classification.iscreate_model=false;
            set(handles.class_model,'value',0);
            
            
        end
    end
    set(handles.study,'string',handles.b.conf.study);
    if handles.b.flag.isnormalization
        if handles.b.flag.isClassification
            set(handles.norma_class,'value',1);
            set(handles.realign_class,'value',0);
        else
            set(handles.norma_roi,'value',1);
            set(handles.realign_roi,'value',0);
        end
    elseif handles.b.flag.isrealignment
        if handles.b.flag.isClassification
            set(handles.norma_class,'value',0);
            set(handles.realign_class,'value',1);
        else
            set(handles.norma_roi,'value',0);
            set(handles.realign_roi,'value',1);
        end
    end
    if handles.b.flag.isrealignment_ref_run
        if handles.b.flag.isClassification
            set(handles.run_class,'value',1); set(handles.session_class,'value',0);
        else
            set(handles.run_roi,'value',1);
            set(handles.session_roi,'value',0);
        end
    elseif  handles.b.flag.isrealignment_ref_session
        if handles.b.flag.isClassification
            set(handles.run,'value',0);
            set(handles.session,'value',1);
        else
            set(handles.run_roi,'value',0);
            set(handles.session_roi,'value',1);
        end
    end
    if handles.b.flag.isClassification
        if strcmp(handles.b.ui.feedbacktype,'THERMOMETER')
            if  handles.b.flag.isref_zero
                set(handles.zero_class,'value',1);
            else
                set(handles.half_class,'value',1);
            end
        else
            set (handles.zero_class,'Enable','off');
            set (handles.half_class,'Enable','off');
        end
    end
    handles.b.session_type='';
    handles.b.conf.config_file=config_file;
    handles.b.conf.config_path_file=config_path_file;
    clear config_file config_path_file
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str={handles.b.version };
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Configuration ',handles.b.conf.config_file, ' is loaded'];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    handles.b.pre.realign_opt.PW='';
    handles.b.pre.realign_opt.graphics=0;
    handles.b.pre.realign_opt.lkp=1:6;
    handles.b.pre.realign_opt.wrap=[0 0 0];
    handles.b.pre.realign_opt.interp=2;
    handles.b.pre.realign_opt.sep=4;
    handles.b.pre.realign_opt.quality = 0.9;
    handles.b.pre.realign_opt.fwhm    = 5;
    handles.b.pre.realign_opt.rtm     = 0;
    handles.b.pre.realign_rs_opt.mean = 1;
    handles.b.pre.realign_rs_opt.interp = 4;
    handles.b.pre.realign_rs_opt.which = 2;
    handles.b.pre.realign_rs_opt.prefix ='r';
    handles.b.pre.coreg_flag.cost_fun = 'ecc';
    handles.b.pre.coreg_flag.sep      = [4 2 1];
    handles.b.pre.coreg_flag.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    handles.b.pre.coreg_flag.fwhm     = [7 7];
%     handles.b.pre.seg_flag.tpm= str2mat(...
%         fullfile(handles.b.conf.current_dir,'spm','apriori','grey.nii'),...
%         fullfile(handles.b.conf.current_dir,'spm','apriori','white.nii'),...
%         fullfile(handles.b.conf.current_dir,'spm','apriori','csf.nii'));
%     handles.b.pre.seg_flag.warpreg    = 1;
%     handles.b.pre.seg_flag.warpco = 25;
%     handles.b.pre.seg_flag.samp   = 3;
%     handles.b.pre.seg_flag.biasreg     =  1.0000e-04;
%     handles.b.pre.seg_flag. biasfwhm = 60;
%     handles.b.pre.seg_flag.regtype = 'mni';
%     handles.b.pre.seg_flag.msk = '';
%     handles.b.pre.seg_flag.ngfaus=[2;2;2;4];
    handles.b.pre.norm_flag.prefix='w';
    handles.b.pre.norm_flag.preserve=0;
    handles.b.pre.norm_flag.vox=[3 ,3,3];
    handles.b.pre.norm_flag.interp=7;
    handles.b.pre.norm_flag.bb=[-78,-112,-70; 78,76,85];
    handles.b.pre.norm_flag.wrap=[0,0,0];
    handles.b.pre.output.cleanup=0;
    handles.b.pre.output.GM=[0,0,1];
    handles.b.pre.output.WM=[0,0,1];
    handles.b.pre.output.CSF=[0,0,0];
    handles.b.pre.output.biascor=1;
    handles.b.ui.thermo_color=  [0.5 0.5 0.6];
    handles.b.Feedback.thermo=[];
    handles.b.Feedback.reward.current_reward=[];
    handles.b.Feedback.reward.total_reward=[];
    set(handles.SubNameEdit ,'BackgroundColor',[255 35 35]/255);
    set(handles.ExpNameEdit,'string',handles.b.conf.exp_name);
    set(handles.RunNumEdit,'BackgroundColor',[255 35 35]/255);
    set(handles.RunNumEdit,'string','');
    if handles.b.flag.show_diff_images
        set(handles.neuro_stimuli_run,'BackgroundColor',[255 35 35]/255);
        set(handles.neuro_stimuli_run,'string','');
        set(handles.neuro_stimuli_run,'Enable','off');
    else
        set(handles.neuro_stimuli_run,'Enable','off');
    end
    if strcmp(handles.b.conf.master_dir(1),'.')
        handles.b.conf.master_dir=[pwd,handles.b.conf.master_dir(2:end)];
    end
    if strcmp(handles.b.conf.target_dir(1),'.')
        handles.b.conf.target_dir=[pwd,handles.b.conf.target_dir(2:end)];
    end
    set(handles.MasterDirEdit,'string',handles.b.conf.master_dir);
    set(handles.TargetDirEdit,'string',handles.b.conf.target_dir);
    set(handles.SourceDirEdit,'BackgroundColor',[255 35 35]/255);
    set(handles.session,'BackgroundColor',[255 35 35]/255);
    set(handles.SourceDirEdit,'string','');
    set(handles.output_feedback_dir,'string',handles.b.conf.output_dir);
    set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
    
    if strcmp(handles.b.flag.isTransfer,'NO')
        set(handles.TransferNO,'value',1);
    else
        set(handles.TransferYES,'value',1);
    end
    
    if strcmp(handles.b.ui.feedbacktype,'THERMOMETER')
        set (handles.GraduationsEdit,'string',handles.b.ui.thermo_grads);
        set (handles.EditVolumesToAvg,'string',handles.b.ui.VOLUMES_TO_AVG) ;
        set (handles.ThermometerRB,'value',1);
        set( handles.ThresholdEdit,'string',handles.b.ui.roi_threshold);
    end
    if  handles.b.ui.SHOW_REWARD
        set (handles.MaxLimitValue,'string',handles.b.ui.MAX_EUROS);
        set (handles.Euros,'string',handles.b.ui.euros_perbold) ;
        set (handles.RewardRB,'value',1);
        set( handles.reward_threshold,'string',  handles.b.ui.roi_threshold_reward);
    end
    if strcmp(handles.b.ui.feedbacktype,'SeaWorld')
        set (handles.step_size,'string',handles.b.ui.seaworld_stepsize );
        set (handles.max_translation,'string',handles.b.ui.max_translation ) ;
        set (handles.seaworld,'value',1);
        set( handles.sea_world_threshold,'string',  handles.b.ui.roi_threshold_sea);
    end
    handles.b.isFeedbackDone = 'NO';
    % handles.b.ui.feedbacktype = '';
    
    % handles.b.ui.SHOW_REWARD =false;
    
    set(handles.bcigui,'Name','Neurofeedback Experiment')
    % Choose default command line output for bci_gui
    % a=ver;
    % for i1=1:length(a)
    %     if isempty(strfind( a(i1).Name,'3D Animation'))
    %         x=0;
    %     else
    %         x=1;
    %     end
    % end
    % if x
    % set(handles.seaworld,'Enable','off');
    % set(handles.max_translation,'Enable','off');
    % set(handles.step_size,'Enable','off');
    %end
    handles.output = hObject;
catch ME
    handles=error_log_display(handles,ME);
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bci_gui wait for user response (see UIRESUME)
% uiwait(handles.bcigui);


% --- Outputs from this function are returned to the command line.
function varargout = bci_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'b')
    set(handles.bcigui,'Visible','on');
    set(handles.b.figures.figure_session_log,'Visible','on');
    
    varargout{1} = handles.output;
end




% --- Executes on button press in MasterDirPB.
function MasterDirPB_Callback(hObject, eventdata, handles)
% hObject    handle to MasterDirPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.b.conf.master_dir = uigetdir(handles.b.conf.current_dir, 'Please select master directory');
    
    if(isempty(deblank(handles.b.conf.master_dir)))
        msgbox('Please select again...', 'Error selecting master dir');
        handles.b.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['The master directory selected: ',handles.b.conf.master_dir];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    set(handles.MasterDirEdit, 'String', handles.b.conf.master_dir);
    % Update handles structure
    handles.b.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in SourceDirectoryPB.
function SourceDirectoryPB_Callback(hObject, eventdata, handles)
% hObject    handle to SourceDirectoryPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.b.conf.watch_dir= uigetdir(handles.b.conf.watch_dir_root, 'Please select watch directory');
    if(isempty(deblank(handles.b.conf.watch_dir)))
        msgbox('Please select again...', 'Error selecting the watch dir');
        handles.b.isvalidinput = 'NO';
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['The watch directory selected: ',handles.b.conf.watch_dir];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    set(handles.SourceDirEdit, 'String', handles.b.conf.watch_dir);
    set(handles.SourceDirEdit,'BackgroundColor',[1 1 1]);
    % Update handles structure
    handles.b.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in TargetDirectoryPB.
function TargetDirectoryPB_Callback(hObject, eventdata, handles)
% hObject    handle to TargetDirectoryPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.b.conf.target_dir = uigetdir(handles.b.conf.current_dir, 'Please select target directory');
    
    if(isempty(deblank(handles.b.conf.target_dir)))
        msgbox('Please select again...', 'Error selecting target dir');
        handles.b.isvalidinput = 'NO';
    end
    if ~isfield(handles.b.conf,'target_subj_path')
        handles.b.conf.target_subj_path=[handles.b.conf.target_dir,filesep,handles.b.conf.study,filesep,handles.b.conf.sub_name];
        if   exist(handles.b.conf.target_subj_path,'dir')~=7
            mkdir(handles.b.conf.target_subj_path);
        end
    end
    set(handles.TargetDirEdit,'string',handles.b.conf.target_subj_path);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['The target directory selected: ',handles.b.conf.target_dir];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    
    set(handles.TargetDirEdit, 'String', handles.b.conf.target_subj_path);
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in ExecuteGoPB.
function ExecuteGoPB_Callback(hObject, eventdata, handles)
% hObject    handle to ExecuteGoPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 try
    t1 = clock; %start clock
    if  isfield(handles.b.figures,'fHand_plot_data')
        if handles.b.flag.isposcorrelation || handles.b.flag.isnegcorrelation
            hhh= {'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig',...
                'global','R','aHand_global','aHand_ROIs','fHand_plot_data','aHand_correl'};
            for i11=1:length(hhh)
                if isfield(handles.b.figures,hhh{i11})
                    handles.b.figures=rmfield(handles.b.figures,hhh{i11});
                end
            end
        else
            hhh={'h1','h2','h3','h4','h5','h6','para_axes','image_axes','frame','functional_image','image_vis_fig',...
                'global','R','aHand_global','aHand_ROIs','fHand_plot_data'};
            for i11=1:length(hhh)
                if isfield(handles.b.figures,hhh{i11})
                    handles.b.figures=rmfield(handles.b.figures,hhh{i11});
                end
            end
        end
    end
    set(handles.ExecuteGoPB,'Backgroundcolor', 'green');
    handles.b.flag.isFeedbackDone = 'NO';
     if handles.b.flag.islocalizer && strcmp(handles.b.session_type,'Feedback Run')
         if handles.b.conf.session==1
             if exist([handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,'Original',filesep,'MNI_coordinate.txt'],'file')==2
                 fid=fopen([handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,'Original',filesep,'MNI_coordinate.txt']);
                 [~,c]=find(handles.b.roi.sel_MNI==1);
                 for iin=1:sum(handles.b.roi.sel_MNI)
                     temp=fgetl(fid);
                     if temp==-1
                         ME.stack(1).line=770; ME.stack(1).name='fgetl';ME.message=['Number of coordinates selected is not equal to ',num2str(sum(handles.b.roi.sel_MNI))];
                         handles=error_log_display(handles,ME);
                     else
                         handles.b.roi.MNI(c(iin),:)=str2num(temp); %#ok<ST2NM>
                     end
                 end
              end
         end
     end
    if(strcmp(handles.b.flag.isvalidinput,'YES')) %if all the input is valid
        %     handles.b.ui.simtype = 'NONE';
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['BCI execution started at ',datestr(now)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        xx=0;
        if  strcmp(handles.b.session_type,'Dummy Functional Run') && ~isfield(handles.b.pre,'norm_defs') && (handles.b.conf.session>1 || (handles.b.conf.session==1 && handles.b.Feedback.dummy_idx>1))
            if handles.b.flag.islocalizer 
               path_file1=dir([handles.b.conf.target_subj_path(1:end-1),'1',filesep,'LocalizerAnalysis*.mat']);
            else
               path_file1=dir([handles.b.conf.target_subj_path(1:end-1),'1',filesep,'Dum*.mat']);
            end
            if length(path_file1)>2
               [aa,bb] = sort([path_file1(:).datenum],'descend');
               path_file=path_file1(bb(1));
            else
                path_file= path_file1;
                clear path_file1;
            end
            if ~isempty(path_file)
                nn=load([handles.b.conf.target_subj_path(1:end-1),'1',filesep,path_file.name]);
                mkdir([handles.b.conf.target_subj_path,filesep,'Anatomyf'])
                if exist(nn.b.pre.ori.extracted_anatomical_image,'file')==2
                    [~, fl,ext]=fileparts(nn.b.pre.ori.extracted_anatomical_image);
                    handles.b.pre.normalization.extracted_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,fl,ext];
                    copyfile(nn.b.pre.ori.extracted_anatomical_image,handles.b.pre.normalization.extracted_anatomical_image)
                    clear pth fl ext;
                else
                    xx=11;
                end
                if exist(nn.b.pre.ori.gm_anatomical_image,'file')==2
                    [~, fl,ext]=fileparts(nn.b.pre.ori.gm_anatomical_image);
                    handles.b.pre.normalization.gm_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,fl,ext] ;
                    copyfile(nn.b.pre.ori.gm_anatomical_image,handles.b.pre.normalization.gm_anatomical_image)
                    clear pth fl ext;
                else
                    xx=11;
                end
                if exist(nn.b.pre.ori.wm_anatomical_image,'file')==2
                    [~, fl,ext]=fileparts(nn.b.pre.ori.wm_anatomical_image);
                    handles.b.pre.normalization.wm_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,fl,ext];
                    copyfile(nn.b.pre.ori.wm_anatomical_image,handles.b.pre.normalization.wm_anatomical_image)
                    clear pth fl ext;
                else
                    xx=11;
                end
                if exist(nn.b.pre.ori.norm_def,'file')==2
                    [~, fl,ext]=fileparts(nn.b.pre.ori.norm_def);
                    handles.b.pre.normalization.norm_def=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,fl,ext];
                    copyfile( nn.b.pre.ori.norm_def,handles.b.pre.normalization.norm_def )
                    clear pth fl ext;
                else
                    xx=11;
                end
                if exist(nn.b.pre.ori.initial_mean_file,'file')==2
                    [~, fl,ext]=fileparts(nn.b.pre.ori.initial_mean_file);
                    handles.b.pre.normalization.initial_functional_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,fl,ext];
                    copyfile( nn.b.pre.ori.initial_mean_file,handles.b.pre.normalization.initial_functional_image )
                    clear pth fl ext ;
                else
                    xx=11;
                end
                if  exist(nn.b.pre.ori.norm_mat_file,'file')==2
                     load([nn.b.pre.ori.norm_mat_file]);
                     handles.b.pre.normalization =normalization;
                     clear normalization nn;
                else
                    xx=11;
                end
             
                if exist([handles.b.conf.target_subj_path(1:end-1),'1',filesep,'Anatomyf',filesep,'Original',filesep,'MNI_coordinate.txt'],'file')==2
                    fid=fopen([handles.b.conf.target_subj_path(1:end-1),'1',filesep,'Anatomyf',filesep,'Original',filesep,'MNI_coordinate.txt']);
                    [~,c]=find(handles.b.roi.sel_MNI==1);
                    for iin=1:sum(handles.b.roi.sel_MNI)
                        temp=fgetl(fid);
                        if temp==-1
                            ME.stack(1).line=770; ME.stack(1).name='fgetl';ME.message=['Number of coordinates selected is not equal to ',num2str(sum(handles.b.roi.sel_MNI))];
                            handles=error_log_display(handles,ME);
                        else
                            handles.b.roi.MNI(c(iin),:)=str2num(temp); %#ok<ST2NM>
                        end
                    end
                else
                    xx=11;
                end
            else
                xx=11;
            end
            if xx==11
                path_file=uigetdir( [handles.b.conf.target_subj_path(1:end-1),'1'],['Please select the directory conataining Anatomy files from participants','''','s first session']);
                mkdir([handles.b.conf.target_subj_path,filesep,'Anatomyf'])
                try
                    files=dir([path_file,filesep]);
                    for ii=3:length(files)
                        if strcmp(files(ii).name(1:2),'c1')
                            handles.b.pre.normalization.gm_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,files(ii).name];
                            copyfile([path_file,filesep,files(ii).name],handles.b.pre.normalization.gm_anatomical_image);
                        elseif strcmp(files(ii).name(1:2),'c2')
                            handles.b.pre.normalization.wm_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,files(ii).name];
                            copyfile([path_file,filesep,files(ii).name],handles.b.pre.normalization.wm_anatomical_image);
                        elseif strcmp(files(ii).name(1:2),'y_')
                            handles.b.pre.normalization.norm_def=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,files(ii).name];
                            copyfile([path_file,filesep,files(ii).name], handles.b.pre.normalization.norm_def);
                        elseif strcmp(files(ii).name(1:2),'e_')
                            handles.b.pre.normalization.extracted_anatomical_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,files(ii).name];
                            copyfile([path_file,filesep,files(ii).name],handles.b.pre.normalization.extracted_anatomical_image);
                        elseif strcmp(files(ii).name(1:2),'me')
                            handles.b.pre.normalization.initial_functional_image=[handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,files(ii).name];
                            copyfile([path_file,filesep,files(ii).name],handles.b.pre.normalization.initial_functional_image);
                        elseif strcmp(files(ii).name(1:2),'no')
                            load([path_file,filesep,files(ii).name]);
                            handles.b.pre.normalization =normalization;
                        elseif strcmp(files(ii).name(1:2),'MN')
                          %  if exist([handles.b.conf.target_subj_path,filesep,'Anatomyf',filesep,'Original',filesep,'MNI_coordinate.txt'],'file')==2
                                fid=fopen([path_file,filesep,files(ii).name]);
                                [~,c]=find(handles.b.roi.sel_MNI==1);
                                for iin=1:sum(handles.b.roi.sel_MNI)
                                    temp=fgetl(fid);
                                    if temp==-1
                                        ME.stack(1).line=770; ME.stack(1).name='fgetl';ME.message=['Number of coordinates selected is not equal to ',num2str(sum(handles.b.roi.sel_MNI))];
                                        handles=error_log_display(handles,ME);
                                    else
                                        handles.b.roi.MNI(c(iin),:)=str2num(temp); %#ok<ST2NM>
                                    end
                                end
                           % end
                        end
                        
                    end
                catch
                    msgbox('Please select the correct file','Error')
                    return
                end
            end
        end
        
        % fprintf('\nBCI execution started...\n');
        if  handles.b.flag.TBV
            uiwait(msgbox('Please run the TBV with the .tbv generated in this session and press OK', 'Attention!'));
        end
        %     handles.b.session_log=handles.session_log;
        handles = bci_runview(handles);
        
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        set(handles.ExecuteGoPB,'Backgroundcolor', 'cyan');
        if ~ handles.b.iserror
            set(handles.RunNumEdit,'BackgroundColor',[255 35 35]/255);
            if  ~(strcmp(handles.b.session_type,'Feedback Run')|| strcmp(handles.b.session_type,'Classification Run'))
                set(handles.session_type, 'BackgroundColor',[255 35 35]/255);
            end
            if strcmp(handles.b.session_type,'Training Run')|| strcmp(handles.b.session_type,'Classification Run')|| strcmp(handles.b.session_type,'Feedback Run')
                set(handles.neuro_stimuli_run,'BackgroundColor',[255 35 35]/255);
                set(handles.neuro_stimuli_run,'string','');
            end
            if strcmp(handles.b.session_type,'Dummy Functional Run')||strcmp(handles.b.session_type,'Localizer Analysis')
                set(handles.neuro_stimuli_run,'enable','on');
            end
            
            set(handles.RunNumEdit,'string','');
        end
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['BCI run is over at '  datestr(now)];
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        et = etime(clock, t1); %prints elapsed time for this function
        % fprintf('\n\nElapsed time in seconds for the feedback task: %3.6f\n\n', et);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Elapsed time for the run:',num2str(et),'s'];
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        if handles.b.iserror==0
            save([handles.b.conf.target_subj_path,filesep,strtrim(handles.b.session_type(~isspace(handles.b.session_type))),'_subj_',handles.b.conf.sub_name,'_Run_',num2str(handles.b.conf.run_num),'.mat'],'-struct','handles','b')
        end
        % fprintf('\nBCI execution ended.\n');
        %     et = etime(clock, t1); %prints elapsed time for this function
        %     fprintf('\n\nElapsed time in seconds for the feedback task: %3.6f\n\n', et);
    else
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'Not all input is valid. Please check input again to proceed.';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
    end
    handles.b.flag.isFeedbackDone = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in GenConfigFilesPB.
function GenConfigFilesPB_Callback(hObject, eventdata, handles)
% hObject    handle to GenConfigFilesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    set(handles.GenConfigFilesPB,'Backgroundcolor', 'green');
    %Generate the config files only if all input fields are valid
    if ~ischar(handles.b.conf.sub_name) || (length(deblank(handles.b.conf.sub_name))  == 0)
        msgbox('Subject name not yet entered!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    
    if ~ischar(handles.b.conf.exp_name) || (length(deblank(handles.b.conf.exp_name))  == 0)
        msgbox('Experiment name not yet entered!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    
    if isnan(handles.b.conf.run_num) || (handles.b.conf.run_num <= 0)
        msgbox('Run number (> 0)  not yet entered!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    
    if ~ischar(handles.b.conf.master_dir) || (length(deblank(handles.b.conf.master_dir))  == 0)
        msgbox('Master directory not yet selected!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    
    if ~ischar(handles.b.conf.watch_dir) || (length(deblank(handles.b.conf.watch_dir))  == 0)
        msgbox('Source directory not yet selected!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    if handles.b.flag.show_diff_images
        
        if   (handles.b.conf.neuro_run_num)<=0 ||  (length(deblank(handles.b.conf.neuro_run_num))  == 0)
            msgbox('Wrong Neurofeedback run selected!', 'Error generating config files');
            set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
            return;
        end
    end
    % if ~ischar(handles.b.conf.target_dir) || (length(deblank(handles.b.conf.target_dir))  == 0)
    %     msgbox('Target directory not yet selected!', 'Error generating config files');
    %     set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
    %     return;
    % end
    
    if ~ischar(handles.b.conf.target_dir) || (length(deblank(handles.b.conf.target_dir))  == 0)
        msgbox('Target directory not yet selected!', 'Error generating config files');
        set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
        return;
    end
    
    
    %Generate config files if it has reached here...
    guidata(hObject, handles);
    % if  handles.b.flag.TBV
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'generating config files...' ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    
    %     if  strcmp(handles.b.session_type,'Feedback Run')
    
    %if ~isnan(handles.b.conf.neuro_run_num)
    if handles.b.flag.TBV
        %fprintf('\nWe can now proceed to generate config files...\n');
        [handles.b.conf,status] = bci_generator(handles.b.conf.sub_name,handles.b.conf.exp_name,handles.b.conf.run_num,handles.b.conf.master_dir,handles.b.conf.watch_dir,handles.b.conf.target_dir,handles.b.conf.output_dir,handles.b.conf.rootpath);
        if ~status
            set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
            return
        end
        
        % uiwait(msgbox('Please modify the config files if necessary and press OK to continue creation of BCI data structure.', 'Generation of config files successful!'));
        % end
        % if exist([handles.b.conf.name '.mat']) == 2
        %     disp(['You have already got results using "' handles.b.conf.name '".']);
        %     handles.b = bci_compatibility( handles.b );             % load data, adapt structures
        %     bci_init_figure( handles.b.roi.background, handles.b.conf.master ); % initialize figure
        %     bci_results( handles.b );
        %     return
        % end
        
        %
        % initialize main data struct 'handles.b': collect information from config-files
        %
        handles.b = init_datastruct(handles.b,handles);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'generating protocol data structure...' ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
        set(handles.contrast_roi,'string', ['[',  num2str(handles.b.roi.count),']']);
        
        % set up feedback data array with stimulation protocol
        % ====================================================
        handles.b.proto=[];
        [ handles.b.roi.data, handles.b.proto, handles.b.perf ] = bci_protocol( handles.b.proto, handles.b.roi.baseline,handles.b ,handles);
        if length( handles.b.roi.data ) ~= handles.b.roi.volumes
            warning( ['Stimulation protocol (*.prt) condition block (' ...
                int2str(length(handles.b.data)) ') and TBV "NrOfVolumes" (' ...
                int2str(handles.b.roi.volumes) ') don''t match'...
                '- did you mess up the protocol file ?' ] );
        end
        
    elseif ~(strcmp(handles.b.session_type,'Anatomical Run') )%||  strcmp(handles.b.session_type,'Dummy Functional Run'))
        [handles,status] = bci_generator_no_TBV(handles);
        if ~status
            set(handles.GenConfigFilesPB,'Backgroundcolor', 'cyan');
            return
        end
        guidata(hObject, handles);
        
        
        handles.b.proto=[];
        handles=bci_protocol_no_TBV(handles);
    end
    %end
    %     end
    % Update handles structure
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'protocol data structure is generated' ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    if handles.b.flag.TBV
        % fprintf('\nGeneration of config files and creation of data structure complete.\n');
        msgbox('Generation of config files and creation of data structure complete. You may now proceed to Simulate or Execute.');
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function SubNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SubNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SubNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubNameEdit as text
%        str2double(get(hObject,'String')) returns contents of SubNameEdit as a double
try
    handles.b.conf.sub_name = get(hObject, 'String');
    if(length(deblank(handles.b.conf.sub_name)) == 0)
        msgbox('Please enter again...', 'Error entering subject name');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    
    handles.b.conf.target_subj_path=[handles.b.conf.target_dir,filesep,handles.b.conf.study,filesep,handles.b.conf.sub_name];
    
    if   exist(handles.b.conf.target_subj_path,'dir')~=7
        mkdir(handles.b.conf.target_subj_path);
    end
    
    set(handles.TargetDirEdit,'string',handles.b.conf.target_subj_path);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Subject name: ',handles.b.conf.sub_name] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    set(handles.SubNameEdit ,'BackgroundColor',[1 1 1] );
    if strcmp(handles.b.pre.MR_scanner,'Siemens')
        handles.b.conf.watch_dir=[ handles.b.conf.watch_dir_root,filesep,datestr(now,'yyyymmdd'),'.',handles.b.conf.sub_name,'.',handles.b.conf.sub_name ];
        set(handles.SourceDirEdit,'string',handles.b.conf.watch_dir);
        set(handles.SourceDirEdit,'BackgroundColor',[1 1 1] );
    end
    % masterpath=[] ;
    % [handles.b.conf.rootpath]=fileparts(which ('bci_gui'));
    % dirs = regexp(genpath(handles.b.conf.rootpath),['[^;]*'],'match');
    % D=dir(handles.b.conf.rootpath);%# Get the data for the current directory
    % dirIndex = [D.isdir];  %# Find the index for directories
    % dirList = {D(dirIndex).name}';
    % for ii=3:length(dirList)
    %
    %     d=dir([handles.b.conf.rootpath, filesep, dirList{ii,1}]);
    %     for i1=1:length(d)
    %         if strcmp (d(i1).name,'feedback.tbv')  || strcmp (d(i1).name,'feedback.prt')  || strcmp (d(i1).name,'feedback.bci')
    %             masterpath= [handles.b.conf.rootpath, filesep, dirList{ii,1}] ;
    %             break;
    %         end
    %     end
    %
    %     if isempty(masterpath)==0
    %         break;
    %     end
    % end
    %
    % set(handles.ExpNameEdit,'String','feedback')
    % handles.b.conf.exp_name='feedback';
    % fprintf('\nExperiment name: %s\n', handles.b.conf.exp_name);
    %
    % if ~isdir(strtrim(masterpath))
    %     msgbox('Please enter Master Directory...', 'Error in Identifying Master Directory');
    %
    % else
    %     handles.b.conf.master_dir=strtrim(masterpath);
    %     set(handles.MasterDirEdit,'String',handles.b.conf.master_dir );
    %     fprintf('\nMaster dir: %s\n', handles.b.conf.master_dir);
    %
    % end
    %
    %
    % handles.b.conf.target_dir = [handles.b.conf.rootpath filesep 'Data' filesep 'Target' ];
    % set(handles.TargetDirEdit,'String',handles.b.conf.target_dir);
    % fprintf('\nTarget dir: %s\n', handles.b.conf.target_dir);
    %
    % set(handles.output_feedback_dir,'String','D:\faces')
    % handles.b.conf.output_dir='D:\faces';
    % fprintf('\nOutput Directory: %s\n', handles.b.conf.output_dir);
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ExpNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function ExpNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ExpNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExpNameEdit as text
%        str2double(get(hObject,'String')) returns contents of ExpNameEdit as a double
try
    handles.b.conf.exp_name = get(hObject, 'String');
    if(length(deblank(handles.b.conf.exp_name)) == 0)
        msgbox('Please enter again...', 'Error entering experiment name');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Experiment name: ',handles.b.conf.exp_name] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RunNumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RunNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function RunNumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RunNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RunNumEdit as text
%        str2double(get(hObject,'String')) returns contents of RunNumEdit as a double
try
    handles.b.conf.run_num = fix(str2double(get(hObject, 'String'))); %integer
    if isnan(handles.b.conf.run_num) || (handles.b.conf.run_num <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering run number');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    set(handles.RunNumEdit,'BackgroundColor',[1 1 1] );
    if strcmp(handles.b.pre.MR_scanner,'Philips')
        handles.b.conf.watch_dir=[ handles.b.conf.base_watch_dir,filesep,handles.b.conf.sub_name,filesep, handles.b.conf.run_num ];
        set(handles.SourceDirEdit,'string',handles.b.conf.watch_dir);
        set(handles.SourceDirEdit,'BackgroundColor',[1 1 1] );
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['fMRI Run number: ',num2str(handles.b.conf.run_num)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function MasterDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MasterDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MasterDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MasterDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MasterDirEdit as text
%        str2double(get(hObject,'String')) returns contents of MasterDirEdit as a double
try
    handles.b.conf.master_dir = get(hObject, 'String');
    if(length(deblank(handles.b.conf.master_dir)) == 0)
        msgbox('Please enter again...', 'Error entering master dir');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Master dir: ',handles.b.conf.master_dir] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SourceDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SourceDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SourceDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourceDirEdit as text
%        str2double(get(hObject,'String')) returns contents of SourceDirEdit as a double
try
    handles.b.conf.watch_dir = get(hObject, 'String');
    if(length(deblank(handles.b.conf.watch_dir)) == 0)
        msgbox('Please enter again...', 'Error entering source dir');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    set(handles.SourceDirEdit,'BackgroundColor',[1 1 1] );
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Source dir: ',handles.b.conf.watch_dir] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TargetDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function TargetDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TargetDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TargetDirEdit as text
%        str2double(get(hObject,'String')) returns contents of TargetDirEdit as a double
try
    handles.b.conf.target_dir = get(hObject, 'String');
    if(isempty(deblank(handles.b.conf.target_dir)))
        msgbox('Please enter again...', 'Error entering target dir');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    if ~isfield(handles.b.conf,'target_subj_path')
        handles.b.conf.target_subj_path=[handles.b.conf.target_dir,filesep,handles.b.conf.sub_name];
        if   exist(handles.b.conf.target_subj_path,'dir')~=7
            mkdir(handles.b.conf.target_subj_path);
        end
    end
    set(handles.TargetDirEdit,'string',handles.b.conf.target_subj_path);
    
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Target dir: ', handles.b.conf.target_subj_path] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in ThermometerRB.
function ThermometerRB_Callback(hObject, eventdata, handles)
% hObject    handle to ThermometerRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ThermometerRB
try
    if (get(hObject, 'Value') == 1)
        handles.b.ui.feedbacktype = 'THERMOMETER';
        % set(handles.RewardRB, 'Value', 0); %tick-off on the other radio button
        set(handles.seaworld, 'Value', 0);
        handles.b.ui.thermo_grads = 20; %integer
        set(handles.GraduationsEdit,'string', num2str(handles.b.ui.thermo_grads));
        handles.b.ui.roi_threshold = 1; %integer
        handles.b.ui.VOLUMES_TO_AVG=3;
        set(handles.EditVolumesToAvg,'string', num2str( handles.b.ui.VOLUMES_TO_AVG));
        set(handles.ThresholdEdit,'string', num2str(handles.b.ui.roi_threshold ));
        %set(handles.MaxLimitValue,'string', '');
        % set(handles.Euros,'string','');
        set(handles.max_translation,'string','');
        set(handles.step_size,'string',  '');
        set(handles.sea_world_threshold,'string','');
        if handles.b.ui.SHOW_REWARD
            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Feedback type selected: ','Thermometer and Reward'];
        else
            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Feedback type selected: ','Thermometer'];
        end
        figure(handles.b.figures.figure_session_log);
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Thermometer Graduations: ', num2str(handles.b.ui.thermo_grads)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Volumes to Avg: ', num2str(handles.b.ui.VOLUMES_TO_AVG)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Thermometer Threshold: ',num2str(handles.b.ui.roi_threshold)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.ui.feedbacktype = 'NONE';
        handles.b.ui.thermo_grads = []; %integer
        handles.b.ui.VOLUMES_TO_AVG= [];
        set(handles.GraduationsEdit,'string','');
        set(handles.ThresholdEdit,'string','');
        set(handles.EditVolumesToAvg,'string',  '');
    end
    % Update handles structure
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GraduationsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GraduationsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function GraduationsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GraduationsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GraduationsEdit as text
%        str2double(get(hObject,'String')) returns contents of GraduationsEdit as a double
try
    handles.b.ui.thermo_grads = fix(str2double(get(hObject, 'String'))); %integer
    if isnan(handles.b.ui.thermo_grads) || (handles.b.ui.thermo_grads <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering graduations');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Thermometer Graduations: ',num2str( handles.b.ui.thermo_grads)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ThermoThresholdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThermoThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ThermoThresholdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ThermoThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThermoThresholdEdit as text
%        str2double(get(hObject,'String')) returns contents of ThermoThresholdEdit as a double
try
    handles.b.ui.roi_threshold = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.roi_threshold) || (handles.b.ui.roi_threshold <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering threshold');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Thermometer Threshold: ', num2str(handles.b.ui.roi_threshold)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in RewardRB.
function RewardRB_Callback(hObject, eventdata, handles)
% hObject    handle to RewardRB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RewardRB
try
    if (get(hObject, 'Value') == 1)
        handles.b.ui.SHOW_REWARD = true;
        set(handles.seaworld, 'Value', 0);
        handles.b.ui.MAX_EUROS =10; %integer
        set(handles.MaxLimitValue,'string', num2str(handles.b.ui.MAX_EUROS));
        handles.b.ui.euros_perbold =0.1; %integer
        set(handles.Euros,'string', num2str(handles.b.ui.euros_perbold));
        handles.b.ui.roi_threshold_reward =1; %integer
        set(handles.reward_threshold,'string', num2str(handles.b.ui.roi_threshold_reward));
        if strcmp(handles.b.ui.feedbacktype,'THERMOMETER')
            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Feedback type selected: ','Thermometer and Reward'];
        else
            handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=['Feedback type selected: ','Reward'];
        end
        figure(handles.b.figures.figure_session_log);
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Max Euros per Session: ', num2str(handles.b.ui.MAX_EUROS)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Euros per percent BOLD increase: ',num2str(handles.b.ui.euros_perbold)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold: ',num2str(handles.b.ui.roi_threshold_reward)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.sea_world_threshold,'string','');
        set(handles.max_translation,'string','');
        set(handles.step_size,'string',  '');
    else
        handles.b.ui.SHOW_REWARD = false;
        handles.b.ui.MAX_EUROS=[];
        handles.b.ui.MAX_EUROS=[];
        set(handles.MaxLimitValue,'string', '');
        set(handles.Euros,'string', ''); set(handles.reward_threshold,'string', '');
        
    end
catch ME
    handles=error_log_display(handles,ME);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Euros_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Euros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Euros_Callback(hObject, eventdata, handles)
% hObject    handle to Euros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Euros as text
%        str2double(get(hObject,'String')) returns contents of Euros as a double
try
    handles.b.ui.euros_perbold = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.euros_perbold) || (handles.b.ui.euros_perbold <= 0)
        msgbox('Please enter again...', 'Error entering Euros per BOLD');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Euros per percent BOLD increase: ', num2str(handles.b.ui.euros_perbold)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ThresholdEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ThresholdEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThresholdEdit as text
%        str2double(get(hObject,'String')) returns contents of ThresholdEdit as a double
try
    handles.b.ui.roi_threshold = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.roi_threshold) || (handles.b.ui.roi_threshold <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering threshold');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold: ', num2str(handles.b.ui.roi_threshold)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);



% --- Executes on button press in TransferYES.
function TransferYES_Callback(hObject, eventdata, handles)
% hObject    handle to TransferYES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TransferYES
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isTransfer = 'YES';
        set(handles.TransferNO, 'Value', 0); %tick-off on the other radio button
        set(handles.TransferYES, 'Value', 1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'No Feedback will be shown' ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in TransferNO.
function TransferNO_Callback(hObject, eventdata, handles)
% hObject    handle to TransferNO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TransferNO
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isTransfer = 'NO';
        set(handles.TransferYES, 'Value', 0);
        set(handles.TransferNO, 'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Feedback will be shown' ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditVolumesToAvg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditVolumesToAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EditVolumesToAvg_Callback(hObject, eventdata, handles)
% hObject    handle to EditVolumesToAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditVolumesToAvg as text
%        str2double(get(hObject,'String')) returns contents of EditVolumesToAvg as a double
try
    handles.b.ui.VOLUMES_TO_AVG = str2double(get(hObject, 'String')); %integer
    if isnan( handles.b.ui.VOLUMES_TO_AVG) || ( handles.b.ui.VOLUMES_TO_AVG <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering VOLUMES_TO_AVG');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Volumes to Avg: ', num2str(handles.b.ui.VOLUMES_TO_AVG)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxLimitValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxLimitValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxLimitValue_Callback(hObject, eventdata, handles)
% hObject    handle to MaxLimitValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxLimitValue as text
%        str2double(get(hObject,'String')) returns contents of MaxLimitValue as a double
try
    handles.b.ui.MAX_EUROS = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.euros_perbold) || (handles.b.ui.euros_perbold <= 0)
        msgbox('Please enter again...', 'Error entering Euros per BOLD');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Max Euros per TR: ', num2str(handles.b.ui.MAX_EUROS)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);



% --- Executes on button press in Continuous_feedback.
function Continuous_feedback_Callback(hObject, eventdata, handles)
% hObject    handle to Continuous_feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Continuous_feedback
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.Continuous_feedback,'value',1);
        handles.b.flag.isContinuous = 1;handles.b.flag.isDelayed = 0;
        set(handles.Delayed_feedback, 'Value', 0);
        handles.b.flag.iscon_del_feedback = 0; set(handles.Con_del_feedback, 'Value', 0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback Frequency: ', 'Continuous'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in Delayed_feedback.
function Delayed_feedback_Callback(hObject, eventdata, handles)
% hObject    handle to Delayed_feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Delayed_feedback
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.Delayed_feedback,'value',1);
        handles.b.flag.isDelayed = 1;handles.b.flag.isContinuous =0;
        set(handles.Continuous_feedback, 'Value', 0);
        handles.b.flag.iscon_del_feedback = 0; set(handles.Con_del_feedback, 'Value', 0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback Frequency: ', 'Delayed'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));guidata(hObject, handles);
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject,handles);

% --- Executes on button press in seaworld.
function seaworld_Callback(hObject, eventdata, handles)
% hObject    handle to seaworld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of seaworld
try
    if (get(hObject, 'Value') == 1)
        handles.b.ui.SHOW_REWARD =false;
        handles.b.ui.feedbacktype = 'SEAWORLD';
        set(handles.ThermometerRB, 'Value', 0);
        set(handles.seaworld, 'Value', 1);   set(handles.RewardRB, 'Value', 0);
        
        handles.b.ui.max_translation =50; %integer
        set(handles.max_translation,'string', num2str(handles.b.ui.max_translation));
        handles.b.ui.roi_threshold_sea =1; %integer
        set(handles.sea_world_threshold,'string',num2str(handles.b.ui.roi_threshold_sea)  );
        handles.b.ui.seaworld_stepsize =2; %integer
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback type selected: ',  'Flying Bird'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Maximum tranlational length: ',  num2str(handles.b.ui.max_translation)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Step size: ',  num2str(handles.b.ui.seaworld_stepsize)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold: ',num2str(handles.b.ui.roi_threshold_sea )] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.step_size,'string',  num2str(handles.b.ui.seaworld_stepsize));
        set(handles.Euros,'string', '');
        set(handles.MaxLimitValue,'string','');
        set(handles.GraduationsEdit,'string', '');
        set(handles.EditVolumesToAvg,'string', '');set(handles.ThresholdEdit,'string', '');set(handles.reward_threshold,'string', '');
    else
        set(handles.max_translation,'string', '');set(handles.sea_world_threshold,'string','');set(handles.step_size,'string','');
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

function step_size_Callback(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size as text
%        str2double(get(hObject,'String')) returns contents of step_size as a double
try
    handles.b.ui.seaworld_stepsize=str2double(get(hObject, 'String'));%integer
    
    if isnan(handles.b.ui.seaworld_stepsize) || (handles.b.ui.seaworld_stepsize <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering step size');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Step size: ',  num2str(handles.b.ui.seaworld_stepsize)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function step_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_translation_Callback(hObject, eventdata, handles)
% hObject    handle to max_translation (see GCBO)
% eventdata  reserved - to be defFined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_translation as text
%        str2double(get(hObject,'String')) returns contents of max_translation as a double
try
    handles.b.ui.max_translation=str2double(get(hObject, 'String'));%integer
    if isnan(handles.b.ui.max_translation) || (handles.b.ui.max_translation <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering max translation');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Maximum tranlational length: ',  num2str(handles.b.ui.max_translation)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function max_translation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_feedback_dir_Callback(hObject, eventdata, handles)
% hObject    handle to output_feedback_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_feedback_dir as text
%        str2double(get(hObject,'String')) returns contents of output_feedback_dir as a double
try
    handles.b.conf.output_dir = get(hObject, 'String');
    if(isempty(deblank(handles.b.conf.output_dir)))
        msgbox('Please enter again...', 'Error entering Output dir');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Output dir: ',   handles.b.conf.output_dir] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function output_feedback_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_feedback_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Output_feedback.
function Output_feedback_Callback(hObject, eventdata, handles)
% hObject    handle to Output_feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.b.conf.output_dir = uigetdir('C:', 'Please select output directory');
    if(isempty(deblank(handles.b.conf.output_dir)))
        msgbox('Please select again...', 'Error selecting Output dir');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Output dir: ',   handles.b.conf.output_dir] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    set(handles.output_feedback_dir, 'String', handles.b.conf.output_dir);
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in correlation_pos.
function correlation_pos_Callback(hObject, eventdata, handles)
% hObject    handle to correlation_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of correlation_pos
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.correlation_pos,'value',1);
        handles.b.flag.isposcorrelation = 1 ;
        handles.b.flag.isnegcorrelation = 0 ;
        set(handles.neg_correlation, 'value',0);
        set(handles.No_correlation, 'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [' Correlation: ',   'Positive'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in upregulation.
function upregulation_Callback(hObject, eventdata, handles)
% hObject    handle to upregulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of upregulation
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.upregulation,'value',1);
        handles.b.flag.isupregulation = 1;  handles.b.flag.isdownregulation = 0;
        set(handles.downregulation,'value',0);
        handles.b.flag.isboth_up_down_regulation = 0;set(handles.up_down_reg,'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [' Regulation: ',   'Up-regulation'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in downregulation.
function downregulation_Callback(hObject, eventdata, handles)
% hObject    handle to downregulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of downregulation
try
    if (get(hObject, 'Value') == 1) ||(get(hObject, 'Value') == 0)
        set(handles.downregulation,'value',1);
        handles.b.flag.isdownregulation = 1;handles.b.flag.isupregulation = 0;
        set(handles.upregulation,'value',0);
        handles.b.flag.isboth_up_down_regulation = 0;set(handles.up_down_reg,'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [' Regulation: ',   'Down-regulation'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);






function contrast_roi_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast_roi as text
%        str2double(get(hObject,'String')) returns contents of contrast_roi as a double
try
    handles.b.roi.count_str=(get(hObject, 'String'));%integer
    try
        handles.b.roi.count=eval(['[',handles.b.roi.count_str,']']);
    catch
        msgbox('Please enter contrast correctly  ...', 'Error entering ROI Contrast');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    
    if isnan(mean(handles.b.roi.count)) || (length(handles.b.roi.count )<= 0)
        msgbox('Please enter contrast correctly  ...', 'Error entering ROI Contrast');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['ROI contrast: ',  handles.b.roi.count_str] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function contrast_roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Con_del_feedback.
function Con_del_feedback_Callback(hObject, eventdata, handles)
% hObject    handle to Con_del_feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Con_del_feedback
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.Con_del_feedback,'value',1);
        handles.b.flag.iscon_del_feedback = 1;
        handles.b.flag.isDelayed = 0;handles.b.flag.isContinuous =0;
        set(handles.Continuous_feedback, 'Value', 0); set(handles.Delayed_feedback, 'Value', 0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback Frequency: ',  'Continuous and Delayed'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);




% --- Executes on button press in up_down_reg.
function up_down_reg_Callback(hObject, eventdata, handles)
% hObject    handle to up_down_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of up_down_reg
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        set(handles.up_down_reg,'value',1);
        handles.b.flag.isboth_up_down_regulation = 1;
        handles.b.flag.isupregulation = 0;handles.b.flag.isdownregulation = 0;
        set(handles.upregulation,'value',0);set(handles.downregulation,'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Regulation: ', 'Up-regualtion and Down-regulation'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in neg_correlation.
function neg_correlation_Callback(hObject, eventdata, handles)
% hObject    handle to neg_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of neg_correlation
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isposcorrelation = 0 ;
        handles.b.flag.isnegcorrelation = 1 ;
        set(handles.correlation_pos, 'value',0);
        set(handles.No_correlation, 'value',0);
        set(handles.neg_correlation, 'value',1);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Correlation: ', 'Negative'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in No_correlation.
function No_correlation_Callback(hObject, eventdata, handles)
% hObject    handle to No_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of No_correlation
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isposcorrelation = 0 ;
        handles.b.flag.isnegcorrelation = 0 ;
        set(handles.correlation_pos, 'value',0);
        set(handles.neg_correlation, 'value',0);
        set(handles.No_correlation, 'value',1);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Correlation: ', 'None'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);



function reward_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to reward_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of reward_threshold as text
%        str2double(get(hObject,'String')) returns contents of reward_threshold as a double
try
    handles.b.ui.roi_threshold_reward = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.roi_threshold_reward) || (handles.b.ui.roi_threshold_reward <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering threshold');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Thermometer Threshold: ',num2str(handles.b.ui.roi_threshold_reward)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function reward_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reward_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sea_world_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to sea_world_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sea_world_threshold as text
%        str2double(get(hObject,'String')) returns contents of sea_world_threshold as a double
try
    handles.b.ui.roi_threshold_sea = str2double(get(hObject, 'String')); %integer
    if isnan(handles.b.ui.roi_threshold_sea) || (handles.b.ui.roi_threshold_sea <= 0)
        msgbox('Please enter an integer > 0...', 'Error entering threshold');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold: ',num2str(handles.b.ui.roi_threshold_sea)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sea_world_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sea_world_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BOLD.
function BOLD_Callback(hObject, eventdata, handles)
% hObject    handle to BOLD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BOLD
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isBOLD =1 ;
        handles.b.flag.iscoefcorr = 0 ;
        set(handles.BOLD, 'value',1);
        set(handles.corr_coef, 'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback Calulated using: ','BOLD values'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in corr_coef.
function corr_coef_Callback(hObject, eventdata, handles)
% hObject    handle to corr_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of corr_coef
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isBOLD =0 ;
        handles.b.flag.iscoefcorr = 1 ;
        set(handles.BOLD, 'value',0);
        set(handles.corr_coef, 'value',1);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback Calulated using: ','Correlation coefficient values'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);



function intermediate_freq_Callback(hObject, eventdata, handles)
% hObject    handle to intermediate_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of intermediate_freq as text
%        str2double(get(hObject,'String')) returns contents of intermediate_freq as a double
try
    handles.b.ui.inter_thresh= str2num(  get(hObject, 'String')  ); %integer
    
    
    if sum(isnan(handles.b.ui.inter_thresh))>0 || sum((handles.b.ui.inter_thresh< 0))>0
        msgbox('Please enter an integer > 0...', 'Error entering TR');
        handles.b.flag.isvalidinput = 'NO';
        return;
    end
    
    if size(handles.b.ui.inter_thresh,2)>1
        if handles.b.ui.inter_thresh(1)-handles.b.ui.inter_thresh(2)<2
            
            msgbox('There should be difference of two TRs between Intermediate Freq and Number of  Threshold TRs.', 'Error entering TR');
            handles.b.flag.isvalidinput = 'NO';
            return
        end
        handles.b.flag.istrend_reg=1;
        handles.b.ui.inter_TR=handles.b.ui.inter_thresh(1);
        handles.b.ui.thresh_feed=handles.b.ui.inter_thresh(2);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Intermediate Frequency (TR): ',num2str(handles.b.ui.inter_thresh(1))] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold TRs: ',num2str(handles.b.ui.inter_thresh(2))] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
    else
        handles.b.ui.inter_TR=handles.b.ui.inter_thresh(1);
        handles.b.ui.thresh_feed=0;
        handles.b.flag.istrend_reg=0;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Intermediate Frequency (TR): ',num2str(handles.b.ui.inter_TR)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Threshold TRs: ',num2str(handles.b.ui.thresh_feed)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
    end
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function intermediate_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intermediate_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in session_type.
function session_type_Callback(hObject, eventdata, handles)
% hObject    handle to session_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_type
try
    val=get(handles.session_type,'value');
    str=get(handles.session_type,'string');
    handles.b.session_type=str{val};
    if strcmp( handles.b.session_type,'Dummy Functional Run')
        if isfield(handles.b,'Feedback')
            if ~isfield(handles.b.Feedback,'dummy_idx')
                handles.b.Feedback.dummy_idx=1;
            else
                handles.b.Feedback.dummy_idx=handles.b.Feedback.dummy_idx+1;
            end
        else
            handles.b.Feedback.dummy_idx=1;
        end
    elseif strcmp( handles.b.session_type,'Localizer Collect Data') || strcmp( handles.b.session_type,'Localizer Analysis')
        if isfield(handles.b,'Feedback')
            if ~isfield(handles.b.Feedback,'localizer_idx')
                handles.b.Feedback.localizer_idx=1;
            else
                handles.b.Feedback.localizer_idx=handles.b.Feedback.localizer_idx+1;
            end
            handles.b.Feedback.dummy_idx=0;
        else
            handles.b.Feedback.dummy_idx=1;
        end
    elseif strcmp( handles.b.session_type,'Feedback Run')
        if ~isfield(handles.b.Feedback,'feed_idx')
            handles.b.Feedback.feed_idx=1;
        else
            handles.b.Feedback.feed_idx=handles.b.Feedback.feed_idx+1;
        end
    end
    set(handles.session_type, 'BackgroundColor',[1 1 1]);
    handles.b.flag.isvalidinput = 'YES';
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Session Type: ',handles.b.session_type] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function session_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in session_log.
function session_log_Callback(hObject, eventdata, handles)
% hObject    handle to session_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_log


% --- Executes during object creation, after setting all properties.
function session_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in shaping.
function shaping_Callback(hObject, eventdata, handles)
% hObject    handle to shaping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shaping
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isShaping =1 ;
        handles.b.flag.isblock_avg = 0 ;
        set(handles.block_avg, 'value',0);
        set(handles.shaping, 'value',1);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback will be calulated based on: ','moving average'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in block_avg.
function block_avg_Callback(hObject, eventdata, handles)
% hObject    handle to block_avg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block_avg
try
    if (get(hObject, 'Value') == 1)||(get(hObject, 'Value') == 0)
        handles.b.flag.isShaping =0 ;
        handles.b.flag.isblock_avg = 1;
        set(handles.block_avg, 'value',1);
        set(handles.shaping, 'value',0);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Feedback will be calulated based on: ','average baseline block'] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in zero.
function zero_Callback(hObject, eventdata, handles)
% hObject    handle to zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zero
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.isref_zero = true;
        set(handles.half_class,'Value',0);
        set(handles.half,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Reference bar: ','Zero'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.isref_zero = false;
        set(handles.half_class,'Value',1);
        set(handles.half,'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Reference bar: ','Half'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in half.
function half_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.isref_zero = false;
        set(handles.zero_class,'Value',0);
        set(handles.zero,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Reference bar: ','Half'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.isref_zero = true;
        set(handles.zero_class,'Value',1);
        set(handles.zero,'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Reference bar: ','Zero'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in SVM.
function SVM_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isSVM =true;
        handles.b.flag.Classification.isRVM=false;
        set(handles.RVM,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Algorithm: ','SVM'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Algorithm: ','RVM'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        handles.b.flag.Classification.isRVM= true;
        handles.b.flag.Classification.isSVM =false;
        set(handles.RVM,'Value',1);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in RVM.
function RVM_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isRVM =true;
        handles.b.flag.Classification.isSVM=false;
        set(handles.SVM,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Algorithm: ','RVM'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.isSVM= true;
        handles.b.flag.Classification.isRVM=false;
        set(handles.SVM,'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Algorithm: ','SVM'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in SIC.
function SIC_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isSIC =true;
        handles.b.flag.Classification.isSDC=false;
        set (handles.model_file,'Enable','on');
        set (handles.model_file_edit,'Enable','on');
        set(handles.SDC,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Approach: ','Subject independent classifier'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.isSDC= true;
        handles.b.flag.Classification.isSIC =false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Approach: ','Subject dependent classifier'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set (handles.model_file,'Enable','off');
        set (handles.model_file_edit,'Enable','off');
        set(handles.SDC,'Value',1);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in SDC.
function SDC_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isSDC =true;
        handles.b.flag.Classification.isSIC=false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Approach: ','Subject dependent classifier'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set (handles.model_file,'Enable','off');
        set (handles.model_file_handles.b.pre.current_hdr,'Enable','off');
        set(handles.SIC,'Value',0);
    else
        handles.b.flag.Classification.isSIC= true;
        handles.b.flag.Classification.isSDC =false;
        set(handles.SIC,'Value',1);
        set (handles.model_file,'Enable','on');
        set (handles.model_file_handles.b.pre.current_hdr,'Enable','on');
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification Approach: ','Subject independent classifier'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in Weights.
function Weights_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isWeights =true;
        handles.b.flag.Classification.isper_simi=false;
        set(handles.per_simi,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification feedback based on: ','Weights'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.isper_simi= true;
        handles.b.flag.Classification.isWeights =false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification feedback based on: ','Similarity'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.per_simi,'Value',1);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in per_simi.
function per_simi_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isper_simi =true;
        handles.b.flag.Classification.isWeights=false;
        set(handles.Weights,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification feedback based on: ','Similarity'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        
    else
        handles.b.flag.Classification.isWeights= true;
        handles.b.flag.Classification.isper_simi =false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Classification feedback based on: ','Weights'] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.Weights,'Value',1);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in classification model.
function class_model_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.iscreate_model =true;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= 'Creating Model...' ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.iscreate_model =false;
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in training_data.
function training_data_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.istraining_data =true;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Collecting data for classifier training..';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.istraining_data =false;
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes on button press in realgnment.
function realign_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isrealignment =true;
        handles.b.flag.Classification.isnormalization=false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Online preprocessing: Realignment';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.norma,'Value',0); set(handles.norma_roi,'Value',0);
    else
        handles.b.flag.Classification.isnormalization= true;
        handles.b.flag.Classification.isrealignment =false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Online preprocessing: Normalization';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.norma,'Value',1);set(handles.norma_roi,'Value',1);
        if ~handles.b.flag.isClassification
            if handles.b.flag.islocalizer
               text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Dummy functional Run';'Feedback Run'};
               set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Dummy functional Run';'Feedback Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            end
        elseif handles.b.flag.Classification.isSDC
            if handles.b.flag.islocalizer
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            end
        elseif handles.b.flag.Classification.isSIC
            
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Dummy functional Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            
        end
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in normalization.
function norma_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isnormalization =true;
        handles.b.flag.Classification.isrealignment=false;
        set(handles.realign,'Value',0);  set(handles.realign_roi,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Online preprocessing: Normalization';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        if ~handles.b.flag.isClassification
            if handles.b.flag.islocalizer
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Dummy Functional Run';'Feedback Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Dummy Functional Run';'Feedback Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            end
        elseif handles.b.flag.Classification.isSDC
            if handles.b.flag.islocalizer
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            end
        elseif handles.b.flag.Classification.isSIC
           
                text={'Select';'Anatomical Run';'Dummy Functional Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            
        end
    else
        handles.b.flag.Classification.isrealignment= true;
        handles.b.flag.Classification.isnormalization=false;
        set(handles.realign,'Value',1);set(handles.realign_roi,'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Online preprocessing: Realignment';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        if ~handles.b.flag.isClassification
            if handles.b.flag.islocalizer
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Feedback Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Feedback Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            end
        elseif handles.b.flag.Classification.isSDC
            if handles.b.flag.islocalizer
                text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
            else
                text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                
            end
        elseif handles.b.flag.Classification.isSIC
                text={'Select';'Anatomical Run';'Dummy Functional Run';'Classification Run'};
                set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        end
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);


% --- Executes on button press in model_file.
function model_file_Callback(hObject, eventdata, handles)
% hObject    handle to model_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [model_file, file_path]=uigetfile('*.mat','Please select classification model file');
    if(isempty(deblank(model_file)))
        msgbox('Please select again...', 'Error selecting model file');
        handles.b.isvalidinput = 'NO';
        return
    end
    handles.b.flag.classification.model_file=[file_path,filesep,model_file];
    set(handles.model_file_edit, 'String', handles.b.flag.classification.model_file);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  ['Model selected:' model_file];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

function model_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to model_file_handles.b.pre.current_hdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of model_file_handles.b.pre.current_hdr as text
%        str2double(get(hObject,'String')) returns contents of model_file_handles.b.pre.current_hdr as a double
try
    handles.b.flag.classification.model_file=get(hObject, 'String');
    if(isempty(deblank(model_file)))
        msgbox('Please select again...', 'Error selecting model file');
        handles.b.isvalidinput = 'NO';
        return
    end
    [~,model_file]=fileparts(handles.b.flag.classification.model_file);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  ['Model selected:' model_file];
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function model_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to model_file_handles.b.pre.current_hdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: handles.b.pre.current_hdr controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in realgnment.
function session_align_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isrealignment_ref_session =true;
        handles.b.flag.Classification.isrealignment_ref_run=false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Reference Realignment: first EPI of the session';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.session,'Value',0); set(handles.session_roi,'Value',0);
    else
        handles.b.flag.Classification.isrealignment_ref_run= true;
        handles.b.flag.Classification.isrealignment_ref_session =false;
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Reference Realignment: first EPI of each Run';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
        set(handles.run,'Value',1);set(handles.run_roi,'Value',1);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes on button press in normalization.
function run_align_Callback(hObject, eventdata, handles)
% hObject    handle to half (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of half
try
    if (get(hObject, 'Value') == 1)
        handles.b.flag.Classification.isrealignment_ref_run =true;
        handles.b.flag.Classification.isrealignment_ref_session=false;
        set(handles.run,'Value',0);  set(handles.run_roi,'Value',0);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Reference Realignment: first EPI of each Run';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    else
        handles.b.flag.Classification.isrealignment_ref_session= true;
        handles.b.flag.Classification.isrealignment_ref_run=false;
        set(handles.session,'Value',1);set(handles.session_roi,'Value',1);
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Reference Realignment: first EPI of the session';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);





% --- Executes when user attempts to close bcigui.
function bcigui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to bcigui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    delete(hObject);
    delete(handles.b.figures.figure_session_log);
    close all
catch ME
    handles=error_log_display(handles,ME);
end


function neuro_stimuli_run_Callback(hObject, eventdata, handles)
% hObject    handle to neuro_stimuli_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuro_stimuli_run as text
%        str2double(get(hObject,'String')) returns contents of neuro_stimuli_run as a double
try
    handles.b.pre.neuro_run_num_str=get(hObject, 'String');
    if ~handles.b.flag.isstimuli_cont
        if handles.b.conf.session==1
            handles.b.conf.neuro_run_num = fix(str2double(get(hObject, 'String'))); %integer
            
        else
            handles.b.conf.neuro_run_num =sum(handles.b.conf.session_run_num(1:handles.b.conf.session-1)) + fix(str2num(handles.b.pre.neuro_run_num_str)); %integer
        end
    else
        if handles.b.conf.session==1
            
            handles.b.conf.neuro_run_num = (sum(handles.b.conf.session_run_num(1:end))- fix(str2double(get(hObject, 'String'))))+1; %integer
            
        else
            handles.b.conf.neuro_run_num =(sum(handles.b.conf.session_run_num(1:end))+1)-sum(handles.b.conf.session_run_num(1:handles.b.conf.session-1)) - fix(str2num(handles.b.pre.neuro_run_num_str)); %integer
        end
    end
    if ~isnan(handles.b.conf.neuro_run_num)
        if   (handles.b.conf.neuro_run_num <= 0)
            msgbox('Please enter an integer > 0...', 'Error entering run number');
            handles.b.flag.isvalidinput = 'NO';
            return
        end
        set(handles.neuro_stimuli_run,'BackgroundColor',[1 1 1] );
        
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= ['Neurofeedback Run number: ',num2str(handles.b.conf.neuro_run_num)] ;
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
       % handles.b.flag.islocalizer=false;
        % Update handles structure
        handles.b.flag.isvalidinput = 'YES';
        guidata(hObject, handles);
        
        
    else
       % handles.b.flag.islocalizer=true;
        set(handles.neuro_stimuli_run,'BackgroundColor',[1 1 1] );
        figure(handles.b.figures.figure_session_log);
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=  'Current Run is a localizer run';
        set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    end
    if isfield(handles.b.conf, 'neuro_run_num')
        fid =fopen([handles.b.conf.output_dir,filesep,'current_run.txt'],'w+');
        fprintf(fid,'%s', [handles.b.conf.output_dir_stimulus_PC,filesep,'Run_',sprintf('%02i',handles.b.conf.neuro_run_num),'.txt']);
        fclose(fid);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function neuro_stimuli_run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuro_stimuli_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function session_Callback(hObject, eventdata, handles)
% hObject    handle to session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of session as text
%        str2double(get(hObject,'String')) returns contents of session as a double
try
    handles.b.conf.session=str2num(get(hObject,'string'));
    if isempty(handles.b.conf.session) && handles.b.conf.session<=0
        
        msgbox('Please enter an integer > 0...', 'Error entering run number');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    set(handles.session,'BackgroundColor',[1 1 1])
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [' Session number: ',num2str(handles.b.conf.session)] ;
    set(handles.session_log,'string',handles.b.session_log_str,'value',length(handles.b.session_log_str));
    if handles.b.flag.TBV
        set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
        set(handles.session_type,'Enable','off');
        handles.b.session_type='None';
    elseif ~handles.b.flag.isClassification % no TBV no Classification
        if handles.b.flag.islocalizer && handles.b.conf.session==1
%             set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
            text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Dummy Functional Run';'Feedback Run'};
            set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        else
          %  set(handles.tgroup,'SelectedTab',handles.roi_feedback_tab )
            text={'Select';'Anatomical Run';'Dummy Functional Run';'Feedback Run'};
            set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        end
    elseif handles.b.flag.isClassification %Classification
        set(handles.tgroup,'SelectedTab',handles.classification_tab );
        if handles.b.flag.Classification.isSIC
            text={'Select';'Anatomical Run';'Dummy Functional Run';'Classification Run'};
            set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
        elseif handles.b.flag.Classification.isSDC
            if handles.b.flag.islocalizer
                if handles.b.flag.isrealignment
                    text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                elseif handles.b.flag.isnormalization
                    text={'Select';'Anatomical Run';'Localizer Collect Data';'Localizer Analysis';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                end
            else
                if handles.b.flag.isrealignment
                    text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                elseif handles.b.flag.isnormalization
                    text={'Select';'Anatomical Run';'Training Run';'Classification Run'};
                    set(handles.session_type,'string',text, 'BackgroundColor',[255 35 35]/255);
                end
            end
        end
    end
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function session_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function study_Callback(hObject, eventdata, handles)
% hObject    handle to study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of study as text
%        str2double(get(hObject,'String')) returns contents of study as a double
try
    handles.b.conf.study=get(hObject,'string');
    if isempty(handles.b.conf.study)
        
        msgbox('Please enter an string', 'Error entering study name');
        handles.b.flag.isvalidinput = 'NO';
        return
    end
    % Update handles structure
    handles.b.flag.isvalidinput = 'YES';
catch ME
    handles=error_log_display(handles,ME);
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function study_CreateFcn(hObject, eventdata, handles)
% hObject    handle to study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function session_close_fcn(hObject, eventdata, handles)
% hObject    handle to study (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of study as text
%        str2double(get(hObject,'String')) returns contents of study as a double
try
    if isfield(handles,'bcigui')
        pre = '<HTML><FONT color="';
        post = '</FONT></HTML>';
        figure(handles.b.figures.figure_session_log);
        %handles.b.session_log_str{length(handles.b.session_log_str)+1,1}=' test  ';
        handles.b.session_log_str{length(handles.b.session_log_str)+1,1}= [pre ,rgb2Hex( [255 128 0] ), '">' ,'Please do not close session log box',post];
        set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
        
    else
        close(handles.b.figures.figure_session_log);
    end
catch ME
    handles=error_log_display(handles,ME);
end
guidata(handles.bcigui, handles);
