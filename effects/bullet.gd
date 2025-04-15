extends StaticBody2D

var initial_velocity: Vector2
func set_initial_velocity(start_velocity: Vector2) -> void:
	initial_velocity = start_velocity

func _physics_process(delta: float) -> void:
	var collission = move_and_collide(initial_velocity)
	
	if collission:
		var collider = collission.get_collider()
		if collider.is_in_group("Enemy") and collider.has_method("take_damage"):
			collider.take_damage(100, null, initial_velocity)
		queue_free()
