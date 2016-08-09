function count_views_stats (n, data)
  range = max(data(:, n))-min(data(:, n));
  std_v = std(data(:, n));
  var_v = var(data(:, n));
  mean_v = mean(data(:, n));
  max_v = max(data(:, n));
  min_v = min(data(:, n));
  stats = [n; range; mean_v; std_v; var_v; min_v; max_v];
  names = {'n'; 'range'; 'mean'; 'standard deviation'; 'variance'; 'min'; 'max'};
  size(names)
  size(stats')
  table(names, stats)
end
