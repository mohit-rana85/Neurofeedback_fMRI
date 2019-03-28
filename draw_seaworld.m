function draw_seaworld(isTransfer)

vrsetpref('DefaultFigureTooltips','off'); %to remove the VR navigation tool bar

global num_hits; %number of times the Tuna ate the Fish
                     
global seaworld s1;

%initialize
num_hits = 0;

seaworld = vrworld('seaworld.wrl'); %load the .wrl file

s1 = wavread('eat');

%set(seaworld,'TimeSource','freerun'); %set external timing

open(seaworld)

isActivation = 'NO';
refresh_seaworld(isActivation,isTransfer);

view(seaworld);

%allow time for arranging the window
%uiwait(msgbox('Please arrange the VR window and press OK to start', 'Attention!'));