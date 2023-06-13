function y = mindiff(x)

y   = min(diff(sort(unique(x))));