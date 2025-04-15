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
				
var previous_path
func _process(delta: float) -> void:
	var self_tile_pos = floor_layer.local_to_map(floor_layer.to_local(global_position))
	
	var target_tile_pos = floor_layer.local_to_map(floor_layer.to_local(player.global_position))
	
	var path = astar_grid.get_id_path(self_tile_pos, target_tile_pos, true)

	if previous_path:
		for point in previous_path:
			pipe_layer.set_cell(point, -1)
			
	pipe_layer.set_cells_terrain_path(path, 0, 1)
	previous_path = path
