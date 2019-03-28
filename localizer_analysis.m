function handles=localizer_analysis(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Performs GLM to identify voxels belonging to the target brain region.
%BCI data structure will be passed in as the argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 try
    pathnames=uigetdir2(handles.b.conf.target_subj_path,'Select data for localization analysis');
    if isempty(pathnames)
        msgbox('Please select the preprocessed Localizer data')
        pathnames=uigetdir2(handles.b.conf.target_subj_path,'Select data for localization analysis');
        if isempty(pathnames)
            return
        end
    end
    for fol=1:length(pathnames)
        folder_seq(fol)=str2num(pathnames{fol}(end)); %#ok<ST2NM>
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Selected Localizer directories...';
    for ii=1:length(pathnames)
        handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= pathnames{ii};
    end
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Reslicing realigned images...';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    pause(1)
    [aa,bb]=sort(folder_seq);
    files=ls([pathnames{bb(1)},filesep,'f*.nii']);
    functional_image= [repmat([pathnames{bb(1)}, filesep],length(files),1),files];
     pth=pathnames{bb(1)};
    if handles.b.flag.isrealignment_ref_run
        handles.b.pre.ref_file_vol_data_run=spm_vol(functional_image(1,:));
    else
        handles.b.pre.normalization.ref_file_vol_data=spm_vol(functional_image(1,:));
    end
    for iinn=1:length(pathnames)-1
        clear files
        nnn=size(functional_image,1);
        files=ls([pathnames{bb(iinn+1)},filesep,'f*.nii']);
        for ii= 1:length(files) 
            functional_image(nnn+ii,:)= [pathnames{bb(iinn+1)},filesep,files(ii,:)];
            handles.b.current_volume.V=spm_vol(functional_image(nnn+ii,:));
            [handles]=sic_realign(handles);
        end
    end
    sic_reslice(functional_image,handles.b.pre.realign_rs_opt);
    [pth,nm,xt] = fileparts(deblank(functional_image(1,:)));
    handles.b.pre.normalization.spm_mean_img= [pth,filesep,'mean',nm,xt];
    if  handles.b.conf.session==1 % && handles.b.Feedback.localizer_idx==1
        copyfile([pth,filesep,'mean',nm,xt], [handles.b.pre.original_file_path,filesep,'mean',nm,xt]);
        handles.b.pre.normalization.initial_functional_image=[handles.b.pre.original_file_path,filesep,'mean',nm,xt];
        handles.b.pre.ori.initial_mean_file=[handles.b.pre.original_file_path,filesep,'mean',nm,xt];
       % handles.b.localizer.P{1}=[handles.b.pre.original_file_path,filesep,'mean',nm,xt];
    end
%     delete(handles.b.figures.image_vis_fig);
%     delete(handles.b.figures.feedback_fig);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Reallignment finished.' ;
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= 'Calculating Normalization parameters.' ;
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    pause(1)  
    handles=norm_parameters(handles);
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Normalization parameters calculated..';
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Normalizing the images..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    pause(1)   
    for inii= 1:length(pathnames)
        files1=ls([pathnames{inii},filesep,'rf*.nii']);
        if inii==1
            files=[repmat([pathnames{inii},filesep], size(files1,1),1),files1];
            clear files1
        else
            files(size(files,1)+1:size(files,1)+size(files1,1),:)=[repmat([pathnames{inii},filesep], size(files1,1),1),files1];
            clear files1
        end
    end
    for ii=1:length(files)
        handles.b.current_volume.V=spm_vol(files(ii,:));
        [~,handles.b.current_volume.volume_norm,NO] =write_file(handles.b.current_volume.V,handles.b.pre.normalization.norm_Def,handles.b.pre.normalization.norm_mat,handles.b.pre.normalization.norm_defs.out{1}.pull,handles.b.pre.normalization.norm_interp,handles.b.pre.normalization.norm_msk);
        NO.dat(:,:,:,1,1,1) = handles.b.current_volume.volume_norm;
    end
    clear files;
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Normalizing finished..';
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Smoothing the images..'
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    pause(1)
  
    for inii= 1:length(pathnames)
        files=ls([pathnames{inii},filesep,'wrf*.nii']);
        for ii=1:length(files)
            spm_smooth([pathnames{inii},filesep,files(ii,:)] ,[pathnames{inii}, filesep,'s',files(ii,:)],[6 6 6])
        end
        clear files
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Smoothing finished..';
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Performing GLM analysis..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
   
    mkdir([pth,filesep,'SPM']);
    SPM.swd=[pth,filesep,'SPM'];
    pth1=SPM.swd;
    SPM.xY.RT=1.5;% change
    for inii= 1:length(pathnames)
        files=ls([pathnames{inii},filesep,'wrf*.nii']);
        if inii==1
             SPM.xY.P=[repmat([pathnames{inii}, filesep,'s'],size(files,1),1),files];
        else
             SPM.xY.P(size(SPM.xY.P,1)+1:size(SPM.xY.P,1)+size(files,1),:)=[repmat([pathnames{inii}, filesep,'s'],size(files,1),1),files];
        end
         SPM.nscan(1,inii)=size(files,1);
        clear files
    end
    SPM.xBF.Volterra=1;
    SPM.xBF.UNITS='scans';
    SPM.xBF.T=16;
    SPM.xBF.T0=8;
    SPM.xBF.name='hrf';
   
    for sess=1:handles.b.conf.Localizer_run_num
        for ii=1:length(handles.b.pre.glm_cond)
            SPM.Sess(sess).U(ii).name={handles.b.proto.cond(handles.b.pre.glm_cond(ii)).name};
            aa=[]; ab=[];
            for in=1:length(handles.b.proto.cond(ii).block)
                aa(in)=handles.b.proto.cond(ii).block{in}(1);
                ab(in)=handles.b.proto.cond(ii).block{in}(2)-handles.b.proto.cond(ii).block{in}(1);
            end
            SPM.Sess(sess).U(ii).ons=aa;
            SPM.Sess(sess).U(ii).dur=ab;
            SPM.Sess(sess).U(ii).orth=1;
            SPM.Sess(sess).U(ii).P.name='none';
            SPM.Sess(sess).U(ii).P.h=0;
            SPM.Sess(sess).C.C= [];
            SPM.Sess(sess).C.name={};
        end
    end
    SPM.factor=[];
    SPM.xGX.iGXcalc='None';
    SPM.xM.gMT=0.8;
    SPM.xX.K.HParam=128;
    SPM.xVi.form='AR(1)';
    SPM = spm_fMRI_design(SPM,1,pth1);
    nscan = SPM.nscan;
    nsess = length(nscan);
    HParam     = [SPM.xX.K(:).HParam];
    if length(HParam) == 1
        HParam = repmat(HParam,1,nsess);
    end
    %-Create and set filter structure
    %--------------------------------------------------------------------------
    for  i = 1:nsess
        K(i) = struct('HParam', HParam(i),...
            'row',    SPM.Sess(i).row,...
            'RT',     SPM.xY.RT);
    end
    SPM.xX.K = spm_filter(K);
    try
        cVi  = SPM.xVi.form;
    catch
        error('Serial correlations not specified.');
    end
    % otherwise assume AR(0.2) in xVi.Vi
    %--------------------------------------------------------------
    SPM.xVi.Vi = spm_Ce('ar',nscan,0.2);
    cVi        = 'AR(0.2)';
    SPM.xVi.form = cVi;
    VY    = spm_data_hdr_read(SPM.xY.P);
    %-Check internal consistency of images
    %--------------------------------------------------------------------------
    spm_check_orientations(VY);
    
    %-Place mapped files in xY
    %--------------------------------------------------------------------------
    SPM.xY.VY = VY;
    %-Compute Global variate
    %==========================================================================
    GM    = 100;
    q     = length(VY);
    g     = zeros(q,1);
%     fprintf('%-40s: ','Calculating globals')                                %-#
%     spm_progress_bar('Init',q,'Calculating globals');
    if spm_mesh_detect(VY)
        for i = 1:q
            dat = spm_data_read(VY(i));
            g(i) = mean(dat(~isnan(dat)));
%             spm_progress_bar('Set',i)
        end
    else
        for i = 1:q
            g(i) = spm_global(VY(i));
%             spm_progress_bar('Set',i)
        end
    end
%     spm_progress_bar('Clear');
%     fprintf('%30s\n','...done')                                             %-#
    
    %-Scale if specified (otherwise session specific grand mean scaling)
    %--------------------------------------------------------------------------
    gSF   = GM./g;
    if strcmpi(SPM.xGX.iGXcalc,'none')
        for i = 1:nsess
            gSF(SPM.Sess(i).row) = GM./mean(g(SPM.Sess(i).row));
        end
    end
    
    %-Apply gSF to memory-mapped scalefactors to implement scaling
    %--------------------------------------------------------------------------
    for i = 1:q
        SPM.xY.VY(i).pinfo(1:2,:) = SPM.xY.VY(i).pinfo(1:2,:) * gSF(i);
        if spm_mesh_detect(VY)
            SPM.xY.VY(i).private.private.data{1}.data.scl_slope = ...
                SPM.xY.VY(i).private.private.data{1}.data.scl_slope * gSF(i);
            SPM.xY.VY(i).private.private.data{1}.data.scl_inter = ...
                SPM.xY.VY(i).private.private.data{1}.data.scl_inter * gSF(i);
        else
            SPM.xY.VY(i).private.dat.scl_slope = ...
                SPM.xY.VY(i).private.dat.scl_slope * gSF(i);
            SPM.xY.VY(i).private.dat.scl_inter = ...
                SPM.xY.VY(i).private.dat.scl_inter * gSF(i);
        end
    end
    
    %-Place global variates in xGX
    %--------------------------------------------------------------------------
    SPM.xGX.sGXcalc = 'mean voxel value';
    SPM.xGX.sGMsca  = 'session specific';
    SPM.xGX.rg      = g;
    SPM.xGX.GM      = GM;
    SPM.xGX.gSF     = gSF;
    %masking 
    try
        gMT = SPM.xM.gMT;
    catch
        gMT = spm_get_defaults('mask.thresh');
    end
    TH = g.*gSF*gMT;
    %-Place masking structure in xM
    %--------------------------------------------------------------------------
    SPM.xM = struct(...
        'T',   ones(q,1),...
        'TH',  TH,...
        'gMT', gMT,...
        'I',   0,...
        'VM',  {[]},...
        'xs',  struct('Masking','analysis threshold'));
    
    
    %-Design description - for saving and display
    %==========================================================================
    xs = struct(...
        'Global_calculation',   SPM.xGX.sGXcalc,...
        'Grand_mean_scaling',   SPM.xGX.sGMsca,...
        'Global_normalisation', SPM.xGX.iGXcalc);
    for fn=(fieldnames(xs))', SPM.xsDes.(fn{1}) = xs.(fn{1}); end

    save([pth1,filesep,'SPM.mat'], 'SPM', spm_get_defaults('mat.format'));
    SPM = spm_spm(SPM,pth1);%estimate
    SPM.swd=pth1;
    [Ic,xCon] = spm_conman(SPM,'T&F',Inf,...
                           '    Select contrasts...',' for conjunction',1);
    %cd(handles.b.conf.current_dir);
    SPM.xCon=xCon;
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='Contrast selected..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));

  
        %-Estimate constrasts
        %------------------------------------------------------------------
    Mask=0;    
    Im = [];
    IcAdd=[];
    pm = [];
    Ex = [];
    str  = xCon(1).name;
    titlestr =str;
    mstr = 'masked [incl.] by';
    SPM  = spm_contrasts(SPM, unique([Ic, Im, IcAdd]),pth1);
    xX   = SPM.xX;                      %-Design definition structure
    XYZ  = SPM.xVol.XYZ; n=1;   R    = SPM.xVol.R;   S    = SPM.xVol.S;
    M    = SPM.xVol.M(1:3,1:3);  VOX  = sqrt(diag(M'*M))';   
    xCon     = SPM.xCon;
    STAT     = xCon(Ic(1)).STAT;
    VspmSv   = cat(1,xCon(Ic).Vspm);
    df     = [xCon(Ic(1)).eidf xX.erdf];
    str = '';
    STATstr = sprintf('%s%s_{%.0f}','T',str,df(2));
    %-Compute conjunction as minimum of SPMs
    %--------------------------------------------------------------------------
    Z     = Inf;
    for i = Ic
        Z = min(Z,spm_data_read(xCon(i).Vspm,'xyz',XYZ));
    end
    XYZum = XYZ;
    Zum   = Z;
    u   = -Inf;        % height threshold
    k   = 10;           % extent threshold {voxels}
    topoFDR = spm_get_defaults('stats.topoFDR');
    thresDesc ='none';
    u=0.05; %threshold p
    thresDesc = ['p<' num2str(u) ' (unc.)'];
    u = spm_u(u^(1/n),df,STAT);
    if ~spm_mesh_detect(xCon(Ic(1)).Vspm)
        [up,Pp] = spm_uc_peakFDR(0.05,df,STAT,R,n,Zum,XYZum,u);
    else
        [up,Pp] = spm_uc_peakFDR(0.05,df,STAT,R,n,Zum,XYZum,u,G);
    end
    if ~spm_mesh_detect(xCon(Ic(1)).Vspm)
        V2R        = 1/prod(SPM.xVol.FWHM(SPM.xVol.DIM > 1));
        [uc,Pc,ue] = spm_uc_clusterFDR(0.05,df,STAT,R,n,Zum,XYZum,V2R,u);
    else
        V2R        = 1/prod(SPM.xVol.FWHM);
        [uc,Pc,ue] = spm_uc_clusterFDR(0.05,df,STAT,R,n,Zum,XYZum,V2R,u,G);
    end
    uu      = spm_uc(0.05,df,STAT,R,n,S);
    if spm_mesh_detect(xCon(Ic(1)).Vspm), str = 'vertices'; else str = 'voxels'; end
    Q      = find(Z > u);
    
    %-Apply height threshold
    %--------------------------------------------------------------------------
    Z      = Z(:,Q);
    XYZ    = XYZ(:,Q);
    k=5; %cluster size
    A = spm_clusters(XYZ);
    Q     = [];
    for i = 1:max(A)
        j = find(A == i);
        if length(j) >= k, Q = [Q j]; end
    end
    % ...eliminate voxels
    %----------------------------------------------------------------------
    Z     = Z(:,Q);
    XYZ   = XYZ(:,Q);
    if isempty(Q)
%         fprintf('\n');                                                  %-#
        sw = warning('off','backtrace');
        warning('SPM:NoVoxels','No %s survive extent threshold at k=%0.2g',str,k);
        warning(sw);
    end
    %-Assemble output structures of unfiltered data
    %==========================================================================
    xSPM   = struct( ...
        'swd',      pth1,...
        'title',    titlestr,...
        'Z',        Z,...
        'n',        n,...
        'STAT',     STAT,...
        'df',       df,...
        'STATstr',  STATstr,...
        'Ic',       Ic,...
        'Im',       {Im},...
        'pm',       pm,...
        'Ex',       Ex,...
        'u',        u,...
        'k',        k,...
        'XYZ',      XYZ,...
        'XYZmm',    SPM.xVol.M(1:3,:)*[XYZ; ones(1,size(XYZ,2))],...
        'S',        SPM.xVol.S,...
        'R',        SPM.xVol.R,...
        'FWHM',     SPM.xVol.FWHM,...
        'M',        SPM.xVol.M,...
        'iM',       SPM.xVol.iM,...
        'DIM',      SPM.xVol.DIM,...
        'VOX',      VOX,...
        'Vspm',     VspmSv,...
        'thresDesc',thresDesc);
    try, xSPM.VRpv = SPM.xVol.VRpv; end
    %-Topology for surface-based inference
    %--------------------------------------------------------------------------
    if spm_mesh_detect(xCon(Ic(1)).Vspm)
        xSPM.G     = G;
        xSPM.XYZmm = xSPM.G.vertices(xSPM.XYZ(1,:),:)';
    end
    
    %-p-values for topological and voxel-wise FDR
    %--------------------------------------------------------------------------
    try, xSPM.Ps   = Ps;             end  % voxel   FDR
    try, xSPM.Pp   = Pp;             end  % peak    FDR
    try, xSPM.Pc   = Pc;             end  % cluster FDR
    
    %-0.05 critical thresholds for FWEp, FDRp, FWEc, FDRc
    %--------------------------------------------------------------------------
    try, xSPM.uc   = [uu up ue uc];  end
    M   = SPM.xVol.M;
    DIM = SPM.xVol.DIM;
    datatype = 'Volumetric (2D/3D)';  
    units    = {'mm' 'mm' 'mm'};
    xSPM.units      = units;
    SPM.xVol.units  = units;   
%     [Finter,Fgraph,CmdLine] = spm('FnUIsetup','Stats: Results');
%     spm_clf(Finter);
%     spm('FigName',['SPM{',xSPM.STAT,'}: Results'],Finter,CmdLine);
%     hReg      = spm_results_ui('SetupGUI',M,DIM,xSPM,Finter);
    handles.b.localizer.xSPM=xSPM;
    bci_spm_image('init',spm_vol(handles.b.localizer.P),xSPM);
    handles.b.iserror=0;
    while 1
        if exist([handles.b.pre.original_file_path,filesep,'MNI_coordinate.txt'],'file')==2
            break
        end
        pause(2);
    end
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}='MNI Coordinates are slected for ROIs..';
    set(  handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
   
catch ME
    handles=error_log_display(handles,ME);
    handles.b.iserror=1;
end