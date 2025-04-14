extends Node2D

@export var animated_sprite: AnimatedSprite2D
@export var swing_delay: Timer
@export var combo_delay: Timer
@export var swing_area: Area2D
@export var character: Node2D

var can_swing = true
var combo = false

func _input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if not combo_delay or not swing_delay or not can_swing or not swing_area:
			return
		
		if can_swing:
			swing_area.monitoring = false
			
			if combo:
				animated_sprite.play("swing2")
				combo = false
			else:
				animated_sprite.play("swing1")
				combo = true
			can_swing = false
			
			swing_area.monitoring = true
			
			swing_delay.start()
			combo_delay.start()

func _on_swing_delay_timeout() -> void:
	can_swing = true

func _on_combo_delay_timeout() -> void:
	combo = false

func _on_swing_anim_animation_finished() -> void:
	if swing_area:
		swing_area.monitoring = false

func _on_swing_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(75, character)
