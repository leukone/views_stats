function [prediction beta] = count_prediction (input, output, beta)
    samples = length(input(:,1));
    %design matrix
    dm = [ones(samples, 1) input];
    if beta == false
        beta = inv(dm'*dm)*dm'*output;
    end
    prediction = dm*beta;
end