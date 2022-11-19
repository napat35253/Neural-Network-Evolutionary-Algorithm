clear clc;
%% Parameter specifications

% GA PARAMS
tournamentSize = 3;
tournamentProbability = 0.75;
crossoverProbability = 0.5;
mutationProbability = 0.02;
numberOfGenerations = 10000;
populationSize = 150;

% Training Param
trainDataSet = 1;
valDataSet = 2;
testDataSet = 3;

nSlopesTrain = 10;
nSlopesVal = 5;
slopeLength = 1000;

% Neural Network
nIn = 3;
nOut = 2;
nHidden = 5; % [3 .. 10]
cSigmoid = 3; %range [1 3]
wMax = 5;
wIHSize = nHidden * (nIn+1);
wHOSize = nOut * (nHidden+1);
numberOfGenes = wIHSize + wHOSize;

maximumFitness  = 0;
maximumFitnessVal = 0;
iBestIndividual = 0;
bestChromosome = [];

generationArray = [];
maxFitnessArray = [];
meanFitnessArray = [];
maxValFitnessArray = [];
meanValFitnessArray = [];

% initialize population
population = InitializePopulation(populationSize, numberOfGenes);
fitnessList = zeros(1,populationSize);
fitnessListVal = zeros(1,populationSize);

for generation = 1:numberOfGenerations
    generationArray = [generationArray,generation];

    fitnessListTrain = zeros(1,nSlopesTrain);
    fitnessListVal = zeros(1,nSlopesVal);

    for i  = 1:populationSize
        chromosome = population(i,:);
        [wIH,wHO] = DecodeChromosome(chromosome,nIn,nHidden,nOut,wMax);

        for trainSlope = 1:nSlopesTrain
            fitnessTrain = EvaluateIndividual(wIH,wHO,trainSlope,slopeLength,trainDataSet);
            fitnessListTrain(trainSlope) = fitnessTrain;      
        end
        fitnessList(i) = mean(fitnessListTrain);

        for valSlope = 1:nSlopesVal
            fitnessVal = EvaluateIndividual(wIH,wHO,valSlope,slopeLength,valDataSet);
            fitnessListVal(valSlope) = fitnessVal;
        end
        fitnessListVal(i) = mean(fitnessListVal);

        if(max(fitnessListVal(i))>maximumFitnessVal)
            maximumFitnessVal = max(fitnessListVal(i));
        end

        if (fitnessList(i) > maximumFitness ) 
            maximumFitness  = fitnessList(i);
            iBestIndividual = i;
            bestChromosome = chromosome;
            sprintf('Generation : %i, Fitness score : %0.5f',generation,maximumFitness)
        end 

    end

    temporaryPopulation = population;  
    for i = 1:2:populationSize
        i1 = TournamentSelect(fitnessList,tournamentProbability,tournamentSize);
        i2 = TournamentSelect(fitnessList,tournamentProbability,tournamentSize);
        r = rand;
        if (r < crossoverProbability) 
            individual1 = population(i1,:);
            individual2 = population(i2,:);
            newIndividualPair = Cross(individual1, individual2);
            temporaryPopulation(i,:) = newIndividualPair(1,:);
            temporaryPopulation(i+1,:) = newIndividualPair(2,:);
        else
            temporaryPopulation(i,:) = population(i1,:);
            temporaryPopulation(i+1,:) = population(i2,:);     
        end
    end
  
    if iBestIndividual > 0
        temporaryPopulation(1,:) = population(iBestIndividual,:);
    end
    for i = 2:populationSize
        tempIndividual = Mutate(temporaryPopulation(i,:),mutationProbability);
        temporaryPopulation(i,:) = tempIndividual;
    end
    population = temporaryPopulation;

    maxFitnessArray = [maxFitnessArray,max(fitnessList)];
    maxValFitnessArray = [maxValFitnessArray,max(fitnessListVal)];
    meanFitnessArray = [meanFitnessArray,mean(fitnessList)];
    meanValFitnessArray = [meanValFitnessArray,mean(fitnessListVal)];

    if mod(generation,10) == 0
        plot(generationArray, maxValFitnessArray, 'ro',generationArray, maxFitnessArray,'bo', ...
            generationArray, meanValFitnessArray, 'r--',generationArray, meanFitnessArray, 'b-');
        legend("max (validation)","max (training)","mean (validation)","mean (training)")
        xlabel('Generation')
        ylabel('Fitness Score')
        drawnow;
    end
    sprintf('Generation: %i Max Fitness score:%i',generation,maximumFitness)

end

matlab.io.saveVariablesToScript('BestChromosome.m', 'bestChromosome')
