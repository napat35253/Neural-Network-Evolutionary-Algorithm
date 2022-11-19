function chromosome = EncodeNetwork(wIH, wHO, wMax)
    chromosome = [];
    for i = 1:size(wIH,1)
        chromosome = [chromosome,(wIH(i,:)+wMax)/(wMax*2)];
    end
    for j = 1:size(wHO,1)
        chromosome = [chromosome,(wHO(j,:)+wMax)/(wMax*2)];
    end
end