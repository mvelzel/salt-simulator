extends CharacterBody2D

@export var health = 500.0
@export var speed = 500.0
@export var knockback_modifier = 15

var base_modulation: Color
func _ready() -> void:
	base_modulation = $Sprite.self_modulate
	
var knockback = Vector2.ZERO

func _physics_process(delta: float) -> void:
	set_animation()
	
	velocity = velocity + knockback
	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
func set_animation():
	if velocity.x < 0 and abs(velocity.x) >= abs(velocity.y): # Left
		$Sprite.play("walk_left")
	elif velocity.x > 0  and abs(velocity.x) >= abs(velocity.y): # Right
		$Sprite.play("walk_right")
	elif velocity.y > 0: # Down
		$Sprite.play("walk_down")
	elif velocity.y < 0: # Up
		$Sprite.play("walk_up")
	else: # Idle
		$Sprite.play("idle")
		
func take_damage(damage: float, source: Node2D) -> void:
	health -= damage
	if health < 0:
		die()
		return
		
	var knockback_direction = source.position.direction_to(position)
	knockback = knockback_direction * damage * knockback_modifier
	
	$Sprite.self_modulate = Color(1, 0, 0)
	$DamageFlash.start()
		
func die():
	pass

func _on_damage_flash_timeout() -> void:
	$Sprite.self_modulate = base_modulation
