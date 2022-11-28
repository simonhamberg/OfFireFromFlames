function [lineStart,lineEnd]=getWaterBombDirection(x1,x2,y1,y2)
    distance=sqrt((x1-x2)^2+(y1-y2)^2);
    direction(1)=(x1-x2)/distance;
    direction(2)=(y1-y2)/distance;
    waterDirection=null(direction(:).');
    range=150;
    lineStart(1)=(x1-waterDirection(1)*range);
    lineStart(2)=(y1-waterDirection(2)*range);
    lineEnd(1)=(x1+waterDirection(1)*range);
    lineEnd(2)=(y1+waterDirection(2)*range);
%     plot(x1,y1,'go')
%     hold on
%     plot(x2,y2,'ro')
%     hold on
%     plot(lineEnd(1),lineEnd(2),'bo')
%     hold on
%     plot(lineStart(1),lineStart(2),'ko')
%     xlim([0,1000])
%     ylim([0,1000])
end