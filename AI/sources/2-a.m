% Example of Graph A
A = [0 1 1 0 0;
     1 0 0 0 0;
     1 0 0 1 1;
     0 0 1 0 0;
     0 0 1 0 0
];
initial_node = 1;
target_node  = 5;

% P1') AddNodes: update open_list
open_list = [ struct('id', initial_node, 'parent', 0) ];


% �N���[�Y�h���X�g����ɂ���
closed_list = [];

while ~isempty(open_list)
  
  cur_node = open_list(1)
  open_list(1) = [];
  closed_list = [closed_list cur_node];
  DEBUG_closed_list = [[closed_list.id]; [closed_list.parent]]  % for debug

  % P4) IsTargetNode
  if cur_node.id == target_node   % <-- update!!
      disp('I got Target node!')
      break
  end
  
  % P5) GetAdjacentNodes
  hyp_node_ids = find(A(cur_node.id, :) > 0);  % <-- update!!

  
  % closed_list�����ɂ��C�W�J�ς݂̃m�[�h���ĂуI�[�v�����X�g�Ɋi�[���Ȃ��悤�ɂ���
  if ~isempty(open_list)
      hyp_node_ids = hyp_node_ids(~ismember(hyp_node_ids, [open_list.id]))  % <-- update!!
  end

  % DeleteNodesInList: remove nodes in closed_list
  if ~isempty(closed_list)
      hyp_node_ids = hyp_node_ids(~ismember(hyp_node_ids, [closed_list.id]))  % <-- update!!
  end

  % Validate: hyp_node_ids  <-- new
  if isempty(hyp_node_ids)
    disp('No hypothesis: skip updating open_list')
    continue
  end
  
  % PrepareNodes  <-- new!!
  hyp_node_parents = repmat(cur_node.id, size(hyp_node_ids));
  hyp_nodes = struct('id', num2cell(hyp_node_ids), ...
                   'parent', num2cell(hyp_node_parents));
                   
  open_list = [open_list hyp_nodes];
  DEBUG_open_list = [[open_list.id]; [open_list.parent]]        % for debug

end

%% Back tracking
%   NOTE: The closed_list must contain the target_node.
cur_id = target_node;
route = [];
while cur_id > 0
    route = [cur_id route];                          % route�̐擪�ɁC�H���Ă���r���̃m�[�h(cur_node)��ǉ����Ă���
    array_index = find([closed_list.id] == cur_id);  % ���݂̃m�[�h��closed_list�Ɋi�[����Ă���ꏊ��T���āC
    cur_id = closed_list(array_index(1)).parent;     % ���̐e�m�[�h�̔ԍ��𓾂�
end
route     % route�Ɍo�H��̃m�[�h�����ԂɊi�[����Ă���
