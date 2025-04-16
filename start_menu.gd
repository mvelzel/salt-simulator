extends Node2D

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level1.tscn")
