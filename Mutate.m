function mutatedIndividual = Mutate(individual, mutationProbability)
    nGenes = size(individual,2);
    mutatedIndividual = individual;
    for j = 1:nGenes
        r = rand;
        if (r < mutationProbability)
            mutatedIndividual(j) = rand();
        end
    end
end