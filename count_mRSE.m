function prediction = count_prediction(input, output)
    samples = length(input(:,1))
    %design matrix
    dm = [ones(length(samples, 1)) input];
    beta = inv(dm'*dm)*dm'*output;
    input_ = [ones(samples, 1) input];
    prediction = ones(samples, 1);
    for i = 1:length(beta)
        prediction = prediction+ beta(i).*input_(:,1);
    end
end