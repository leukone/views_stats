%Open data, find global minimum and global maximum in order
%to create stadard bins for views distribution

%First column from original csv file has been removed in Calc
data_imported = importdata('data.csv');
eps = 0.00000000001
data = data_imported.data;
glob_min = min(data(:));

%================== 1: BASIC VIEWS STATISTICS========================   
glob_max = max(data(:));
count_views_stats([24, 72, 168], data)

%================= 2: PLOTTING DISTRIBUTION OF v(168) ===================
x = data(:, 168);
% Main plot 
figure;
handaxes1 = axes('Position', [0.14 0.14 0.8 0.8]);
hist(x, 300);
ylabel('Number of films')
xlabel('Views')
handxlabel1 = get(gca, 'XLabel');
set(handxlabel1, 'FontSize', 11)
handylabel1 = get(gca, 'ylabel');
set(handylabel1, 'FontSize', 11)
title('Distribution of views(168)')
grid on;

%================= 3: PLOTTING DISTRIBUTION OF log-transformed v(168) ===============
% Place second set of axes on same plot, with log scale on x-axis to show gaussian curve
handaxes2 = axes('Position', [0.43 0.55 0.45 0.35]);
histogram(log(x), 100, 'Facecolor', 'r', 'Edgecolor', 'r')
xlabel('log(views)')
ylabel('Number of films')
set(handaxes2, 'Xscale', 'log');
print('lognorm_distr','-dpng')


% Distribution of log-transformed v(168), remove outliers from nominal data and count correlation coefficients
%================= 4: REMOVING OUTLIERS FROM DATASET  ===============
data_temp = data;
data_temp(data_temp == 0) = eps;
x_f = log(data_temp(:,168));
mean_ = mean(x_f);
var_ = var(x_f);
data_log = log(data_temp); 
mask = data_log(:,168) > (mean_ - 3*var_) ...
    & data_log(:, 168) < (mean_ + 3*var_);
data_log = data_log(mask, :);
data = data(mask, :);

%================= 5: CORRELATION COEFFICIENTS  ===============
n = (1:1:24)';
disp(['Linear correlation coefficient between logtransformed  ' ...
'  v(n) and v(168)'])
coefficients = corr(data_log(:, 1:24), data_log(:, 168));
disp(table(n, coefficients))

 
% =================== 6: SPLIT DATASET AT RANDOM ==================================
% k - number of training samples, p - id number of the output column in given dataset
k = 24;
p = 168;
% choose randomly  10% of samples for a testing set ( by drawing indices of rows from dataset )
indices = randsample(1:length(data(:,1)), ceil(0.1*length(data(:,1))));
test_set = data(indices, :);
[train_set, PS] = removerows(data, indices);
mRSE = zeros(2, k);

% ===================== 7: MINIMIZE ORDINARY LEAST SQUARES ========================
% minimizing cost functions with normal equation
for j = 1:k
    % training
    output_training = train_set(:, p);
    output = test_set(:, p);
    % ------> single column input
    [prediction_single_training, beta_t] =...
        count_prediction(train_set(:,j), output_training, false);
    %testing
    [prediction_single, null] = ...
        count_prediction(test_set(:,j), output, beta_t);
    %------> 8: multiple input 
    [prediction_multi_training, beta_m] = ...
    count_prediction(train_set(:,1:j), output_training, false);
    %testing
    [prediction_multi, null] = ...
    count_prediction(test_set(:,1:j), output, beta_m);
    
    % ====================== 9: COMPUTING MEAN RELATIVE SQUARED ERROR==============
     var1 = (rdivide(prediction_single-test_set(:, p), test_set(:, p))).^2;
     mRSE(1,j) = 1/numel(test_set(:,1))*sum(var1);
     var2 = (rdivide((prediction_multi-test_set(:, p)),test_set(:, p))).^2;
     mRSE(2,j) = 1/numel(test_set(:,1))*sum(var2);
end


% ======================== 10: PLOT mRSE ==================================
figure(3)
scatter(1:1:k, mRSE(1,:), 50, 'blue', 'filled'); hold on;
scatter(1:1:k, mRSE(2,:), 10, 'green', 'filled'); 
plot(1:1:k,mRSE(1,:), '--', 'color', 'blue')
plot(1:1:k,mRSE(2,:), '--', 'color', 'green')
title('mean Relative Square Error')
legend('Linear Regression', 'Multiple-input Linear Regression')
xlabel('Reference time')
ylabel('mRSE')
grid on;
print('mRSE','-dpng')