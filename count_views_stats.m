function count_views_stats (n, data, filename)
  [fid, msg] = fopen(filename, 'w+');
  if fid == -1
      error(msg);
  end
  fprintf(fid, 'n, range, mean, standard deviation, variance, min, max'); 
  for i=1:length (n)
    stats = count_basic_statistics(data(:, n(i)), n(i));
    dlmwrite(filename,stats,'-append', 'roffset',1, 'precision','%.2f')
  end
  fclose(fid);
end
