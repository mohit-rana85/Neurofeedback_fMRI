function status = vanish_thermo(yes)
global last_gobjects;

%first delete the grads
vanish_grads(yes);

% %delete the condition image
% set(last_gobjects.image, 'Visible', 'off');
% last_gobjects.image = 0;

%then delete the thermo
if(last_gobjects.thermo ~= 0)
	t = size(last_gobjects.thermo,2);
    for id = 1:t
        if(yes)
	        set(last_gobjects.thermo(id), 'Visible', 'off');
        else
            set(last_gobjects.thermo(id), 'Visible', 'on');
        end
    end
    last_gobjects.thermo = 0; %to be safe
end

status = 1;
return;