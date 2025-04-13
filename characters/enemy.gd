extends CharacterBody2D

@export var health = 200
@export var flash_timeout: Timer
@export var sprite: Sprite2D
var base_modulation: Color

func _ready() -> void:
	if sprite:
		base_modulation = sprite.self_modulate

func take_damage(damage: float) -> void:
	health -= damage
	if health < 0:
		queue_free()
		return
	
	if flash_timeout and sprite:
		sprite.self_modulate = Color(1, 1, 1)
		flash_timeout.start()

func _on_damage_flash_timeout() -> void:
	if sprite:
		sprite.self_modulate = base_modulation
