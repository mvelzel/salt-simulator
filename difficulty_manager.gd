extends Node2D

var difficulty_stages: Array[int] = [0]

func add_difficulty_stage(stage: int):
	difficulty_stages.append(stage)
	
func get_difficulty_stages() -> Array[int]:
	return difficulty_stages
