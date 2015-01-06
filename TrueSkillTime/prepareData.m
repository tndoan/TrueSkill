function [ preMean, prePrec, curMean, curPrec, postMean, postPrec ] = prepareData( data, result, year, pMean, pPrec )
%PREPAREDATA [ preMean, prePrec, curMean, curPrec, postMean, postPrec ] = prepareData( data, result, year, pMean, pPrec )
%   Getting mean and precision of previous/current/post year of players
%   Input: data: all input from text file, see readInput for reference
%          result: store all mean and precision of players over years (use
%                  global id to retrieve)
%          year: indicate the year we want to get. It is the local value.
%                To get the real year by using ``years(year)``
%          pMean, pPrec: prior mean and prior precision
%   Output:
%          preMean, prePrec: mean and precision of previous year of users

    players = data{year}.players;
    numPlayers = length(players);
    % TODO if there are a gap, for example, player A plays in year 1 and 
    % year 3 but not in year 2

    %% Get previous year
    preMean = ones(numPlayers, 1) * pMean;
    prePrec = ones(numPlayers, 1) * pPrec;
    
    if ~year == 1
        % if year == 1, use prior mean and prec for skill of player at previous year 
        for localId = 1 : numPlayers
            globalId = players(localId);
            if ~isempty(result{g})
                if ~isempty(result{globalId})
                    % empty means before that player does not have any game so
                    % use the prior mean and precision for the skill
                    preMean(localId) = result{globalId}{year-1}.mean; 
                    prePrec(localId) = result{globalId}{year-1}.prec;
                end
            end
        end
    end

    %% Get following year
    postMean = zeros(numPlayers, 1);
    postPrec = zeros(numPlayers, 1);
    
    for i = 1:numPlayers
        p = players(i); % global id of player

        if ~isempty(result{p})
            if ~isempty(result{p}{year + 1})
                % if empty means no following year, so 0 mean and precision
                % does not affect the skill
                postMean(i) = result{p}{year + 1}.mean;
                postPrec(i) = result{p}{year + 1}.prec;
            end
        end
    end

    %% Get current skill of players
    curMean = zeros(numPlayers, 1);
    curPrec = zeros(numPlayers, 1);
    
    for i = 1:numPlayers
        p = players(i); % global id of player i
        
        if ~isempty(result{p})
            if ~isempty(result{p}{year})
                % if empty, means and precision of this year is 0 (default
                % value)
                curMean(i) = result{p}{year}.mean;
                curPrec(i) = result{p}{year}.prec;
            end
        end
    end
end