function refresh_seaworld(isActivation,isTransfer)

global seaworld roiold posT posF posF2 posout s1 existYelFish;

posout = [100 0 0];
% seaworld.MoveTuna.translation = posout; %put the Tuna and the Fish 
% seaworld.MoveFish.translation = posout;
% seaworld.MoveFish2.translation = posout;%outside the field of view

posT = [0 0 -100];     %determines the starting position and the trajectory
posF = [55 0 -100];
posF2 = [30 0 -100];

if(strcmp(isTransfer, 'NO'))
    
    if(strcmp(isActivation, 'YES'))
        seaworld.MoveTuna.translation = posT;
        seaworld.MoveFish.translation = posF;
        seaworld.MoveFish2.translation = posF2;
        existYelFish = 'YES';
    elseif(strcmp(isActivation, 'NO'))
        seaworld.MoveTuna.rotation =[0 1 0 1.57];
        seaworld.MoveTuna.translation = posT;
        seaworld.MoveFish.translation = [100 0 0];
        seaworld.MoveFish2.translation = [100 0 0];%move the fish out of sight if relax/pause
    end
    
elseif(strcmp(isTransfer, 'YES')) 
    if(strcmp(isActivation, 'YES'))
        seaworld.MoveTuna.translation = posout;
        seaworld.MoveFish.translation = posF;
        seaworld.MoveFish2.translation = posF2;
    else
        seaworld.MoveTuna.translation = posout;
        seaworld.MoveFish.translation = posout;
        seaworld.MoveFish2.translation = posout;
    end   
end
vrdrawnow






