function M1 = loopFR(M,A)
% loopFR replaces M with its indices from A.
% This function is copied from 
% http://blogs.mathworks.com/loren/2006/06/14/inverse-mapping-from-values-to-indices/

    % First set up the inverse mapping array.  Initialize it to zero, and the
    % size is the maximum number the array.  Note that I get away with this
    % here because all of my numbers in both A and M are positive integers.
    imap = zeros(1,max(A));  % inverse mapping array
    % Now fill the inverse map, but placing in the location specified in each
    % element of A, the index of that element in A.
    % If A = [1 5 4], then imap = [1 0 0 3 2].
    imap(A) = 1:length(A);  
    M1 = M;
    for k = 1:numel(M)
        M1(k) = imap(M(k));
    end
end