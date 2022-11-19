function averageFitness = EvaluateIndividual(wIH,wHO,nSlopes,slopeLength,dataset)
    
    % Fixed Param 
    vMax = 25;
    vMin = 1;
    tempMax = 750;
    alphaMax = 10;
    cSigmoid = 2;
    deltaT = 0.1;
    fitnessSum = 0;
    
    for eachSlope = 1:nSlopes
        % Initial State
        tempBrake = 500; %K
        v = 20; %m/s
        pressurePedal = 0;
        gear = 7;

        x = 0;
        gearChangeCount = 0;
        counter = 0;
        velocitySum = v;

        while x < slopeLength

           alpha = GetSlopeAngle(x,eachSlope,dataset);
           [v,tempBrake] = RunTruckModel(v,tempBrake,pressurePedal,gear,alpha,deltaT);
           
           % Constraints
           if(v > vMax || v < vMin || tempBrake > tempMax || alpha > alphaMax)
               fitnessSum = fitnessSum + velocitySum/counter*x;
               averageFitness = fitnessSum / nSlopes;
               return
           end
            
           % Feed to Neural Network
           [pressurePedal,gearChange] = RunFFNN(wIH,wHO,v,vMax,alpha,alphaMax,tempBrake,tempMax,cSigmoid);
            
           % Gear criteria
           if gearChange > 0.66 && gearChangeCount >= 2 && gear ~= 10
               gear = gear + 1;
               gearChangeCount = 0;
           elseif gearChange < 0.33 && gearChangeCount >= 2 && gear ~= 1
               gear = gear - 1;
               gearChangeCount = 0;
           end

           gearChangeCount = gearChangeCount + deltaT;
           counter = counter + 1;
           velocitySum = velocitySum + v;
           x = x + v*deltaT;

        end

        fitnessSum = fitnessSum + velocitySum/counter*x;

    end

    averageFitness = fitnessSum / nSlopes;

end

