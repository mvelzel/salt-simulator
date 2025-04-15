extends Node2D

@export var enemy_scene: PackedScene

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	get_node("../").add_child(enemy)
	enemy.global_position = global_position
	
var enabled = false	
var screen_visible = true
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
