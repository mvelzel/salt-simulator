extends Node2D

@export var light: PointLight2D
@export var area: Area2D
@export var turn_on_animation: AnimationPlayer
		
var max_energy: float

func _ready() -> void:
	if light:
		max_energy = light.energy

func turn_on() -> void:
	if light and not light.enabled:
		light.enabled = true
		if turn_on_animation:
			light.energy = 0
			turn_on_animation.play("turn_on")
			
func turn_off() -> void:
	light.enabled = false
