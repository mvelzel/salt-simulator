extends Node2D

@export var weapon_type: String = "sword"

func _ready():
	if not weapon_type:
		return
		
	for child in $WeaponSprite.get_children():
		child.visible = false
	if weapon_type == "sword":
		$WeaponSprite/SwordSprite.visible = true
	elif weapon_type == "gun":
		$WeaponSprite/GunSprite.visible = true
	elif weapon_type == "turret":
		$WeaponSprite/TurretSprite.visible = true
		
func set_ammo(current: int, max: int):
	$AmmoLabel.visible = true
	$AmmoLabel.text = "%d/%d" % [current, max]
		
func change_weapon(type):
	if type == weapon_type:
		$ActiveBackground.visible = true
		$InactiveBackground.visible = false
		$WeaponSprite.modulate.a = 1.0
	else:
		$ActiveBackground.visible = false
		$InactiveBackground.visible = true
		$WeaponSprite.modulate.a = 0.5
		
func disable(type = null):
	if not type or type == weapon_type:
		$DisabledSprite.visible = true
	
func enable(type = null):
	if not type or type == weapon_type:
		$DisabledSprite.visible = false
		
func hide_weapon(type):
	if type == weapon_type:
		visible = false
