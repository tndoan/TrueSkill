function [ result ] = runTrueSkill( data, numPlayers, pMean, pVariance, maxIter )
%RUNTRUESKILL Summary of this function goes here
%   Detailed explanation goes here

    numYears = length(data); % number of years
    result = cell(numPlayers, 1);
    
    for i=1:maxIter
        % run forward
        for j = 1:numYears
            preMean, preVar = prepareForwardData(data, result, j, pMean, pVariance);
            curMean, curVar = getCurrentData(data, result, j);
            yMean, yPrec = runInsideYear(data{j}, preMean, preVar, curMean, curVar);
            
            % update user info
            players = data{j}.players;
            for p = 1 : length(players)
                globalId = players(p);
                result{globalId}{j}.mean = yMean(p);
                result{globalId}{j}.variance = 1/yPrec(p);
            end
        end
        
        % run backward
        for j = (numYears-1):-1:1
            postMean, postVar = prepareBackwardData(data, result, j);
            curMean, curVar = getCurrentData(data, result, j);
            yMean, yPrec = runInsideYear(data{j}, postMean, postVar, curMean, curVar);
            
            % update user info
            players = data{j}.players;
            for p = 1 : length(players)
                globalId = players(p);
                result{globalId}{j}.mean = yMean(p);
                result{globalId}{j}.variance = 1/yPrec(p);
            end
        end
    end
end

