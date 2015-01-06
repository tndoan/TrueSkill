function [ result ] = runTrueSkill( data, numPlayers, pMean, pPrec, maxIter )
%RUNTRUESKILL Summary of this function goes here
%   Detailed explanation goes here

    numYears = length(data); % number of years
    result = cell(numPlayers, 1);
    
    for i=1:maxIter
        % run forward
        for j = 1:numYears
            preMean, prePrec, curMean, curPrec, postMean, postPrec = prepareData(data, result, j, pMean, pPrec);
            yMean, yPrec = runInsideYear(data{j}, preMean, prePrec, curMean, curPrec, postMean, postPrec);
            
            % update user info
            players = data{j}.players;
            for p = 1 : length(players)
                globalId = players(p);
                result{globalId}{j}.mean = yMean(p);
                result{globalId}{j}.prec = yPrec(p);
            end
        end
        
        % run backward
        for j = (numYears-1):-1:1
            preMean, prePrec, curMean, curPrec, postMean, postPrec = prepareData(data, result, j, pMean, pPrec);
            yMean, yPrec = runInsideYear(data{j}, preMean, prePrec, curMean, curPrec, postMean, postPrec);
            
            % update user info
            players = data{j}.players;
            for p = 1 : length(players)
                globalId = players(p);
                result{globalId}{j}.mean = yMean(p);
                result{globalId}{j}.prec = yPrec(p);
            end
        end
    end
end

