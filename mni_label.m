function Label_name1=mni_label(cubecoords,handles)
try
    Label_name1='';
    load('.\protocol images\atlas.mat');
   % cubecoords = round(inv(handles.b.pre.mean_VOI.mat)*[mni(1) mni(2) mni(3) 1]');
    
    if ~(cubecoords(1)<0 ||cubecoords(2)<0 ||cubecoords(3)<0 || cubecoords(1)<91 ||  cubecoords(2)<109 ||  cubecoords(3)<91)
        disp('wrong MNI co-ordinate');
        return
    end
    
    for ii=6:8
        
        value=Atlas(ii).Offset;
        sel_atlas=Atlas(ii).Atlas;
        label_value = value + sel_atlas(cubecoords(1), cubecoords(2), cubecoords(3));
        
        found = 0;
        for k=1 : length( Atlas)
            for j=1 : length( Atlas(k).Region)
                for i =1 : length(Atlas(k).Region(j).SubregionValues)
                    if ((Atlas(k).Region(j).SubregionValues(i)+ Atlas(k).Offset) == label_value)
                        found =1;
                        break;
                    end
                end
                if (found)
                    break;
                end
            end
            if(found)
                break;
            end
        end
        if found
            lbl=char(Atlas(k).Region(j).SubregionNames(i)) ;
        else
            lbl='NA';
        end
        if ii==1
            Label_name.BA=lbl;
        elseif ii==2
            Label_name.Lobes=lbl;
        elseif ii==3
            Label_name.Hemispheres=lbl;
        elseif ii==4
            Label_name.Lables=lbl;
        elseif ii==5
            Label_name.Type=lbl;
        elseif ii==6
            Label_name.aal=lbl;
        elseif ii==7
            Label_name.IBASPM71=lbl;
        elseif ii==8
            Label_name.IBASPM116=lbl;
        elseif ii==9
            Label_name.shapes=lbl;
        end
        clear value  sel_atlas label_value
        
    end
    if ~strcmp(Label_name.aal,'NA')
        Label_name1= Label_name.aal;
    elseif ~strcmp(Label_name.IBASPM116,'NA')
        Label_name1= Label_name.IBASPM116;
    elseif ~strcmp(Label_name.IBASPM71,'NA')
        Label_name1= Label_name.IBASPM71;
    else
        Label_name1='NA';
    end
catch ME
    handles=error_log_display(handles,ME);
end