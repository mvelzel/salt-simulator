extends Node2D

@onready var floor_layer: TileMapLayer = get_node("%Map").get_node("%Floor")
@onready var pipe_layer: TileMapLayer = get_node("%Map").get_node("%Pipe")
@onready var pillars_layer: TileMapLayer = get_node("%Map").get_node("%Pillars")
var player: Node2D

var astar_grid: AStarGrid2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
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

var is_dragging = false
var is_pumping = false

var can_grab = false
func _on_trigger_body_entered(body: Node2D) -> void:
	can_grab = true
	if body.is_in_group("Player"):
		if not is_dragging and not is_pumping:
			$PipeLocation/GrabLabel.visible = true

func _on_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_grab = false
		$PipeLocation/GrabLabel.visible = false	

func start_pumping(pipe_end: Node2D):
	is_dragging = false
	is_pumping = true
	$PipeLocation/GrabLabel.visible = false
	$PipeLocation.global_position = pipe_end.global_position
	if player and player.has_method("set_pipe"):
		player.set_pipe(null)
		
func stop_pumping():
	is_dragging = true
	is_pumping = false
	if player and player.has_method("set_pipe"):
		player.set_pipe(self)
		
func get_is_pumping():
	return is_pumping

func _unhandled_input(event):
	if not is_pumping and event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_E:
				if not is_dragging and can_grab:
					start_dragging()
				else:
					stop_dragging()
				
var previous_path
			
func start_dragging():
	is_dragging = true
	$SheathedPipe.visible = false
	$UnsheathedPipe.visible = true
	$PipeLocation/GrabLabel.visible = false
	if player and player.has_method("set_pipe"):
		player.set_pipe(self)
	
func stop_dragging():
	is_dragging = false
	
	var target_position = $PipeLocation.global_position
	var self_tile_pos = floor_layer.local_to_map(floor_layer.to_local(global_position))
	var target_tile_pos = floor_layer.local_to_map(floor_layer.to_local(target_position))
	if self_tile_pos == target_tile_pos:
		$SheathedPipe.visible = true
		$UnsheathedPipe.visible = false
	
	$PipeLocation/GrabLabel.visible = true
	if player and player.has_method("set_pipe"):
		player.set_pipe(null)

var previous_position

func _process(delta: float) -> void:
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
