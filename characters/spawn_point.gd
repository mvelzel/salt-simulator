extends Node2D

@export var enemy_scene: PackedScene
@export var stage: int = 1

@onready var difficulty_manager = get_tree().root.get_children()[0].get_node("%DifficultyManager")

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	
var enabled = false
var screen_visible = true

func _process(delta: float) -> void:
	if not enabled and stage in difficulty_manager.get_difficulty_stages():
		turn_on()

func turn_on():
	enabled = true
	if not screen_visible:
		$SpawnTimer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_visible = true
	$SpawnTimer.stop()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	screen_visible = false
	if enabled:
		$SpawnTimer.start()
