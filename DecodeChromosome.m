% nIn = the number of inputs
% nHidden = the number of hidden neurons
% nOut = the number of output neurons
% Weights (and biases) should take values in the range [-wMax,wMax]

function [wIH, wHO] = DecodeChromosome(chromosome, nIn, nHidden, nOut, wMax)
    wIH = zeros(nHidden,nIn+1);
    wHO = zeros(nOut,nHidden+1);
    n = 1;

    for i = 1:size(wIH,1)
        for j = 1:size(wIH,2)
            wIH(i,j) = -wMax + 2 * chromosome(n)* wMax; %[-wMax,wMax]
            n = n+1;
        end
    end

    for i = 1:size(wHO,1)
        for j = 1:size(wHO,2)
            wHO(i,j) = -wMax + 2 * chromosome(n)* wMax;
            n = n+1;
        end
    end   
end
