extends ColorRect

@export var next_scene: PackedScene

func _ready() -> void:
	$AnimationPlayer.play("fade_in")

func transition_to(scene = next_scene) -> void:
	if not scene:
		return
		
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(scene)
