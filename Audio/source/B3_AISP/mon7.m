%% Calculate power spectrums in each frames
% Reference (pattern) speech
x_ref = audioread('wav/Jan_Goo_1.wav');
frame_x_ref = signal2frame(x_ref, 800, 1024);
PowX_dB_ref = calc_powerspec(frame_x_ref, 1024);

% Input speech
x_in = audioread(['wav/Jan_Goo_2.wav']);
frame_x_in = signal2frame(x_in, 800, 1024);
PowX_dB_in = calc_powerspec(frame_x_in, 1024);

%% Lookup table: Maze axis (m, n) -> Node Index (node.id)
% cf. IElem or DElem macros in Image Processing Experiment
[~, n_max] = size(PowX_dB_in);
[~, m_max] = size(PowX_dB_ref);
mn2nodeid = reshape(1:(n_max*m_max), [m_max n_max]);

%% Prepare Adjacency Matrix
A = zeros(n_max*m_max);
for n = 2:n_max
    for m = 1:m_max
        % Calculate distance in frame m in reference speech and frame n in input speech
        d_mn = sqrt( sum( (PowX_dB_ref(:, m) - PowX_dB_in(:, n)).^2 ) );

        dst_nodeid = mn2nodeid(m, n);

        A(mn2nodeid(  m, n-1), dst_nodeid) = d_mn;      % (1)

        if m >= 2
            A(mn2nodeid(m-1, n-1), dst_nodeid) = d_mn;  % (2)
        end

        if m >= 3
            A(mn2nodeid(m-2, n-1), dst_nodeid) = d_mn;  % (3)
        end
    end
end
initial_node = 1;
target_node  = mn2nodeid(end);

% AddNodes: open_list‚Ì‰Šú‰»
open_list = [ struct('id', initial_node, 'parent', 0, 'cost', 0) ];

% closed_list‚Ì‰Šú‰»D‹ó‚Å—Ç‚¢D
closed_list = [];

% ƒI[ƒvƒ“ƒŠƒXƒg‚ª‹ó‚É‚È‚é‚Ü‚Åƒ‹[ƒv‚·‚é
while ~isempty(open_list)   % ExistAnyNodes

    % PickupNode: implementation by Queue
    cur_node = open_list(1);
    open_list(1) = [];

    % AddNodes: update closed_list
    closed_list = [closed_list cur_node];
    [[closed_list.id]; [closed_list.parent]; [closed_list.cost]]  % for debug

    % IsTargetNode
    %if cur_node == target_node
    if cur_node.id == target_node
        disp('Got a Target node!');
        break
    end

    % GetAdjacentNodes
    hyp_node_ids = find(A(cur_node.id, :) > 0);

    % DeleteNodesInClosedList
    if ~isempty(closed_list)
        hyp_node_ids = hyp_node_ids(~ismember(hyp_node_ids, [closed_list.id]));
    end

    % DeleteNodesInList: remove nodes in open_list
    %    **ToDo:** This process will be omitted after 'AI-2' 
    %if ~isempty(open_list)
    %    hyp_node_ids = hyp_node_ids(~ismember(hyp_node_ids, [open_list.id]))
    %end

    % Validation: hyp_node_ids     ¦ 2C‚Ì—ûK–â‘è(1)‚Ì‰ð“š—á‚Å‚·D
    if isempty(hyp_node_ids)
        continue   % ignore PrepareNodes and AddNodes for open_list
    end

    % PrepareNodes
    hyp_node_costs = A(cur_node.id, hyp_node_ids) + cur_node.cost;
    hyp_node_parents = repmat(cur_node.id, size(hyp_node_ids));
    hyp_nodes = struct('id', num2cell(hyp_node_ids), ...
                       'parent', num2cell(hyp_node_parents), ...
                       'cost', num2cell(hyp_node_costs));

    % AddNodes: update open_list as U-Priority Queue
    open_list = [open_list hyp_nodes];
    [~, idx] = sort([open_list.cost]);
    open_list = open_list(idx);
    [~, idx] = unique([open_list.id], 'first');
    open_list = open_list(sort(idx));
end

%% Back tracking
%   NOTE: The closed_list must contain the target_node.
cur_id = target_node;
route = [];
while cur_id > 0
    route = [cur_id route];                          % route‚Ìæ“ª‚ÉC’H‚Á‚Ä‚¢‚é“r’†‚Ìƒm[ƒh(cur_node)‚ð’Ç‰Á‚µ‚Ä‚¢‚­
    array_index = find([closed_list.id] == cur_id);  % Œ»Ý‚Ìƒm[ƒh‚ªclosed_list‚ÉŠi”[‚³‚ê‚Ä‚¢‚éêŠ‚ð’T‚µ‚ÄC
    cur_id = closed_list(array_index(1)).parent;     % ‚»‚Ìeƒm[ƒh‚Ì”Ô†‚ð“¾‚é
end
route     % route‚ÉŒo˜Hã‚Ìƒm[ƒh‚ª‡”Ô‚ÉŠi”[‚³‚ê‚Ä‚¢‚é
% Save the cost at target node
distance = cur_node.cost

% Debug Search Graph

%% 'xy' axis data for gplot function
[X1,Y1] = meshgrid(1:m_max, 1:n_max);
xy = [X1(:) Y1(:)];   % --> xy = [ [1 1]; [1 2]; ...; [m_max n_max] ]

%% Plot the Graph
%   see Section 1D-5 and Appendix AI-A6
[X,Y] = gplot(A, xy);
plot(X,Y, 'o-', 'MarkerSize', 10, 'MarkerFaceColor', 'cyan');

%% Node number
text(xy(:,1)+0.05, xy(:,2)+0.05, num2cell(1:length(xy)), 'Color', 'red', 'FontSize', 11);

%% Highlight 'Initial node' and 'Target node'
% ™ 'p', Z 'o'
hold on;
scatter(xy(initial_node,1), xy(initial_node,2), 540, 'r', 'p', 'filled');
scatter(xy(target_node,1), xy(target_node,2), 360, 'r', 'o', 'LineWidth', 2);
hold off;

%% Highlight edges and nodes on the 'route'
%  only if the 'route' variable is defined and it is vector
if exist('route', 'var') ~= 0 && length(route) > 1
    Ax = zeros(size(A));
    for n = 1:length(route)-1
      Ax(route(n), route(n+1)) = 1;
    end

    [X,Y] = gplot(Ax, xy);
    hold on;
    plot(X,Y, 'o-', ...
        'MarkerSize', 10, 'MarkerFaceColor', 'red', ...
        'LineWidth', 2);
    hold off;
end

%% Customize chart objects
xlim([0 n_max+1]); ylim([0 m_max+1]);
xlabel('n (Frame number of Input speech)');
ylabel('m (Frame number of Reference speech)');

%% Chart title
%  (ToDo: Change the chart's title as your objective!!)
if exist('distance', 'var') ~= 0 && length(distance) == 1
  title(['Input: Goo_2; ' 'Reference: Goo_1; ' 'Total cost = ' num2str(distance)]);
end

%% Clear temporary variables
clear X Y;