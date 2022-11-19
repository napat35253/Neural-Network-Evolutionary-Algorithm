function [pressurePedal,gearChange] = RunFFNN(wIH,wHO,v,vMax,alpha,alphaMax,tempBrake,tempMax,cSigmoid)
    
    inputLayer = [v/vMax alpha/alphaMax tempBrake/tempMax];
    out1 = inputLayer * wIH(1:3,:)-wIH(4,:);
    out2 = (out1 * wHO(:,1:4)')-wHO(:,5)';

    output = 1 ./ (1 + exp(-cSigmoid*out2));
    pressurePedal = output(1);
    gearChange = output(2);
end