extends Node2D

@export var default_weapon = "sword"

@onready var current_weapon: String = ""
@onready var weapon_sounds := {
	"sword": preload("res://sounds/weapon-switch-sword.mp3"),
	"gun": preload("res://sounds/weapon-switch-gun.mp3")
}

func _ready() -> void:
	change_weapon(default_weapon)

func change_weapon(type) -> void:
	if type == current_weapon:
		return
	
	current_weapon = type
	
	for child in get_children():
		if child.has_method("change_weapon"):
			child.change_weapon(type)
	
	_play_switch_sound(type)
	
func _play_switch_sound(type: String):
	if weapon_sounds.has(type):
		var player = AudioStreamPlayer2D.new()
		player.stream = weapon_sounds[type]
		add_child(player)
		player.play()
		
		await get_tree().create_timer(player.stream.get_length()).timeout
		player.queue_free()
