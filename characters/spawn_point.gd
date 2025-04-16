extends Node2D

@export var enemy_scene: PackedScene
@export var stage: int = 1

var difficulty_manager

var padding_y = 64
var padding_x = 32

var base_time

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	enemy.scale = Vector2(1, 1)
	$WarnSprite.play()
	randomize_time()
	
var enabled = false
var screen_visible = true

func _ready() -> void:
	base_time = $SpawnTimer.wait_time
	randomize_time()
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	difficulty_manager = get_tree().root.get_children()[0].get_node("%DifficultyManager")
	
func randomize_time() -> void:
	$SpawnTimer.wait_time = base_time + randf_range(-1, 1)

func get_camera_rect() -> Rect2:
	var camera = get_viewport().get_camera_2d()
	var camera_size = get_viewport_rect().size * camera.zoom
	var camera_rect = Rect2(camera.get_screen_center_position() - camera_size / 2, camera_size)
	return camera_rect

func _process(delta: float) -> void:
	if not enabled and stage in difficulty_manager.get_difficulty_stages():
		turn_on()
		
	if enabled:
		var g_pos = global_position
		var camera_rect = get_camera_rect()
  
		if g_pos.x < camera_rect.position.x || g_pos.y < camera_rect.position.y || g_pos.x > (camera_rect.position.x + camera_rect.size.x) || g_pos.y > (camera_rect.position.y + camera_rect.size.y):
			$WarnSprite.visible = true
			var new_pos = g_pos
			new_pos.x = clamp(new_pos.x, camera_rect.position.x + padding_x, camera_rect.position.x + camera_rect.size.x - padding_x)
			new_pos.y = clamp(new_pos.y, camera_rect.position.y + padding_y, camera_rect.position.y + camera_rect.size.y - padding_y)
			$WarnSprite.global_position = new_pos
		else:
			$WarnSprite.visible = false

func turn_on():
	enabled = true
	if not screen_visible:
		_on_spawn_timer_timeout()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_visible = true
	$SpawnTimer.stop()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_visible = false
	if enabled:
		$SpawnTimer.start()
