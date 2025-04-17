extends Node2D

@export var weapon_type: String
@export var damage: float

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
		
func _process(_delta: float) -> void:
	if scale.y < 0:
		if abs(global_rotation) <= PI / 2:
			scale = Vector2(scale.x, scale.y * -1)
	else:
		if abs(global_rotation) > PI / 2:
			scale = Vector2(scale.x, scale.y * -1)

var can_attack = true
func _unhandled_input(event: InputEvent) -> void:
	if enabled:
		if Input.is_action_pressed("attack"):
			if can_attack:
				attack() 

func attack():
	$WeaponSound.play()
	
	can_attack = false
	weapon_fired.emit()
	$Delay.start()

func _on_delay_timeout() -> void:
	can_attack = true
