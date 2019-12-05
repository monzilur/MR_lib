function [XAxisInd,YAxisInd,C_matrix] = raster2image(CellContainingRasterValues,Axis)
%function [XAxisInd,YAxisInd,C_matrix] = raster2image(CellContainingRasterValues,Axis)
% for i=1:5
%     CellContainingRasterValues{i} = rand(1,73);
% end
%Axis = [0 6 0 1];
xResolution = 0.0001;
circleRadius = 500;

cellNumber = max(size(CellContainingRasterValues));
XAxisInd = Axis(1):xResolution:Axis(2);
yResolution = (Axis(4)-Axis(3))/length(XAxisInd);
YAxisInd = (Axis(3)-0.2):yResolution:Axis(4);
C_matrix = zeros(length(XAxisInd),length(YAxisInd));
%disp(size(C_matrix))
xTick = 0;
for i=1:cellNumber
    xTick = xTick + (Axis(2)-Axis(1))/(cellNumber+1);
    xTicks(i) = xTick;
end
for i=1:cellNumber
    neuron(i) = 0;
    xCenter = find(abs(xTicks(i)-XAxisInd)<=xResolution/10);
    %disp(xCenter)
    xInds = (xCenter-circleRadius):1:(xCenter+circleRadius);
    for j=1:length(CellContainingRasterValues{i})
        currentValue = CellContainingRasterValues{i}(j);
        yCenter = min(find(abs(currentValue-YAxisInd)<=yResolution/2));
        if yCenter
            neuron(i) = neuron(i)+1;
        end
        yInds = (yCenter-circleRadius):1:(yCenter+circleRadius);
        for k=1:length(yInds)
            xEndMinus = round(xCenter - sqrt(circleRadius.^2-(yInds(k)-yCenter).^2));
            xEndPlus = round(xCenter + sqrt(circleRadius.^2-(yInds(k)-yCenter).^2));
            C_matrix(xEndMinus:xEndPlus,yInds(k)) = 5;
        end
    end
end

% colormap([1 1 1;bsxfun(@times,ones(19,1),[0 0 0])]);
% imagesc(XAxisInd,YAxisInd,C_matrix');
% axis xy;
end
    

