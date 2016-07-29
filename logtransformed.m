function [x_,y_, edge_min, edge_max] = logtransformed (x, g_min, g_max)
    xx = g_min:10000:g_max;
    y = hist(x, xx);
    logx = log(xx);
    expected_v = sum(logx.*y)/sum(y);
    variance = sum(y.*(logx - expected_v).^2)/sum(y);
    edge_min  = expected_v-3*sqrt(variance);
    edge_max = expected_v+3*sqrt(variance);
    mask = logx >(expected_v-3*sqrt(variance)) & ...
    logx <(expected_v+3*sqrt(variance));
    y_ = y; x_ = logx;
end
    