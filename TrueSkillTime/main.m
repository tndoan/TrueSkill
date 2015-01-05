function [ names, years, result ] = main( fname, pMean, pVariance, maxIter )
% [ names, years, result ] = main( fname, pMean, pVariance)
%   fname: file name which contains data
%   pMean, pVariance: prior mean and variance
%   maxIter: maximum number of iteration
%   names: cell array names of players
%   years: cell array years of games
%   result: cell array of skills of player through years

    % read the input
    [names, years, data] = readInput(fname);
    numPlayers = length(names);
    result = runTrueSkill(data, numPlayers, pMean, pVariance, maxIter);
end

