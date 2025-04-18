extends "res://characters/base_character.gd"

@onready var footstep_sound = $FootstepSound

const INDICATOR_DISTANCE = 150

@export var active_weapons: Array[String] = ["sword"]
@export var turret_amount = 0
var last_mouse_position = Vector2(0,0)

@onready var current_turret_amount = turret_amount

var weapon_key_mapping = {
	KEY_1: "sword",
	KEY_2: "gun",
	KEY_3: "turret"
}

func _ready() -> void:
	change_weapon("sword")
	
	if Global.is_mobile():
		setup_mobile_hud()
	
	if Global.is_debug():
		health = 10000
	
	for weapon in weapon_key_mapping.values():
		if weapon in active_weapons:
			continue
		for child in $UI/WeaponIndicators.get_children():
			if child.has_method("hide_weapon"):
				child.hide_weapon(weapon)
				
	if "turret" in active_weapons:
		$UI/WeaponIndicators/TurretIndicator.set_ammo(current_turret_amount, turret_amount)
	
	super._ready()
	
func setup_mobile_hud():
	$UI/MoveJoystick.visible = true
	$UI/ShootJoystick.visible = true

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
	
	var direction = Vector2(
		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	)
	
	if (direction.x || direction.y):
		$Weapons.position = direction.normalized() * INDICATOR_DISTANCE
		$Weapons.rotation = Vector2.ZERO.direction_to(direction).angle()
		return
		
	
	if not Global.is_mobile():
		var screen_mouse_pos = get_viewport().get_mouse_position()
		if (last_mouse_position != screen_mouse_pos):
			last_mouse_position = screen_mouse_pos
			var mouse_position = get_local_mouse_position()
			$Weapons.position = mouse_position.normalized() * INDICATOR_DISTANCE
			$Weapons.rotation = Vector2.ZERO.direction_to(mouse_position).angle()

func die():
	get_tree().reload_current_scene()
	
func take_damage(damage: float, source: Node2D, direction: Vector2 = Vector2.ZERO) -> void:
	super.take_damage(damage, source, direction)
	
	$UI/HealthBar.render_bar(health / max_health * 10)

func _walk_sounds_effects():
	if velocity.length() > 10:
		if not footstep_sound.playing:
			footstep_sound.play()
	else:
		footstep_sound.stop()

var disabled_weapons = []
func disable_weapon(type):
	disabled_weapons.append(type)
	for child in $UI/WeaponIndicators.get_children():
		if child.has_method("disable"):
			child.disable(type)
	
func enable_weapon(type):
	disabled_weapons = disabled_weapons.filter(func(weapon): return weapon != type)
	for child in $UI/WeaponIndicators.get_children():
		if child.has_method("enable"):
			child.enable(type)
			
			
func _cycle_weapon(dir: int) -> void:
	var list = active_weapons.filter(func(w):
		return w not in disabled_weapons
	)
	if list.size() < 2:
		return

	var current = $Weapons.current_weapon
	var idx = list.find(current)
	if idx == -1:
		idx = 0

	idx = (idx + dir + list.size()) % list.size()
	change_weapon(list[idx])
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_weapon"):
		_cycle_weapon(+1)
		return
	elif Input.is_action_just_pressed("prev_weapon"):
		_cycle_weapon(-1)
		return

	if event is InputEventKey and event.pressed:
		for key in weapon_key_mapping:
			var weapon = weapon_key_mapping[key]
			if event.keycode == key \
			and weapon not in disabled_weapons \
			and weapon in active_weapons:
				change_weapon(weapon)
				break
				
func change_weapon(type):
	$Weapons.change_weapon(type)
	for child in $UI/WeaponIndicators.get_children():
		if child.has_method("change_weapon"):
			child.change_weapon(type)

var dragging_pipe
func set_pipe(pipe):
	if dragging_pipe == null and pipe != null:
		$Pipe/GrabPipeSound.play()
	
	dragging_pipe = pipe
	if dragging_pipe:
		if Global.is_debug():
			speed = default_speed * 2
		else:
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

func _on_turret_weapon_fired() -> void:
	current_turret_amount -= 1
	
	$UI/WeaponIndicators/TurretIndicator.set_ammo(current_turret_amount, turret_amount)
	if current_turret_amount <= 0:
		change_weapon("sword")
		disable_weapon("turret")
		
func _on_shoot_joystick_released() -> void:
	for child in $Weapons.get_children():
		if child.has_method("attack"):
			child.attack()
