function prediction = count_prediction(input, output)
    samples = length(input(:,1));
    %design matrix
    dm = [ones(samples, 1) input];
    beta = inv(dm'*dm)*dm'*output;
    prediction = dm*beta;
end