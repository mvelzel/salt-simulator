extends Control

@export var weapon_type: String = "sword"
@export var is_subtle = false

var ammo_label: RichTextLabel

func _ready():
	if not weapon_type:
		return
		
	if is_subtle:
		$ActiveBackground.modulate.a = 0.5
		$InactiveBackground.modulate.a = 0.5
		ammo_label = $AmmoLabelSmall
	else:
		ammo_label = $AmmoLabel
		
	for child in $WeaponSprite.get_children():
		child.visible = false
	if weapon_type == "sword":
		$WeaponSprite/SwordSprite.visible = true
	elif weapon_type == "gun":
		$WeaponSprite/GunSprite.visible = true
	elif weapon_type == "turret":
		$WeaponSprite/TurretSprite.visible = true
		
func set_ammo(type, current, max):
	if type == weapon_type:
		if current and max:
			ammo_label.visible = true
			ammo_label.text = "%d/%d" % [current, max]
		else:
			ammo_label.visible = false
		
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
		
func show_weapon(type):
	if type == weapon_type:
		visible = true
		
func only_show_weapon(type):
	if type == weapon_type:
		visible = true
	else:
		visible = false
