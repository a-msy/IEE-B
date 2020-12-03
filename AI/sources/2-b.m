% Example of Graph A
% 各要素の数値をコストとして，読み替えることにします． そして，コストが小さいノードは経由しやすく，
% コストが大きいノードは経由しにくくなる，という意味を持たせます． 
% ただし，コスト0のみ特別な意味を持たせます． 「コスト0で接続されている」ではなく，「コスト0は，接続されていない」という意味
%A = [0 1 1 0 0;
%     1 0 0 0 0;
%     1 0 0 1 1;
%     0 0 1 0 0;
%     0 0 1 0 0
%];
A = [0 1 0 0 0 0 0;
     1 0 0 7 4 0 0;
     0 0 0 6 0 0 0;
     0 2 1 0 2 2 0;
     0 4 0 7 0 4 0;
     0 0 0 7 4 0 1;
     0 0 0 0 0 1 0;
];
initial_node = 1;
target_node  = 7;

% P1') AddNodes: update open_list
open_list = [ struct('id', initial_node, 'parent', 0, 'cost', 0) ];


% クローズドリストを空にする
closed_list = [];

while ~isempty(open_list)
  
  cur_node = open_list(1)
  open_list(1) = [];
  closed_list = [closed_list cur_node];
  DEBUG_closed_list = [[closed_list.id]; [closed_list.parent]; [closed_list.cost]]  % for debug

  % P4) IsTargetNode
  if cur_node.id == target_node   % <-- update!!
      disp('I got Target node!')
      break
  end
  
  % P5) GetAdjacentNodes
  hyp_node_ids = find(A(cur_node.id, :) > 0);  % <-- update!!

  
    % closed_list実装により，展開済みのノードを再びオープンリストに格納しないようにする
    if ~isempty(closed_list)
      hyp_node_ids = hyp_node_ids(~ismember(hyp_node_ids, [closed_list.id]));
    end

    % DeleteNodesInList: remove nodes in open_list
    %    **ToDo:** This process will be omitted after 'AI-2' 
    %if ~isempty(open_list)
    %    hyp_nodes = hyp_nodes(~ismember(hyp_nodes, [open_list.id]))
    %end

  % Validate: hyp_node_ids  <-- new
  if isempty(hyp_node_ids)
    disp('No hypothesis: skip updating open_list')
    continue
  end
  
% PrepareNodes
    hyp_node_costs = A(cur_node.id, hyp_node_ids) + cur_node.cost;   % <-- new! [2a]
    hyp_node_parents = repmat(cur_node.id, size(hyp_node_ids));
    hyp_nodes = struct('id', num2cell(hyp_node_ids), ...
                       'parent', num2cell(hyp_node_parents), ...
                       'cost', num2cell(hyp_node_costs));        % <-- update! [2b]

                   
  % P1') AddNodes: update open_list: Unique-constrained Priority Queue (U-Priority Queue)
    open_list = [open_list hyp_nodes];
    [~, idx] = sort([open_list.cost]);            % <-- new! 値，何番目かが帰ってくる
    open_list = open_list(idx);                   % <-- new!
    [~, idx] = unique([open_list.id], 'first');   % <-- new!
    open_list = open_list(sort(idx));             % <-- new!
    
    DEBUG_open_list = [[open_list.id]; [open_list.parent]; [open_list.cost]]          % for debug

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
