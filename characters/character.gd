extends CharacterBody2D

@export var health = 500
@export var SPEED = 300.0
@export var sprite: Sprite2D

func _physics_process(_delta: float) -> void:
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
@export var indicator_node: Node2D
const INDICATOR_DISTANCE = 150
	
func _process(_delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	indicator_node.position = mouse_position.normalized() * INDICATOR_DISTANCE
	indicator_node.rotation = Vector2.ZERO.direction_to(mouse_position).angle()

var enemy_contact_list: Array[Node2D] = []
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_contact_list.append(body)
		timer_take_damage(body)
		

const DAMAGE_DELAY = 0.75
func timer_take_damage(body: Node2D):
	health = health - 50
	
	sprite.self_modulate = Color(1,0,0)
	$DamageFlash.start()
	
	if health <= 0:
		get_tree().reload_current_scene()
		return
	
	await get_tree().create_timer(DAMAGE_DELAY).timeout
	if enemy_contact_list.find(body) != -1:
		timer_take_damage(body)
	
func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy_contact_list.remove_at(enemy_contact_list.find(body))


func _on_damage_flash_timeout() -> void:
	sprite.self_modulate = Color(1,1,1)
