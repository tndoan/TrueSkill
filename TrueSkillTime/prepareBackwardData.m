function [ postMean, postVar ] = prepareBackwardData( data, result, year )
%PREPAREBACKWARDDATA Summary of this function goes here
%   Detailed explanation goes here

    players = data.players;
    numPlayers = length(players);
    postMean = zeros(numPlayers, 1);
    postVar = zeros(numPlayers, 1);
    
    for i = 1:numPlayers
        p = players(i); % global id of player

        if isempty(result{p}{year + 1})
            postMean(i) = NaN;
            postVar(i) = NaN;
        else
            postMean(i) = result{p}{year + 1}.mean;
            postVar(i) = result{p}{year + 1}.variance;
        end
    end
end

