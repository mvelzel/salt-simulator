extends "res://characters/weapons/weapon.gd"

var is_initial_pos = true

var active_enemies = []

func attack():
	if not super.attack():
		return false
	
	var anim = $SwingAnimation
	if is_initial_pos:
		$AnimationPlayer.play("swing_to")
	else:
		$AnimationPlayer.play("swing_fro")
		
	anim.scale = Vector2(anim.scale.x, anim.scale.y * -1)
	$SwingAnimation.stop()
	$SwingAnimation.play("swing")
	for active_enemy in active_enemies:
		if is_instance_valid(active_enemy):
			active_enemy.take_damage(damage, null, Vector2.RIGHT.rotated(global_rotation))
	is_initial_pos = not is_initial_pos
	
	return true 

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		active_enemies.append(body)
		if $AnimationPlayer.is_playing():
			body.take_damage(damage, null, Vector2.RIGHT.rotated(global_rotation))

func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		var enemy = active_enemies.find(body)
		if enemy:
			active_enemies.remove_at(enemy)
