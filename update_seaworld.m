function update_seaworld(step, cur_moves, isActivation, is_new_start, isTransfer)

global seaworld posT posF posF2 posout s1 existYelFish;
global num_hits;
fishProximity = 40; %x-coord close to the fish 
fish2Proximity = 18;


%if it is not an activation block and it is a new start, return after refreshing the fish to the
%center, else just return
if(strcmp(isActivation, 'NO') & strcmp(is_new_start, 'YES'))
    refresh_seaworld(isActivation,isTransfer);
    return;
elseif(strcmp(isActivation, 'NO') & strcmp(is_new_start, 'NO'))
    return;
end

%set the initial positions of the Fish (this is the food) and Tuna (this is the big fish)
if (strcmp(is_new_start, 'YES'))
     refresh_seaworld(isActivation,isTransfer);   
end


%only do feedback if not in a transfer mode
if(strcmp(isTransfer, 'NO'))
    
    if (cur_moves > 0) %forward motion
        seaworld.MoveTuna.rotation =[0 1 0 1.57];
        vrdrawnow
	elseif(cur_moves < 0) %reverse motion
        step = step * -1;
        seaworld.MoveTuna.rotation =[0 1 0 -1.57];
        vrdrawnow
	end
	for i = 1:abs(cur_moves)         %motion
        posT(1) = posT(1) + step;
        %vrdrawnow
        %here don't allow the Tuna to pass out of the scene
        if (posT(1) < -40)
            posT(1) = -40;
        elseif (posT(1) > fishProximity)
            posT(1) = fishProximity;
        end
        
        seaworld.MoveTuna.translation = posT;
        
        if (posT(1) > fish2Proximity) & (step > 0) & (strcmp(isActivation, 'YES') & (strcmp(existYelFish, 'YES')))
            existYelFish = 'NO';
            num_hits = num_hits + 1;  %1 points for eating yellow fish
            seaworld.MoveFish2.translation = posout; % the yellow fish disappears it has been eaten
            %wavplay(s1, 11025,'async');
            vrdrawnow
            pause(0.1); %pause to allow the subject to register a kill!
            
        end
        
        
        if (posT(1) == fishProximity) & (step > 0) & (strcmp(isActivation, 'YES'))  
            num_hits = num_hits + 2; %2 points for eating red fish
            seaworld.MoveFish.translation = posout; % the red fish disappears it has been eaten
            vrdrawnow
            %wavplay(s1, 11025,'async');
            fprintf('\n\nGot a hit! Total hits till now: %d\n\n', num_hits);
            pause(0.1); %pause to allow the subject to register a kill!
            refresh_seaworld(isActivation,isTransfer); %seaworld refreshed to set new positions for tuna and fish
        end
        vrdrawnow
	end
end

