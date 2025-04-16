extends Node2D

var difficulty_stages: Array[int] = [0]
var succeeded;

func _ready() -> void:
	$BackgroundMusicExploration.play()

func add_difficulty_stage(stage: int):
	difficulty_stages.append(stage)
	
	if stage > 0 && !$BackgroundMusicActionFight.playing:
		$BackgroundMusicExploration.stop()
		$BackgroundMusicActionFight.play()
	
	if stage == 1:
		$ConnectPipeSound.play()
		
	if stage == 2 && !succeeded:
		$SuccesSaltSound.play()
		succeeded = true
	
func get_difficulty_stages() -> Array[int]:
	return difficulty_stages
