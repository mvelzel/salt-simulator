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
		sprite.self_modulate = Color(1, 0, 0)
		flash_timeout.start()

func _on_damage_flash_timeout() -> void:
	if sprite:
		sprite.self_modulate = base_modulation
		
@export var SPEED = 250.0

var is_enabled = true

func _physics_process(_delta: float) -> void:
	if is_enabled:
		var player = get_tree().get_nodes_in_group("Player")[0]
		var direction = (player.position - position).normalized()
		
		velocity = direction * SPEED
		
		move_and_slide()
		
func turn_on():
	is_enabled = true

func turn_off():
	is_enabled = false
