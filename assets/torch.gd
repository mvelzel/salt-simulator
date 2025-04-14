extends Node2D

@export var light: PointLight2D
@export var area: Area2D
@export var turn_on_animation: AnimationPlayer
		
var registered = false
var max_energy: float

func _ready() -> void:
	if light:
		max_energy = light.energy

func _physics_process(_delta: float) -> void:
	if not registered:
		var overlapping_areas = area.get_overlapping_areas()
		for overlapping_area in overlapping_areas:
			if overlapping_area.has_method("register_light"):
				overlapping_area.register_light(self)
				light.enabled = false
		registered = true

func turn_on() -> void:
	if light and not light.enabled:
		light.enabled = true
		if turn_on_animation:
			light.energy = 0
			turn_on_animation.play("turn_on")
