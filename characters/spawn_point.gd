extends Node2D

@export var enemy_scene: PackedScene
@export var stage: int = 1

@onready var difficulty_manager = get_tree().get_first_node_in_group("DifficultyManager")

var padding_y = 64
var padding_x = 32

var base_time

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = global_position
	enemy.scale = Vector2(1, 1)
	$WarnSprite.play()
	randomize_time()
	$SpawnTimer.start()
	
var enabled = false
var screen_visible = false

func _ready() -> void:
	base_time = $SpawnTimer.wait_time
	randomize_time()

func randomize_time() -> void:
	$SpawnTimer.wait_time = base_time + randf_range(-1, 1)

func get_camera_rect() -> Rect2:
	var camera = get_viewport().get_camera_2d()
	var camera_size = get_viewport_rect().size * camera.zoom
	var camera_rect = Rect2(camera.get_screen_center_position() - camera_size / 2, camera_size)
	return camera_rect

func _process(delta: float) -> void:
	if not enabled and difficulty_manager and stage in difficulty_manager.get_difficulty_stages():
		do_turn_on()
		
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

func do_turn_on():
	enabled = true
	if not screen_visible:
		_on_spawn_timer_timeout()
	else:
		$SpawnTimer.start()
		$SpawnTimer.paused = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_visible = true
	$SpawnTimer.paused = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_visible = false
	$SpawnTimer.paused = false

func _on_spawn_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and enabled:
		$SpawnTimer.paused = false
		
func _on_spawn_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and enabled:
		$SpawnTimer.paused = true
