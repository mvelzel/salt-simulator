extends "res://characters/base_character.gd"

var player: Node2D

func _ready() -> void:
	speed = 300
	health = 300
	$NavigationAgent2D.max_speed = speed
	
	player = get_tree().get_first_node_in_group("Player")
	
	super._ready()

var is_enabled = true
func _physics_process(delta: float) -> void:
	if is_enabled and player:
		$NavigationAgent2D.target_position = player.global_position
		if $NavigationAgent2D.is_navigation_finished():
			return
		
		var next_path_position = $NavigationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_path_position)
		
		var new_velocity = direction * speed
		
		if $NavigationAgent2D.avoidance_enabled:
			$NavigationAgent2D.set_velocity(new_velocity)
		else:
			velocity = new_velocity
		
		super._physics_process(delta)
	
func die():
	visible = false
	turn_off()
	await $hurtSound.finished
	queue_free()

func turn_on():
	is_enabled = true

func turn_off():
	is_enabled = false

var overlapping_player = false
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("take_damage"):
		overlapping_player = true
		
		if $DamagePlayerTimer.is_stopped():
			player.take_damage(50, self)
			$DamagePlayerTimer.start()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		overlapping_player = false

func _on_damage_player_timer_timeout() -> void:
	if overlapping_player and player.has_method("take_damage"):
		player.take_damage(50, self)
		$DamagePlayerTimer.start()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
