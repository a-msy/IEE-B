% (1) Initialize
stack_data = [];

% push
stack_data = [1 stack_data];
stack_data = [2 stack_data];
stack_data = [3 stack_data];
stack_data = [4 stack_data];
stack_data

% pop
ret = stack_data(end);
stack_data(end) = []; 
ret
stack_data