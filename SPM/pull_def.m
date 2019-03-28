  function  [intrp,msk]=pull_def(Def,mat,job)

PI      = job.fnames;
intrp   = job.interp;
intrp   = [intrp*[1 1 1], 0 0 0];
out     = cell(numel(PI),1);

if numel(PI)==0, return; end

if job.mask
    oM  = zeros(4,4);
    odm = zeros(1,3);
    dim = size(Def);
    msk = true(dim);
    for m=1:1%numel(PI)
        [pth,nam,ext,num] = spm_fileparts(PI{m});
        NI = nifti(fullfile(pth,[nam ext]));
        dm = NI.dat.dim(1:3);
        if isempty(num)
            j_range = 1:size(NI.dat,4);
        else
            num     = sscanf(num,',%d');
            j_range = num(1);
        end
        for j=j_range

            M0 = NI.mat;
            if ~isempty(NI.extras) && isstruct(NI.extras) && isfield(NI.extras,'mat')
                M1 = NI.extras.mat;
                if size(M1,3) >= j && sum(sum(M1(:,:,j).^2)) ~=0
                    M0 = M1(:,:,j);
                end
            end
            M   = inv(M0);
            if ~all(M(:)==oM(:)) || ~all(dm==odm)
                tmp = affine(Def,M);
                msk = tmp(:,:,:,1)>=1 & tmp(:,:,:,1)<=size(NI.dat,1) ...
                    & tmp(:,:,:,2)>=1 & tmp(:,:,:,2)<=size(NI.dat,2) ...
                    & tmp(:,:,:,3)>=1 & tmp(:,:,:,3)<=size(NI.dat,3);
            end
            oM  = M;
            odm = dm;
        end
    end
end



