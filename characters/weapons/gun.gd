extends "res://characters/weapons/weapon.gd"

@export var bullet_scene: PackedScene
@export var bullet_speed = 75

func attack():
	if not super.attack():
		return false
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_rotation = global_rotation
	
	var direction = Vector2.RIGHT.rotated(global_rotation)
	var velocity = direction * bullet_speed
	bullet.set_initial_velocity(velocity)
	
	return true
