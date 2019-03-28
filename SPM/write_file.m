function [ out,dat,NO]=write_file(filename,Def,mat,defs,intrp,msk,handles)
try
    oM = zeros(4,4);
    % Generate headers etc for output images
    %----------------------------------------------------------------------
    if ischar(filename)
        [pth,nam,ext,num] = spm_fileparts(filename);
        NI = nifti(fullfile(pth,[nam ext]));
    else
        [pth,nam,ext,num] = spm_fileparts(filename.fname);
        NI=filename.private;
        num=[];
    end
    j_range = 1:size(NI.dat,4);
    k_range = 1:size(NI.dat,5);
    l_range = 1:size(NI.dat,6);
    if ~isempty(num)
        num = sscanf(num,',%d');
        if numel(num)>=1, j_range = num(1); end
        if numel(num)>=2, k_range = num(2); end
        if numel(num)>=3, l_range = num(3); end
    end
    
    NO = NI;
    wd = pth;
    newprefix  ='w';% spm_get_defaults('normalise.write.prefix');
    NO.descrip = sprintf('Warped');
    NO.dat.fname = fullfile(wd,[newprefix nam ext]);
    dim            = size(Def);
    dim            = dim(1:3);
    NO.dat.dim     = [dim NI.dat.dim(4:end)];
    NO.dat.offset  = 0; % For situations where input .nii images have an extension.
    NO.mat         = mat;
    NO.mat0        = mat;
    NO.mat_intent  = 'Aligned';
    NO.mat0_intent = 'Aligned';
    out= NO.dat.fname;
    NO.extras      = [];
    create(NO);
    
    % Smoothing settings
    vx  = sqrt(sum(mat(1:3,1:3).^2));
    krn = max(defs.fwhm./vx,0.25);
    
    % Loop over volumes within the file
    %----------------------------------------------------------------------
    %fprintf('%s',nam);
    for j=j_range
        
        M0 = NI.mat;
        if ~isempty(NI.extras) && isstruct(NI.extras) && isfield(NI.extras,'mat')
            M1 = NI.extras.mat;
            if size(M1,3) >= j && sum(sum(M1(:,:,j).^2)) ~=0
                M0 = M1(:,:,j);
            end
        end
        M  = inv(M0);
        if ~all(M(:)==oM(:))
            % Generate new deformation (if needed)
            Y     = affine(Def,M);
        end
        oM = M;
        % Write the warped data for this time point
        %------------------------------------------------------------------
        for k=k_range
            for l=l_range
                C   = spm_diffeo('bsplinc',single(NI.dat(:,:,:,j,k,l)),intrp);
                dat = spm_diffeo('bsplins',C,Y,intrp);
                if defs.mask
                    dat(~msk) = -1;
                end
                if sum(defs.fwhm.^2)~=0
                    spm_smooth(dat,dat,krn); % Side effects
                end
                
                %fprintf('\t%d,%d,%d', j,k,l);
            end
        end
    end
catch ME
    figure(handles.b.figures.figure_session_log);
    handles.b.session_log_str{length(  handles.b.session_log_str)+1,1}= ['Error at line ',num2str(ME.stack.line),' in ', ME.stack.name,': ',ME.message];
    set(handles.session_log,'string',  handles.b.session_log_str,'value',length(  handles.b.session_log_str));
    
end
