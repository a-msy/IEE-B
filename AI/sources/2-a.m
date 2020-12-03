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


% クローズドリストを空にする
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

  
  % closed_list実装により，展開済みのノードを再びオープンリストに格納しないようにする
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
    route = [cur_id route];                          % routeの先頭に，辿っている途中のノード(cur_node)を追加していく
    array_index = find([closed_list.id] == cur_id);  % 現在のノードがclosed_listに格納されている場所を探して，
    cur_id = closed_list(array_index(1)).parent;     % その親ノードの番号を得る
end
route     % routeに経路上のノードが順番に格納されている
