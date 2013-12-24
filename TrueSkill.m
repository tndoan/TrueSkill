function [a1, b] = TrueSkill()
% This is the pure trueskill implementation
% which is similar to TrueSkill Calculator provided by Microsoft
% http://atom.research.microsoft.com/trueskill/rankcalculator.aspx
% but it does not support team formation
M = 10;
beta =  4.15;
mean = ones(1, M)' * 25; % it is the default value in TrueSkill paper
prec = ones(1, M)' * 0.014515895; % it is the default value in TrueSkill paper
[a1, b] = myTrueSkillCal(M, beta, mean, prec);

end

function [Ms, Ps] = myTrueSkillCal(M, par_beta, prior_mean, prior_pre)
% Input:
% M = number of player
% par_beta = variance of performance
% prior_mean = the mean of prior distribution of players
% prior_pre = the precision of prior distribution of players

	psi = inline('normpdf(x)./normcdf(x)');
	lambda = inline('(normpdf(x)./normcdf(x)).*( (normpdf(x)./normcdf(x)) + x)');

	% initialize the matrices of skill marginals - mean and variances(or precision???)
	Ms = nan(M, 1);
	Ps = nan(M, 1); 

	% initialize the message in step 9 - means and precisions
	mean_m_9 = zeros(M, 1);
	prec_m_9 = zeros(M, 1);

	% initialize the message in step 8 - means and precisions
	mean_m_8 = zeros(M - 1, 2);
	prec_m_8 = zeros(M - 1, 2);

	prec_m_3 = zeros(M, 1);
	mean_m_3 = zeros(M, 1);

	for iter=1:5
		%(1) compute the posterior over skill variables
		Ps = prior_pre + prec_m_9;
		Ms = (prior_mean .* prior_pre + mean_m_9 .* prec_m_9)./Ps;
        
		%(2) compute the message from factor to performance
		a = 1./(1 + par_beta^2 .* (Ps - prec_m_9));
		prec_m_2 = a .* (Ps - prec_m_9);
		mean_m_2 = a .* ((Ps .* Ms - mean_m_9 .* prec_m_9)./prec_m_2);

		%(3) compute the posterior of performance
		t_prec_m_8 = [0 0; prec_m_8; 0 0];
		t_mean_m_8 = [0 0; mean_m_8; 0 0];
		for i = 1:M
			prec_m_3(i) = prec_m_2(i) + t_prec_m_8(i + 1, 1) + t_prec_m_8(i, 2) ;
			mean_m_3(i) = (prec_m_2(i) * mean_m_2(i) + t_prec_m_8(i+1, 1) * t_mean_m_8(i+1, 1) + t_prec_m_8(i, 2) * t_mean_m_8(i, 2))./prec_m_3(i);        
		end

		%(4) compute the message from performance to diff factor
		position_matrix = create_position_matrix(M);
		temp = prec_m_3(position_matrix);
		prec_m_4 = prec_m_3(position_matrix) - prec_m_8;
		mean_m_4 = ((mean_m_3(position_matrix).*prec_m_3(position_matrix)) - mean_m_8.*prec_m_8)./prec_m_4;
			
		%(5) compute the message from diff factor to diff variable
		prec_m_5 = 1./(1./prec_m_4(:,2) + 1./(prec_m_4(:,1)));
		mean_m_5 = mean_m_4(:,1) - mean_m_4(:, 2);
			
		%(6) compute the posterior of diff variable
		mean_post_6 = mean_m_5 + sqrt(1./prec_m_5) .* psi(mean_m_5 ./ sqrt(1./prec_m_5));
		prec_post_6 = (1./(1 - lambda(mean_m_5 ./ sqrt(1./prec_m_5)))).* prec_m_5;

		%(7) compute the message from diff variable back to diff factor
		prec_m_7 = prec_post_6 - prec_m_5;
		mean_m_7 = (prec_post_6 .* mean_post_6 - prec_m_5 .* mean_m_5)./prec_m_7;

		%(8) compute the message from diff factor back to performance
		%prec_m_8 = [prec_m_7 prec_m_7] + [prec_m_4(:, 2) prec_m_4(:, 1)];
		prec_m_8_l = 1./(1./prec_m_7 + 1./prec_m_4(:,2));
		prec_m_8_r = 1./(1./prec_m_7 + 1./prec_m_4(:,1));
		prec_m_8 = [prec_m_8_l prec_m_8_r];
		mean_m_8 = [mean_m_7 -1*mean_m_7] + [mean_m_4(:, 2) mean_m_4(:, 1)];
			
		%()  update the posterior of performance
		t_prec_m_8 = [0 0; prec_m_8; 0 0];
		t_mean_m_8 = [0 0; mean_m_8; 0 0];
		for i = 1:M
			prec_m_3(i) = prec_m_2(i) + t_prec_m_8(i + 1, 1) + t_prec_m_8(i, 2) ;
			mean_m_3(i) = (prec_m_2(i) * mean_m_2(i) + t_prec_m_8(i+1, 1) * t_mean_m_8(i+1, 1) + t_prec_m_8(i, 2) * t_mean_m_8(i, 2))./prec_m_3(i);        
		end

		%(9) compute the message from performance factor to skill variable
		a1 = 1./(1 + par_beta^2 .* (prec_m_3 - prec_m_2));
		prec_m_9 = a1 .* (prec_m_3 - prec_m_2);
		mean_m_9 = a1 .* ((prec_m_3 .* mean_m_3 - prec_m_2 .* mean_m_2)./prec_m_9);

    end
end

function matrix = create_position_matrix(M)
% Input:
% M : number of player playing the game
% Output is the matrix of order of player after game
% For example: output matrix is [1 2; 2 3; 3 4] means player 1 is ranked
% higher than player 2, player 2 is ranked higher than player 3 and player
% 3 is ranked higher than player 4
    for i = 1:(M-1)
        matrix(i, :) = [i (i+1)];
    end
end

