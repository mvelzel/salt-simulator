extends Node2D

@export var enemy_scene: PackedScene

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position
	
var enabled = false	
func turn_on():
	enabled = true
	$SpawnTimer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$SpawnTimer.stop()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if enabled:
		$SpawnTimer.start()
