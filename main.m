%Open data, find global minimum and global maximum in order
%to create stadard bins for views distribution

%First column from original csv file has been removed in Calc
data = csvread('Desktop\Tooploox\data.csv');
glob_min = min(data(:));

%================== 1: BASIC VIEWS STATISTICS========================
% find global minimum and maximum, exclude 0 from x axis in order to log-transform data
if glob_min == 0
    glob_min = 1;
end    
glob_max = max(data(:));
count_views_stats([24, 72, 168], data, 'C:\Users\Ja\Desktop\Tooploox\results.txt'); 

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
[xx, nn] = hist(x, 500);
handaxes2 = axes('Position', [0.43 0.55 0.45 0.35]);
scatter(nn, xx, 4,'red', 'filled')
xlabel('log(views)')
ylabel('Number of films')
set(handaxes2, 'Xscale', 'log');
print('C:\Users\Ja\Desktop\Tooploox\lognorm_distr','-dpng')


% Log-transform distribution v(168), remove outliers from dataset and count correlation coefficients
%================= 4: REMOVING OUTLIERS FROM DATASET  ===============
x_f = data(:,168);
[x__, y__, edge_min, edge_max]=logtransformed(x_f, glob_min, glob_max); 
data = data(data(:,168) > exp(edge_min) & data(:, 168) < exp(edge_max), :);

%================= 5: CORRELATION COEFFICIENTS  ===============
coefficients = zeros(24, 2, 2);
size(coefficients);
for i = 1:24
    x = data(:,i);
    [x_, y_, null1, null2]=logtransformed(x, glob_min, glob_max);
    coefficients(i, :, :) = corrcoef(y_, y__);
end


%save coefficients to results file
 [fid, msg] = fopen('C:\Users\Ja\Desktop\Tooploox\results.txt', 'a');
  if fid == -1
      error(msg);
  end
  fprintf(fid, '\n Correlation Coefficient \n'); 
  for i=1:length (coefficients(:, 1, 1))
    fprintf(fid, '\n n = %d and n = 168 \n', i); 
    fprintf(fid,'%f, %f \n ', coefficients(i, 1, 1), coefficients(i, 1, 2))
    fprintf(fid,'%f, %f \n ', coefficients(i, 2, 1), coefficients(i, 2, 2))
  end
  fclose(fid);


% MINIMIZE ORDINARY LEAST SQUARES
% =================== 6: SPLIT DATASET AT RANDOM ==================================
% k - number of training samples, p - id number of the output column in given dataset
k = 24;
p = 168;
% choose randomly  10% of samples for a testing set ( by drawing indices of rows from dataset )
indices = randsample(1:length(data(:,1)), ceil(0.1*length(data(:,1))));
test_set = data(indices, :);
[train_set, PS] = removerows(data, indices);
mRSE = zeros(2, k);

% minimizing cost functions with normal equation
for j = 1:k
    % training
    output = train_set(:, p);
    [prediction_single, beta_t] =...
        count_prediction(train_set(:,j), train_set(:, p), false);
    [prediction_multi, beta_m] = ...
        count_prediction(train_set(:,1:j), train_set(:, p), false);
   
    %testing
    output = test_set(:, p);
    [prediction_single, beta_t] = ...
        count_prediction(test_set(:,j), test_set(:, p), beta_t);
    [prediction_multi, beta_m] = ...
        count_prediction(test_set(:,1:j), test_set(:, p), beta_m);
    
    
    % COMPUTING MEAN RELATIVE SQUARED ERROR
     var1 = rdivide(prediction_single-test_set(:, p), test_set(:, p)).^2;
     mRSE(1,j) = 1/numel(test_set)*sum(var1);
     var2 = (rdivide((prediction_multi-test_set(:, p)),test_set(:, p))).^2;
     mRSE(2,j) = 1/numel(test_set)*sum(var2);
end


% PLOT mRSE
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
print('C:\Users\Ja\Desktop\Tooploox\mRSE','-dpng')




