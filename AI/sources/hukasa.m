% Example of Graph A
A = [ 0 1 1 0 0 0 0 0 0 0;
      1 0 0 1 0 0 0 0 0 0;
      1 0 0 0 1 1 0 0 0 0;
      0 1 0 0 0 0 0 0 0 0;
      0 0 1 0 0 0 1 1 0 0;
      0 0 1 0 0 0 0 0 1 0;
      0 0 0 0 1 0 0 0 0 0;
      0 0 0 0 1 0 0 0 0 0;
      0 0 0 0 0 1 0 0 0 1;
      0 0 0 0 0 0 0 0 1 0;
];
initial_node = 1;
target_node  = 10;
% ������Ԃ��I�[�v�����X�g�ɓ����
open_list = [ initial_node ];
% �N���[�Y�h���X�g����ɂ���
closed_list = [];

while ~isempty(open_list)
  
  cur_node = open_list(1)
  open_list(1) = [];
  closed_list = [closed_list cur_node]
  
  if cur_node == target_node
    disp('I got a Target node!')
    break;
  end
  
  hyp_nodes = find(A(cur_node, :) > 0)
  
  % closed_list�����ɂ��C�W�J�ς݂̃m�[�h���ĂуI�[�v�����X�g�Ɋi�[���Ȃ��悤�ɂ���
  if ~isempty(closed_list)
    hyp_nodes = hyp_nodes(~ismember(hyp_nodes, closed_list));
  end
  
  open_list = [ hyp_nodes open_list ]
  
end