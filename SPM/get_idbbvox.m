function [Def,mat] = get_idbbvox(job)
% Get an identity transform based on bounding box and voxel size.
% This will produce a transversal image.
[mat, dim] = spm_get_matdim('', job.vox, job.bb);
Def = identity(dim, mat);
