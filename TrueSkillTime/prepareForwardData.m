function [ preMean, preVar ] = prepareForwardData( data, result, year, pMean, pVariance )
%PREPAREFORWARDDATA Summary of this function goes here
%   Detailed explanation goes here
    
    players = data.players; % global id of players
    numPlayers = length(players);
    preMean = zeros(numPlayers, 1);
    preVar = zeros(numPlayers, 1);
    
    if year == 1
        % begining of data, so use prior mean and variance for this task
        for localId = 1 : numPlayers % local id in each year 
            preMean(localId) = pMean;
            preVar(localId) = pVariance;
        end
    else
        % 
        for localId = 1 : numPlayers
            globalId = players(localId);
            if isempty(result{globalId})
                preMean(localId) = pMean;
                preVar(localId) = pVariance;
            else
                preMean(localId) = result{globalId}{year-1}.mean; % TODO if there are a gap???
                preVar(localId) = result{globalId}{year-1}.variance;
            end
        end
    end
end

