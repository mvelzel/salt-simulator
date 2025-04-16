extends Node2D

@export var default_weapon = "sword"

@onready var current_weapon: String = ""

func _ready() -> void:
	change_weapon(default_weapon)

func change_weapon(type) -> void:
	if type == current_weapon:
		return
	
	current_weapon = type
	
	for child in get_children():
		if child.has_method("change_weapon"):
			child.change_weapon(type)
