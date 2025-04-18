extends Node2D

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level1.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		_on_texture_button_pressed()
