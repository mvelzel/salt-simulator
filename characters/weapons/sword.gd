extends "res://characters/weapons/weapon.gd"

var is_initial_pos = true
func attack():
	if is_initial_pos:
		$AnimationPlayer.play("swing_to")
	else:
		$AnimationPlayer.play("swing_fro")
	is_initial_pos = not is_initial_pos
	
	super.attack()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $AnimationPlayer.is_playing():
		if body.is_in_group("Enemy") and body.has_method("take_damage"):
			body.take_damage(damage, self)
