x = 10;
y = x * 3;
x
y

z1 = [10 20 30]
A  = [1 2 3;
      4 5 6]

length(z1)      % ans = 3
size(A)         % ans = 2 3
length(A)       % ans = 3
size(z1)        % ans = 1 3

A = [1 2 3; 4 5 6]  % [1 2 3] �̉��� [4 5 6] �����ԍs��
C = 2               % 2   �X�J���[

Z = A * C
  %  2  4  6
  %  8 10 12  A�̑S�Ă̗v�f��C���|�����Ă���
  
node = struct('id', 1, 'parent', 3);

% C����Ɠ����悤�ɎQ�Ƃł���
node.id        % -> '1'���o�͂����
node.parent    % -> '3'���o�͂����

n = 100;
if n > 10
    disp('n > 10')
elseif n > 5
    disp('10 > n > 5')
else
    disp('5 > n')
end
% "n > 10"���\�������D

lim = 1000;
x = 2;
while x <= lim
    x = x * 2;
end
x   % 1024