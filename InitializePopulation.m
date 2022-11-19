function population = InitializePopulation(populationSize,numberOfGenes)
    population = zeros(populationSize,numberOfGenes);
    for i = 1:populationSize
        for j = 1:numberOfGenes
            population(i,j) = rand() ;
        end
    end

end