extends Node2D

const SoundUtils = preload("res://utils/SoundUtils.gd")
var enabled = false

@onready var gun_shot_sound_resource: AudioStream = preload("res://sounds/gun-shot.mp3")

@export var bullet_scene: PackedScene
@export var bullet_speed = 75

func disable():
	visible = false
	enabled = false
	
func enable():
	visible = true
	enabled = true

func _unhandled_input(event) -> void:
	if enabled and event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = global_rotation
		
		var direction = Vector2.RIGHT.rotated(global_rotation)
		var velocity = direction * bullet_speed
		bullet.set_initial_velocity(velocity)
		
		_play_gun_shot_sound()

func _play_gun_shot_sound() -> void:
	SoundUtils.play_sound(self, gun_shot_sound_resource)
