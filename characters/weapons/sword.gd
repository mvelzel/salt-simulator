extends "res://characters/weapons/weapon.gd"

var is_initial_pos = true
func attack():
	var anim = $SwingAnimation
	if is_initial_pos:
		$AnimationPlayer.play("swing_to")
	else:
		$AnimationPlayer.play("swing_fro")
		
	anim.scale = Vector2(anim.scale.x, anim.scale.y * -1)
	$SwingAnimation.stop()
	$SwingAnimation.play("swing")
	is_initial_pos = not is_initial_pos
	
	super.attack()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $AnimationPlayer.is_playing():
		if body.is_in_group("Enemy") and body.has_method("take_damage"):
			body.take_damage(damage, null, Vector2.RIGHT.rotated(global_rotation))
