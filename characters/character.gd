extends "res://characters/base_character.gd"

@onready var footstep_sound = $FootstepSound

const INDICATOR_DISTANCE = 150

func _physics_process(delta: float) -> void:
	_walk_sounds_effects()

	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	super._physics_process(delta)
	
func _process(_delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	$Indicator.position = mouse_position.normalized() * INDICATOR_DISTANCE
	$Indicator.rotation = Vector2.ZERO.direction_to(mouse_position).angle()

func die():
	get_tree().reload_current_scene()

func _walk_sounds_effects():
	if velocity.length() > 10: 
		if not footstep_sound.playing:
			footstep_sound.play()
	else:
		footstep_sound.stop()
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				$Indicator/Sword.enable()
				$Indicator/Gun.disable()
			if event.keycode == KEY_2:
				$Indicator/Sword.disable()
				$Indicator/Gun.enable()
		
			
			
