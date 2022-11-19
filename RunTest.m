%load chromosome
chromosome = BestChromosome;
testDataset = 3;
slopeIdx = 4;
slopeLength = 1000;

%Fixed Param
vMax = 25;
vMin = 1;
tempMax = 750;
alphaMax = 10;
deltaT = 0.1;

% Initial State
tempBrake = 500; %K
v = 20; %m/s
pressurePedal = 0;
gear = 7;

% Neural Network
nIn = 3;
nOut = 2;
nHidden = 5; % [3 .. 10]
cSigmoid = 3; %range [1 3]
wMax = 5;
wIHSize = nHidden * (nIn+1);
wHOSize = nOut * (nHidden+1);
numberOfGenes = wIHSize + wHOSize;

x = 0;
gearChangeCount = 0;
counter = 0;
velocitySum = v;
fitnessSum = 0;

maxTimesteps = 1000 / vMin;
alphaArray = zeros(maxTimesteps, 1);
pressurePedalArray = zeros(maxTimesteps, 1);
gearArray = zeros(maxTimesteps, 1);
velArray = zeros(maxTimesteps, 1);
tempBrakeArray = zeros(maxTimesteps, 1);
xArray = zeros(maxTimesteps, 1);
timestep = 1;

% decode chromosome
[wTestIH,wTestHO] = DecodeChromosome(chromosome,nIn,nHidden,nOut,wMax);


while x < slopeLength

    alpha = GetSlopeAngle(x,slopeIdx,testDataset);
    [v,tempBrake] = RunTruckModel(v,tempBrake,pressurePedal,gear,alpha,deltaT);
           
    % Constraints
    if(v > vMax || v < vMin || tempBrake > tempMax || alpha > alphaMax)
        fitnessSum = fitnessSum + velocitySum/counter*x;
        break
    end
            
    % Feed to Neural Network
    [pressurePedal,gearChange] = RunFFNN(wTestIH,wTestHO,v,vMax,alpha,alphaMax,tempBrake,tempMax,cSigmoid);
            
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
    
    alphaArray(timestep) = alpha;
    pressurePedalArray(timestep) = pressurePedal;
    gearArray(timestep) = gear;
    velArray(timestep) = v;
    tempBrakeArray(timestep) = tempBrake;
    xArray(timestep) = x;
    
    timestep = timestep + 1;
end

fitnessSum = fitnessSum + velocitySum/counter*x;
figure(3);
subplot(2,3,1)
plot(xArray(1:(timestep-1)), alphaArray(1:(timestep-1)));
title('alpha')
xlabel('x')
ylabel('alpha')

subplot(2,3,2)
plot(xArray(1:(timestep-1)), pressurePedalArray(1:(timestep-1)));
title('pedal pressure')
xlabel('x')
ylabel('pedal pressure')

subplot(2,3,3)
plot(xArray(1:(timestep-1)), gearArray(1:(timestep-1)));
title('gear')
xlabel('x')
ylabel('gear')

subplot(2,3,4)
plot(xArray(1:(timestep-1)), velArray(1:(timestep-1)));
title('speed')
xlabel('x')
ylabel('speed')

subplot(2,3,5)
plot(xArray(1:(timestep-1)), tempBrakeArray(1:(timestep-1)));
title('brake temperature')
xlabel('x')
ylabel('brake temperature')
sprintf("Test set : %i, Fitness score : %0.4f",testDataset,fitnessSum)
