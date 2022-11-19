function selectedIndividualIndex = TournamentSelect(fitnessList, tournamentProbability, tournamentSize)
    %randomly select individual for tournament
    individualList = zeros(tournamentSize,2);
    for i=1:tournamentSize
        r = 1 + fix(rand*size(fitnessList,2));
        individualList(i,1) = fitnessList(r); %value of random individual
        individualList(i,2) = r; %index of random individual
    end


    %tournament selection
    selectedIndividualIndex = 0; %index in matlab will never be 0
    while(selectedIndividualIndex == 0)

        r = rand;
        [~,individualIndex] = max(individualList(:,1));
        if(r < tournamentProbability)
            selectedIndividualIndex = individualList(individualIndex,2);
        else
            individualList(individualIndex,:) = [];
        end
        
        if(size(individualList,1) == 1)
            selectedIndividualIndex = individualList(1,2);
        end
    end
             
end