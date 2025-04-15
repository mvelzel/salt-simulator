extends Node2D

var enabled = false

@export var bullet_scene: PackedScene
@export var bullet_speed = 75

func disable():
	visible = false
	enabled = false
	
func enable():
	visible = true
	enabled = true

func _unhandled_input(event) -> void:
	if enabled and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = global_rotation
		
		var direction = Vector2.RIGHT.rotated(global_rotation)
		var velocity = direction * bullet_speed
		bullet.set_initial_velocity(velocity)
