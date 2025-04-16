extends Node2D

var difficulty_stages: Array[int] = [0]

func _ready() -> void:
	$BackgroundMusicExploration.play()

func add_difficulty_stage(stage: int):
	difficulty_stages.append(stage)
	
	if stage > 0 && !$BackgroundMusicActionFight.playing:
		$BackgroundMusicExploration.stop()
		$BackgroundMusicActionFight.play()
	
func get_difficulty_stages() -> Array[int]:
	return difficulty_stages
