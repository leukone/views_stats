function x = count_basic_statistics (data, n)
  range = max(data)-min(data);
  std_v = std(data);
  var_v = var(data);
  mean_v = mean(data);
  max_v = max(data);
  min_v = min(data);
  x = [n, range, mean_v, std_v, var_v, min_v, max_v];
end