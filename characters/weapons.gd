extends Node2D

@export var default_weapon = "sword"

func _ready() -> void:
	change_weapon(default_weapon)

func change_weapon(type) -> void:
	for child in get_children():
		if child.has_method("change_weapon"):
			child.change_weapon(type)
