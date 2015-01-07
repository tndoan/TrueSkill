function [ names, years, data ] = readInput(fname)
% [ names, years, data ] = readInput(fname)
% read and parse input file
%   names: cell array contains name of player
%   years: vector contains year
%   data: cell array whose length is equal to length of years
%         For example: data{1} is data of year (for example) 1820 
%         and years(1) = 1820
%         data{i}.games(j, :) is a j-th game which occurs between 2 players
%         whose ids are
%         a and b. Name of a is value of names{d.players(a)}, similar to b. If a wins
%         over b, data{i}.result(j) = 1; if a loses, data{i}.games(j, :) =
%         [b a]
%         and if draw data{i}.result(j) = 0. d.players is list of player id
%         in this year.

    fid = fopen(fname);
    if (fid == -1)
        error(sprintf('readInput: can''t open %s.',file));
    end

    % declare output
    max_id = 1;
    names = {};
    data = {};
    init_year = -1;
    result = [];
    games = [];
    years = [];
    
    % read file
    while ~feof(fid)
        l = fgetl(fid);
        f = textscan(l, '%d,%d,%[^,],%[^,],%d,%d');
        year = f{2};       % year of the game
        p1 = char(f{3});   % name of player 1
        p2 = char(f{4});   % name of player 2
        s1 = f{5};         % score of player 1
        s2 = f{6};         % score of player 2   
        if ~ismember(p1, names)
            names{max_id} = p1;
            max_id = max_id + 1;
        end
        
        if ~ismember(p2, names)
            names{max_id} = p2;
            max_id = max_id + 1;
        end
        
        id1 = find(ismember(names, p1)); % id of player 1
        id2 = find(ismember(names, p2)); % id of player 2
        
        if year ~= init_year
            if init_year == -1 % it is the first time
                init_year = year;
            else
                d.result = result;
                d.players = unique(games);
                d.games = loopFR(games, d.players);
                data{length(years) + 1} = d;
                result = [];
                games = [];
                init_year = year;
                years = [years; year];
            end
        end
      
        if s1 > s2       % player 1 wins over player 2
            result = [result; 1];
            games = [games; id1 id2];
        elseif s2 > s1   % player 2 wins over player 1
            result = [result; 1];
            games = [games; id2 id1];
        else             % draw
            result = [result; 0];
            games = [games; id1 id2];
        end
    end
    
    % close file
    fclose(fid);

end

