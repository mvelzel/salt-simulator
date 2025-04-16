extends "res://characters/base_character.gd"

@onready var footstep_sound = $FootstepSound

const INDICATOR_DISTANCE = 150

@export var active_weapons: Array[String] = ["sword"]

var weapon_key_mapping = {
	KEY_1: "sword",
	KEY_2: "gun",
	KEY_3: "turret"
}

func _ready() -> void:
	change_weapon("sword")
	
	for weapon in weapon_key_mapping.values():
		if weapon in active_weapons:
			continue
		for child in $CanvasLayer/WeaponIndicators.get_children():
			if child.has_method("hide_weapon"):
				child.hide_weapon(weapon)
	
	super._ready()

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
	$Weapons.position = mouse_position.normalized() * INDICATOR_DISTANCE
	$Weapons.rotation = Vector2.ZERO.direction_to(mouse_position).angle()

func die():
	get_tree().reload_current_scene()
	
func take_damage(damage: float, source: Node2D, direction: Vector2 = Vector2.ZERO) -> void:	
	super.take_damage(damage, source, direction)
	
	$CanvasLayer/HealthBar.render_bar(health / max_health * 10)

func _walk_sounds_effects():
	if velocity.length() > 10: 
		if not footstep_sound.playing:
			footstep_sound.play()
	else:
		footstep_sound.stop()

var disabled_weapons = []
func disable_weapon(type):
	disabled_weapons.append(type)
	for child in $CanvasLayer/WeaponIndicators.get_children():
		if child.has_method("disable"):
			child.disable(type)
	
func enable_weapon(type):
	disabled_weapons = disabled_weapons.filter(func(weapon): return weapon != type)
	for child in $CanvasLayer/WeaponIndicators.get_children():
		if child.has_method("enable"):
			child.enable(type)
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			for key in weapon_key_mapping:
				var weapon = weapon_key_mapping[key]
				if event.keycode == key and weapon not in disabled_weapons and weapon in active_weapons:
					change_weapon(weapon_key_mapping[key])
					break
				
func change_weapon(type):
	$Weapons.change_weapon(type)
	for child in $CanvasLayer/WeaponIndicators.get_children():
		if child.has_method("change_weapon"):
			child.change_weapon(type)

var dragging_pipe
func set_pipe(pipe):
	if dragging_pipe == null and pipe != null:
		$Pipe/GrabPipeSound.play()
	
	dragging_pipe = pipe
	if dragging_pipe:
		speed = default_speed / 2
		change_weapon("sword")
		for weapon in weapon_key_mapping.values():
			if weapon != "sword":
				disable_weapon(weapon)
	else:
		speed = default_speed
		for weapon in weapon_key_mapping.values():
			enable_weapon(weapon)

func get_pipe():
	return dragging_pipe
