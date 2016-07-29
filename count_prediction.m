function [prediction beta] = count_prediction (input, output, beta)
    samples = length(input(:,1));
    %design matrix
    dm = [ones(samples, 1) input];
    if beta == false
        beta = inv(dm'*dm)*dm'*output;
    end
    input_ = [ones(samples, 1) input];
    prediction = ones(samples, 1);
    for i = 1:length(beta)
        prediction = prediction + beta(i)*input_(:,i);
    end
end