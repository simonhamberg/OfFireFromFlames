clear; clc; close all;

%Variables
while true
vBall = [1,0];
posBall = [20,50];

pongFigure = figure('color',[.1 .8 .8], 'KeyPressFcn',@keyboardFunction);
pongAxes = axes('color','black','xLim',[0,100],'yLim',[-5,100]);
pongBall = line(posBall(1),posBall(2),'marker','.','markersize',20,'color',[.1 .8 .8]);
pongBlock = line(0,0,[45 55], 'linewidth',2);

global PauseGame;
PauseGame = 1;


global Restart;
Restart = 0;

global Quit;
Quit = 0;

global blockCenter;
blockCenter = 45;
block1 = line([2,2],[blockCenter-5, blockCenter+5],'linewidth',2);
global blockCenter2;
blockCenter2 = 45;
block2 = line([100-2,100-2],[blockCenter2-5, blockCenter2+5],'linewidth',2);

%Loop
while true
    while PauseGame > 0
        set(gcf,'color','white');
        xlabel('PAUSED player1 [W,S] player2 [O,L] p = pause/unpause','fontsize',15)
        pause(.2)
    end
    set(gcf,'color','b');
     xlabel('PONG', 'fontsize', 10)
    %Vilkor för vägg
    if posBall(2) <= 0 || posBall(2) >= 100
        vBall(2) = -vBall(2);
    end
    %Player point-----------------
    if posBall(1) <= 0
       %Color change
       set(gcf,'color','r');
       xlabel('Player 2 scores!', 'fontsize', 20)
       Run = 0;
       vBall=[0,0];
       break
    end
    if posBall(1) >= 100
       %Color change
       set(gcf,'color','r');
       xlabel('Player 1 scores!', 'fontsize', 20)
       Run = 0;
       vBall=[0,0];
       break
    end
    %----------------------
    %interacting with block
    %Player 1
    if (blockCenter-5) < posBall(2)
        if blockCenter > posBall(2)
             if posBall(1) < 2
                    vBall(1) = -vBall(1);
                    vBall(2) = vBall(2) -0.1;
             end
        end
        if posBall(2) < (blockCenter+5)
            if blockCenter < posBall(2)
                if posBall(1) < 2
                   vBall(1) = -vBall(1);
                   vBall(2) = vBall(2) +0.1;
                end
            end
        end
    end
    %Player 2
    if (blockCenter2-5) < posBall(2)
        if blockCenter2 > posBall(2)
             if posBall(1) > 98
                    vBall(1) = -vBall(1);
                    vBall(2) = vBall(2) -0.1;
             end
        end
        if posBall(2) < (blockCenter2+5)
            if blockCenter2 < posBall(2)
                if posBall(1) > 98
                   vBall(1) = -vBall(1);
                   vBall(2) = vBall(2) +0.1;
                end
            end
        end
    end
    
    posBall = posBall + vBall;
    set(pongBall,'XData', posBall(1),'YData', posBall(2))
    
    set(block1,'yData',[blockCenter-5, blockCenter+5])
    pause(.01);
    set(block2,'yData',[blockCenter2-5, blockCenter2+5])
    pause(.01);
end

% Restart
xlabel('Press "r" to restart', 'fontsize', 20)
pause(2);

while Restart < 1
        pause(.2)
end
end
function keyboardFunction(~,event)
global PauseGame
global blockCenter
global Restart
global blockCenter2
        
switch event.Key
    case 's'
        blockCenter = blockCenter -2;
    case 'w'
        blockCenter = blockCenter +2;
    case 'o'
        blockCenter2 = blockCenter2 +2;
    case 'l'
        blockCenter2 = blockCenter2 -2;
    %CASES
    case 's' & 'l'
        blockCenter = blockCenter -2;
        blockCenter2 = blockCenter2 -2;
    case 's' & 'o'
        blockCenter = blockCenter -2;
        blockCenter2 = blockCenter2 +2;
    case 'w' & 'l'
        blockCenter = blockCenter +2;
        blockCenter2 = blockCenter2 -2;
    case 'w' & 'o'
        blockCenter = blockCenter +2;
        blockCenter2 = blockCenter2 +2;
    case 'p'
        if PauseGame == 0
            PauseGame = 1;
        else
            PauseGame = 0;
        end
    case 'r'
        Restart = 1;     
end
end