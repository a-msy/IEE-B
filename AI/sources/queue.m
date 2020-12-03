% (1) Initialize
q_data = [];

% push
q_data = [1 q_data];
q_data = [2 q_data];
q_data = [3 q_data];
q_data = [4 q_data];
q_data

% pop
ret = q_data(1);
q_data(1) = []; 
ret
q_data