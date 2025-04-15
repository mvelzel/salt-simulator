extends Node

static func play_sound(parent: Node, sound_resource: AudioStream) -> void:
	var temp_audio_player = AudioStreamPlayer2D.new()
	temp_audio_player.stream = sound_resource
	
	parent.add_child(temp_audio_player)
	
	temp_audio_player.play()
	
	var sound_length = temp_audio_player.stream.get_length()
	
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = sound_length
	parent.add_child(timer)

	timer.connect("timeout", Callable(temp_audio_player, "queue_free"))
	timer.connect("timeout", Callable(timer, "queue_free"))
	timer.start()
