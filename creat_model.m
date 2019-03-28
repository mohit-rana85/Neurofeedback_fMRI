function  handles=creat_model(handles)
if iscell(handles.b.classification.training_files)
    for ii=1:handles.b.classification.training_files
        load([handles.b.classification.training_path,handles.b.classification.training_files{ii}])
        if ii==1
            training_data_complete=ztrans(training_data,2);
            training_label_complete=training_label;
        else
            training_data_complete(:,size(training_data_complete,2)+1:size(training_data_complete,2)+ size(traning_data,2))=ztrans(training_data,2);
            training_label_complete(:,size(training_label_complete,2)+1:size(training_label_complete,2)+ size(traning_label,2))=training_label;
        end 
        clear training_data training_label
    end
else
     for ii=1:handles.b.classification.training_files
        load([handles.b.classification.training_path,handles.b.classification.training_files(ii)])
        if ii==1
            training_data_complete=ztrans(training_data,2);
            training_label_complete=training_label;
        else
            training_data_complete(:,size(training_data_complete,2)+1:size(training_data_complete,2)+ size(traning_data,2))=ztrans(training_data,2);
            training_label_complete(:,size(training_label_complete,2)+1:size(training_label_complete,2)+ size(traning_label,2))=training_label;
        end 
        clear training_data training_label
     end
end

