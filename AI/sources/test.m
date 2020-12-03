a = [1 4 2 1 9 4];
[aaa, idx] = unique(a, 'first')  % idx = 1 3 2 5
idx = sort(idx)                % idx = 1 2 3 5
a(idx)                         % ans = 1 4 2 9
aaa