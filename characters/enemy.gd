extends "res://characters/base_character.gd"

func _ready() -> void:
	speed = 300
	health = 300
	super._ready()

var is_enabled = false
func _physics_process(delta: float) -> void:
	if is_enabled:
		var player = get_tree().get_nodes_in_group("Player")[0]
		var direction = (player.position - position).normalized()
		
		velocity = direction * speed
		
	super._physics_process(delta)
	
func die():
	queue_free()

func turn_on():
	is_enabled = true

func turn_off():
	is_enabled = false

var player: Node2D
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("take_damage"):
		player = body
		
		if $DamagePlayerTimer.is_stopped():
			player.take_damage(50, self)
			$DamagePlayerTimer.start()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null

func _on_damage_player_timer_timeout() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(50, self)
		$DamagePlayerTimer.start()
