extends Node2D

@export var weapon_type: String
@export var damage: float
@export var auto_fire: bool
@export var rotate_switch: bool = true

var enabled = false
signal weapon_fired

func change_weapon(type):
	if weapon_type == type:
		enabled = true
		visible = true
		$WeaponSwitchSound.play()
	else:
		enabled = false
		visible = false	
		
var can_attack = true
func _process(_delta: float) -> void:
	if rotate_switch:
		if scale.y < 0:
			if abs(global_rotation) <= PI / 2:
				scale = Vector2(scale.x, scale.y * -1)
		else:
			if abs(global_rotation) > PI / 2:
				scale = Vector2(scale.x, scale.y * -1)

func _unhandled_input(event: InputEvent) -> void:
	if enabled and not Global.is_mobile():
		# TODO reimplement auto_fire
		if event.is_action_pressed("attack"):
			attack()

func attack():
	if not enabled or not can_attack:
		return false
		
	$WeaponSound.play()
	can_attack = false
	weapon_fired.emit()
	$Delay.start()
	return true

func _on_delay_timeout() -> void:
	can_attack = true
