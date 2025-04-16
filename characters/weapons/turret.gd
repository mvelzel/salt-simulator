extends "res://characters/weapons/weapon.gd"

const TURRET_RADIUS = 200

var turret_indicator_layer: TileMapLayer
var floor_layer: TileMapLayer
var pillars_layer: TileMapLayer
var turrets_layer: TileMapLayer

func _ready() -> void:
	for layer in get_tree().get_nodes_in_group("TileMapLayers"):
		if layer.name == "Floor":
			floor_layer = layer
		elif layer.name == "TurretIndicator":
			turret_indicator_layer = layer
		elif layer.name == "Turrets":
			turrets_layer = layer
		elif layer.name == "Pillars":
			pillars_layer = layer

var active_tile
func _process(_delta: float) -> void:
	turret_indicator_layer.clear()
			
	if enabled and turret_indicator_layer:
		active_tile = null
		var mouse_position = get_local_mouse_position()
		if mouse_position.length() <= TURRET_RADIUS:
			var global_mouse_position = to_global(mouse_position)
			var map_location = turret_indicator_layer.local_to_map(turret_indicator_layer.to_local(global_mouse_position))
			
			var floor_tile_data = floor_layer.get_cell_tile_data(map_location)
			var pillar_tile_data = pillars_layer.get_cell_tile_data(map_location)
			var turret_tile_data = turrets_layer.get_cell_alternative_tile(map_location)

			if floor_tile_data and not pillar_tile_data and turret_tile_data < 0:
				turret_indicator_layer.set_cell(map_location, 5, Vector2i(2, 19))
				active_tile = map_location

func attack():
	if active_tile:
		turrets_layer.set_cell(active_tile, 6, Vector2i(0,0), 1)
		
		super.attack()
