extends Node2D

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
	var temp_audio_player = AudioStreamPlayer2D.new()
	temp_audio_player.stream = gun_shot_sound_resource
	
	add_child(temp_audio_player)
	
	temp_audio_player.play()
	
	var sound_length = temp_audio_player.stream.get_length()
	
	await get_tree().create_timer(sound_length).timeout
	temp_audio_player.queue_free()
