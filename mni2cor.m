function [handles,coordinate_voxels ]= mni2cor(mni , T,roi_size, type,handles)
% function coordinate = mni2cor(mni, T)
% convert mni coordinate to matrix coordinate
%
% mni: a Nx3 matrix of mni coordinate
% T: (optional) transform matrix
% coordinate is the returned coordinate in matrix
%
% caution: if T is not specified, we use:
% T = ...
%     [-4     0     0    84;...
%      0     4     0  -116;...
%      0     0     4   -56;...
%      0     0     0     1];
%
%
try
     coordinate_voxels = [];
if isempty(mni )
    
    coordinate_voxels = [];
    return;
 
    
end

if isempty(T)
    T = ...
        [-4     0     0    84;...
         0     4     0  -116;...
         0     0     4   -56;...
         0     0     0     1];
end
% mni=[0 0 0; 30 30 0]
nn=floor(roi_size(1)/2);
nn1=floor(roi_size(2)/2);
nn2=floor(roi_size(3)/2);
coordinate =[mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
coordinate(:,4) = [];
coordinate = round(coordinate);
handles.b.roi.image_coordinate=coordinate;
coordinate_voxels=zeros(handles.b.pre.normalization.mean_VOI.dim(1)*handles.b.pre.normalization.mean_VOI.dim(2)*handles.b.pre.normalization.mean_VOI.dim(3),1);
handles.b.roi.mask_vox_ss= zeros(handles.b.pre.normalization.mean_VOI.dim(1)*handles.b.pre.normalization.mean_VOI.dim(2)*handles.b.pre.normalization.mean_VOI.dim(3),size((handles.b.roi.MNI),1));
if strcmp(type,'Sphere')
    for iin=1:size(coordinate,1)
     [xx ,yy, zz] = meshgrid(1:handles.b.pre.normalization.mean_VOI.dim(2),1:handles.b.pre.normalization.mean_VOI.dim(1),1:handles.b.pre.normalization.mean_VOI.dim(3));
      vv = sqrt((xx-coordinate(iin,2)).^2+(yy-coordinate(iin,1)).^2+(zz-coordinate(iin,3)).^2)<=floor(roi_size(1)/2);
      for ini=1:handles.b.pre.normalization.mean_VOI.dim(3)
          voxels(:,:,ini)=rot90(vv(:,:,ini),1);
%           if sum(sum(vv(:,:,ini)))>0
%               ini
%               figure, imshow(vv(:,:,ini),[0 4])
%               figure, imshow(voxels(:,:,ini),[0 4])
%           end
      end
      coordinate_voxels (voxels(:)>0)=iin;
      handles.b.roi.mask_vox_ss(:,iin)=(vv(:)>0);
      clear voxels
    end
elseif strcmp(type,'Cube')
    for iin=1:size(coordinate,1) 
      voxels=zeros(handles.b.pre.normalization.mean_VOI.dim(1),handles.b.pre.normalization.mean_VOI.dim(2),handles.b.pre.normalization.mean_VOI.dim(3));
      xx= coordinate(1,1)-nn:1:coordinate(1,1)+nn ;
      yy= coordinate(1,2)-nn1:1:coordinate(1,2)+nn1 ; 
      zz= coordinate(1,3)-nn2:1:coordinate(1,3)+nn2 ;
      comb_voxel=combvec(xx,yy,zz);
      voxels(comb_voxel(1,:),comb_voxel(2,:),comb_voxel(3,:))=1;
      coordinate_voxels (voxels >0)=iin;
      handles.b.roi.mask_vox_ss(:,iin)=(voxels(:)>0);
    end
end
catch ME
    handles=error_log_display(handles,ME);
end