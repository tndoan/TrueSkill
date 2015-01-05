function [ mean, prec ] = runInsideYear( data, pMean, pVariance, cMean, cVar )
%RUNINSIDEYEAR Summary of this function goes here
%   Detailed explanation goes here
    
    games = data.games;
    result = data.result;
    players = data.players;
    
    % initialize skill for this year
    numPlayers = length(players);
    mean = zeros(numPlayers, 1);
    prec = zeros(numPlayers, 1);
    
    %% loop to update the skill of this year 
    % init message
    
    
    %% loop inside year to find result
    % 
    

end

