function [prediction beta] = count_prediction (input, output, beta)
    samples = length(input(:,1));
    %design matrix
    dm = [ones(samples, 1) input];
    reg_matrix = eye(length(dm(1,:)));
    reg_matrix(1,1) = 0;
    if beta == false
        beta = inv(dm'*dm)*dm'*output;
    end
    prediction = dm*beta;
end