extends Node2D

var floor_layer
var pipe_layer
var pillars_layer
@onready var difficulty_manager = get_tree().get_first_node_in_group("DifficultyManager")

var player: Node2D

var astar_grid: AStarGrid2D

@export var level_finish_salt_threshold = 15
@export var max_salt = 30
var current_salt = 0

func _ready() -> void:
	if Global.is_debug():
		$PumpTimer.wait_time /= 10
	
	player = get_tree().get_first_node_in_group("Player")
	for layer in get_tree().get_nodes_in_group("TileMapLayers"):
		if layer.name == "Floor":
			floor_layer = layer
		elif layer.name == "Pipe":
			pipe_layer = layer
		elif layer.name == "Pillars":
			pillars_layer = layer
	
	$CanvasLayer/SaltProgress.scaffold_steps(level_finish_salt_threshold)
	
	astar_grid = AStarGrid2D.new()
	var region = floor_layer.get_used_rect()
	region = Rect2i(
		Vector2i(region.position.x - 1, region.position.y - 1),
		Vector2i(region.size.x + 2, region.size.y + 2)
	)
	astar_grid.region = region
	astar_grid.cell_size = pipe_layer.tile_set.tile_size
	
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astar_grid.update()
	
	var self_tile_pos = floor_layer.local_to_map(floor_layer.to_local(global_position))
	
	for x in range(region.size.x):
		for y in range(region.size.y):
			var tile_pos = Vector2i(x + region.position.x, y + region.position.y)
			
			if tile_pos == self_tile_pos:
				continue
			
			var floor_tile_data = floor_layer.get_cell_tile_data(tile_pos)
			var pillar_tile_data = pillars_layer.get_cell_tile_data(tile_pos)

			if not floor_tile_data or not floor_tile_data.get_navigation_polygon(0):
				astar_grid.set_point_solid(tile_pos)
			if pillar_tile_data:
				astar_grid.set_point_solid(tile_pos)

func finish():
	get_node("%SceneTransitionRect").transition_to()

var is_dragging = false
var is_pumping = false

var player_is_in_grab_area = false
func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_grab_area = true
		set_interaction()

func _on_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_grab_area = false
		set_interaction()

var pipe_end: Node2D
func start_pumping(pump_pipe_end: Node2D):
	pipe_end = pump_pipe_end
	is_dragging = false
	is_pumping = true
	$PipeLocation.global_position = pipe_end.global_position
	$CanvasLayer/SaltProgress.visible = true
	$PumpTimer.start()
	difficulty_manager.add_difficulty_stage(1)
	player.set_pipe(null)
	set_interaction()
		
func stop_pumping():
	is_dragging = true
	is_pumping = false
	$PumpTimer.stop()
	$CanvasLayer/SaltProgress.visible = false
	difficulty_manager.add_difficulty_stage(3)
	if pipe_end and pipe_end.has_method("stop_pumping"):
		pipe_end.stop_pumping()
	
	player.set_pipe(self)
	set_interaction()
		
func get_is_pumping():
	return is_pumping
			
func start_dragging():
	is_dragging = true
	$SheathedPipe.visible = false
	$UnsheathedPipe.visible = true
	player.set_pipe(self)
	set_interaction()
	
func stop_dragging():
	is_dragging = false
	var target_position = $PipeLocation.global_position
	var self_tile_pos = floor_layer.local_to_map(floor_layer.to_local(global_position))
	var target_tile_pos = floor_layer.local_to_map(floor_layer.to_local(target_position))
	if self_tile_pos == target_tile_pos:
		$SheathedPipe.visible = true
		$UnsheathedPipe.visible = false
	
	player.set_pipe(null)
	set_interaction()
		
var player_is_in_finish_area = false
func _on_finish_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_finish_area = true
		set_interaction()

func _on_finish_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_finish_area = false
		set_interaction()

func set_interaction():
	player.pop_interaction("GRAB")
	player.pop_interaction("DROP")
	player.pop_interaction("FINISH")
	$FinishLabel.visible = false
	$PipeLocation/GrabLabel.visible = false
	
	if player_is_in_finish_area and current_salt >= level_finish_salt_threshold and player.get_pipe():
		$FinishLabel.visible = true
		player.push_interaction("FINISH", finish)
	elif player_is_in_grab_area:
		if is_pumping and current_salt >= level_finish_salt_threshold:
			$PipeLocation/GrabLabel.visible = true
			player.push_interaction("GRAB", stop_pumping)
		elif not is_pumping and is_dragging:
			player.push_interaction("DROP", stop_dragging)
		elif not is_pumping and not is_dragging:
			player.push_interaction("GRAB", start_dragging)
			$PipeLocation/GrabLabel.visible = true

var previous_position
var previous_path
func _process(_delta: float) -> void:
	if is_dragging and player:
		$PipeLocation.global_position = player.global_position
	
	var target_position = $PipeLocation.global_position
	if previous_position == target_position:
		return
	
	previous_position = target_position
		
	var self_tile_pos = floor_layer.local_to_map(floor_layer.to_local(global_position))
	
	var target_tile_pos = floor_layer.local_to_map(floor_layer.to_local(target_position))
	
	var path = astar_grid.get_id_path(self_tile_pos, target_tile_pos, true)

	if previous_path:
		for point in previous_path:
			pipe_layer.set_cell(point, -1)
			
	pipe_layer.set_cells_terrain_path(path, 0, 1)
	previous_path = path

func _on_pump_timer_timeout() -> void:
	current_salt += 1
	$CanvasLayer/SaltProgress.render_bar(current_salt)
	
	if current_salt >= level_finish_salt_threshold:
		if current_salt >= level_finish_salt_threshold + 4:
			difficulty_manager.add_difficulty_stage(2)
		$CanvasLayer/SaltProgress/RichTextLabel.text = "[shake][color=red]!!! [/color]Pumping [font gl=\"2\" emb=\"1\"]MORE[/font] salt[color=red] !!![/color]"
		set_interaction()
	
	if current_salt == max_salt:
		$CanvasLayer/SaltProgress/RichTextLabel.text = "[shake][color=red][font gl=\"2\" emb=\"1\"]MAX SALT - LEAVE NOW"
		$PumpTimer.stop()
